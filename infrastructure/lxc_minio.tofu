resource "proxmox_virtual_environment_container" "minio" {
  description = "Minio storage container"

  node_name = "server"
  vm_id     = 9000

  # tags stored alphabetically. Keep that in mind otherwise your plan always have diff
  tags = [
    "alpine",
    "lxc",
    "minio"
  ]

  clone {
    full = false
    vm_id = 9998
  }

  unprivileged = true

  initialization {
    hostname = "minio-alpine-container"

    ip_config {
      ipv4 {
        address = "192.168.0.204/24"
        gateway = "192.168.0.1"
      }
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    swap      = 0
    dedicated = 4096
  }

  cpu {
    cores = 1
  }

  disk {
    datastore_id = "nvme-thin"
    size         = 2
  }

  mount_point {
    backup = true
    path   = "/mnt/data"
    size   = "100G"
    volume = "hdd1"
  }

}