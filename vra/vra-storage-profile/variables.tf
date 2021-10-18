##################################################################################
# VARIABLES
##################################################################################

# Endpoints

variable "vra_url" {
  type        = string
  description = "The base URL of the vRealize Automation endpoint. (e.g. https://xint-vra01.rainpole.io)"
}

variable "vra_api_token" {
  type        = string
  description = "API token from the vRealize Automation endpoint."
  sensitive   = true
}

variable "vra_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# Cloud Assembly

variable "storage_profile_vsphere" {
  type = map(object({
    cloud_account_name   = string
    cloud_account_region = string
    name                 = string
    description          = string
    datastore            = string
    disk_type            = string
    default_item         = bool
    provisioning_type    = string
    storage_policy       = string
    tag_tier             = string
  }))
  description = "A mapping of objects for Storage Profiles for vSphere and their associated settings."
}