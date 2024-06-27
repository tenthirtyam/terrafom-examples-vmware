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
  }
  required_version = ">= 1.2.0"
}
