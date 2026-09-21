resource "proxmox_virtual_environment_container" "alpine-template" {
  description           = ""
  node_name             = "server"
  start_on_boot         = false
  started               = false
  tags                  = ["alpine", "lxc"]
  template              = true
  unprivileged          = true
  vm_id                 = 9998

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }
  disk {
    datastore_id  = "nvme-thin"
    size          = 2
  }
  initialization {
    hostname   = "alpine-template"
    ip_config {
      ipv4 {
        address = "192.168.0.202/24"
        gateway = "192.168.0.1"
      }
    }
  }
  memory {
    dedicated = 1024
    swap      = 0
  }
  network_interface {
    bridge       = "vmbr0"
    mac_address  = "BC:24:11:34:31:72"
    name         = "eth0"
  }
  operating_system {
    template_file_id = ""
    type             = "alpine"
  }
}

import {
  id = "server/9998"
  to = proxmox_virtual_environment_container.alpine-template
}