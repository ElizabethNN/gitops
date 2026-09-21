resource "proxmox_virtual_environment_container" "caddy" {
  description = "Caddy reverse proxy container"

  node_name = "server"
  vm_id     = 443

  # tags stored alphabetically. Keep that in mind otherwise your plan always have diff
  tags = [
    "alpine",
    "caddy",
    "lxc"
  ]
  # TODO: Replace with full clone false
  clone {
    vm_id = 9998
  }

  unprivileged = true

  initialization {
    hostname = "caddy-alpine-container"

    ip_config {
      ipv4 {
        address = "192.168.0.203/24"
        gateway = "192.168.0.1"
      }
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    swap      = 0
    dedicated = 1024
  }

  cpu {
    limit = 2
  }

  disk {
    datastore_id = "nvme-thin"
    size         = 2
  }

}

import {
  id = "server/443"
  to = proxmox_virtual_environment_container.caddy
}