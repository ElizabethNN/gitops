terraform {
  backend "s3" {
    bucket = "terraform-state"
    use_lockfile = true
    key = "state.tfstate"
    region = "us-east-1" #doesn't really matter for backend since its self-hosted S3
    endpoints = {
      s3 = "s3.kitara.space"
    }

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
    minio = {
      source = "aminueza/minio"
      version = "3.43.0"
    }
  }
}

provider "minio" {
  minio_server = "s3.kitara.space"
  minio_ssl = true
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