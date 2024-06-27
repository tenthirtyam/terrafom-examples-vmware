##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">= 1.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.1"
    }
    vra = {
      source  = "vmware/vra"
      version = ">= 0.7.3"
    }
  }
  required_version = ">= 1.2.0"
}
