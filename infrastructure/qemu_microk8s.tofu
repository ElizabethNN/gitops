locals {
  # Every non-empty, non-comment line of trusted_keys.pub becomes one key
  microk8s_ssh_keys = [
    for k in split("\n", file("${path.module}/../files/trusted_keys.pub")) :
    trimspace(k) if trimspace(k) != "" && !startswith(trimspace(k), "#")
  ]
}

resource "proxmox_virtual_environment_file" "microk8s_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "server"

  source_raw {
    file_name = "microk8s-cloud-init.yaml"
    data = templatefile("${path.module}/../files/cloud-init.yaml", {
      hostname = "microk8s"
      ssh_keys = local.microk8s_ssh_keys
      ssh_port = "2224"

      # Whole disk as ext4, no partition table. overwrite=false: never reformats existing data
      fs_setup = [
        {
          label      = "k8s-pv"
          filesystem = "ext4"
          device     = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1"
          partition  = "none"
          overwrite  = false
        }
      ]

      mounts = [
        ["LABEL=k8s-pv", "/var/snap/microk8s/common/default-storage", "ext4", "defaults,nofail", "0", "2"]
      ]
    })
  }
}

resource "proxmox_virtual_environment_vm" "microk8s" {
  name        = "microk8s"
  description = "MicroK8s node (Ubuntu 26.04)"

  node_name = "server"
  vm_id     = 206

  # tags stored alphabetically. Keep that in mind otherwise your plan always have diff
  tags = [
    "k8s",
    "microk8s",
    "qemu",
    "ubuntu"
  ]

  on_boot = true
  started = true

  machine       = "q35"
  bios          = "seabios"
  scsi_hardware = "virtio-scsi-single"

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 4
    type  = "host"
  }

  memory {
    dedicated = 32768
  }

  # Root disk: created from the cloud image, grown to 20G (cloud-init expands the partition)
  disk {
    datastore_id = "nvme-thin"
    interface    = "scsi0"
    file_id      = "local:iso/resolute-server-cloudimg-amd64.img"
    file_format  = "raw"
    size         = 20
    iothread     = true
    discard      = "on"
    ssd          = true
  }

  # Data disk for MicroK8s hostpath PVs (formatted and mounted by cloud-init)
  disk {
    datastore_id = "hdd1"
    interface    = "scsi1"
    file_format  = "raw"
    size         = 50
    iothread     = true
    backup       = true
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    datastore_id = "nvme-thin"

    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = "192.168.0.206/24"
        gateway = "192.168.0.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.microk8s_cloud_init.id
  }
}