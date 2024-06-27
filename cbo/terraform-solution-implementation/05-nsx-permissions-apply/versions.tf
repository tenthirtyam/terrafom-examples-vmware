##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">= 1.1.0"
    }
  }
  required_version = ">= 1.2.0"
}
