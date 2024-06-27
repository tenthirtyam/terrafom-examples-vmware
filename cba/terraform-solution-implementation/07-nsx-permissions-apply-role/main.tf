##################################################################################
# PROVIDERS
##################################################################################

provider "terracurl" {
  # Configuration options
}

##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

locals {
  base64_header = base64encode("${var.nsxt_username}:${var.nsxt_password}")
}

resource "terracurl_request" "nsx_create_user" {
  name           = "nsx_create_user"
  url            = "https://${var.nsxt_instance}/api/v1/aaa/role-bindings"
  method         = "POST"
  response_codes = [200, 301, 307, 400, 403, 409, 412, 500, 503]
  headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = "Basic ${local.base64_header}"
  }

  request_body = <<EOF
{
  "name": "${var.vidm_user}",
  "type": "${var.vidm_type}",
  "identity_source_type": "${var.vidm_identity_source}",
  "roles": [{
    "role": "${var.nsxt_role}"
  }]
}
EOF
}
