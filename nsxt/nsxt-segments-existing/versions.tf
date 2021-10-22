##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.2.1"
    }
  }
  required_version = ">= 1.0.0"
}