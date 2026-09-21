terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.0.141:8006/"
  api_token = var.PM_AUTH_STRING
  insecure = true
}

variable "PM_AUTH_STRING" {
  type = string
  sensitive = true
}