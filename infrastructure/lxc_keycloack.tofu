resource "proxmox_virtual_environment_container" "keycloak" {
  description = "Identity provider for whole server"

  node_name = "server"
  vm_id     = 8080

  # tags stored alphabetically. Keep that in mind otherwise your plan always have diff
  tags = [
    "alpine",
    "keycloack",
    "lxc"
  ]

  clone {
    full = false
    vm_id = 9998
  }

  unprivileged = true

  initialization {
    hostname = "keycloack-alpine-container"

    ip_config {
      ipv4 {
        address = "192.168.0.205/24"
        gateway = "192.168.0.1"
      }
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    swap      = 0
    dedicated = 2048
  }

  cpu {
    cores = 1
  }

  disk {
    datastore_id = "nvme-thin"
    size         = 4
  }

}