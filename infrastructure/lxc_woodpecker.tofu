resource "proxmox_virtual_environment_container" "woodpecker" {
  description = "Woodpecker CI server and worker"

  node_name = "server"
  vm_id     = 8000

  tags = [
    "alpine",
    "lxc",
    "woodpecker"
  ]

  clone {
    full = true
    vm_id = 9998
  }

  initialization {
    hostname = "woodpecker-alpine-container"

    ip_config {
      ipv4 {
        address = "192.168.0.202/24"
        gateway = "192.168.0.1"
      }
    }
  }

  network_interface {
    name = "eth0"
  }

  memory {
    swap      = 0
    dedicated = 40960
  }

  cpu {
    cores = 2
  }

  disk {
    datastore_id = "nvme-thin"
    size         = 10
  }

  features {
    keyctl = true
    nesting = true
  }
}