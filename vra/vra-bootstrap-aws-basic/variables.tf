##################################################################################
# ENDPOINT
##################################################################################

variable vra_url {
  type        = string
  description = ""
  default     = "https://api.mgmt.cloud.vmware.com"
}

variable vra_api_token {
  type        = string
  description = ""
}

##################################################################################
# CREDENTIALS
##################################################################################

# Amazon Web Services

variable aws_access_key {
  type        = string
  description = ""
}

variable aws_secret_key {
  type        = string
  description = ""
}

variable aws_regions {
  type        = list(string)
  description = ""
}

variable aws_name {
  type        = string
  description = ""
}

variable aws_description {
  type        = string
  description = ""
}