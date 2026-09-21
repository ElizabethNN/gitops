resource "proxmox_virtual_environment_container" "nexus" {
  description = "Nexus lxc container"

  node_name = "server"
  vm_id     = 8081

  # tags stored alphabetically. Keep that in mind otherwise your plan always have diff
  tags = [
    "debian13",
    "lxc",
    "nexus"
  ]
  # TODO: Replace with full clone false
  clone {
    vm_id = 9999
  }

  unprivileged = true

  initialization {
    hostname = "nexus-debian-container"

    ip_config {
      ipv4 {
        address = "192.168.0.201/24"
        gateway = "192.168.0.1"
      }
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    swap      = 0
    dedicated = 8192
  }

  cpu {
    limit = 2
  }

  disk {
    datastore_id = "nvme-thin"
    size         = 4
  }

  mount_point {
    backup = true
    path   = "/mnt/data"
    size   = "100G"
    volume = "hdd1"
  }

}

import {
  id = "server/8081"
  to = proxmox_virtual_environment_container.nexus
}