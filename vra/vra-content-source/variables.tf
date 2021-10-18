##################################################################################
# VARAIBLES
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

variable "catalog_sources" {
  type = map(object({
    name         = string
    description  = string
    project_name = string
  }))
}