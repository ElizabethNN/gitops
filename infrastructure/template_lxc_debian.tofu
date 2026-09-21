resource "proxmox_virtual_environment_container" "deb13-template" {
  description           = "Basic debian 13 with:\n- Installed node exporter, curl, nano\n- sshd removed password auth, moved to 2224 port\n- updated packages\n- changed timezone\n"
  node_name             = "server"
  pool_id               = null
  start_on_boot         = false
  started               = false
  tags                  = ["debian13", "lxc"]
  template              = true
  unprivileged          = true
  vm_id                 = 9999
  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }
  disk {
    datastore_id  = "nvme-thin"
    mount_options = []
    size          = 8
  }
  initialization {
    hostname   = "deb13-template"
    ip_config {
      ipv4 {
        address = "192.168.0.201/24"
        gateway = "192.168.0.1"
      }
    }
  }
  memory {
    dedicated = 4096
    swap      = 0
  }
  network_interface {
    bridge       = "vmbr0"
    mac_address  = "BC:24:11:E6:AE:40"
    name         = "eth0"
  }
  operating_system {
    template_file_id = ""
    type             = "debian"
  }
}