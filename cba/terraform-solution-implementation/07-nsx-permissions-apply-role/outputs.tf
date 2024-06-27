##################################################################################
# OUTPUTS
##################################################################################

output "nsx_response" {
  value = jsondecode(terracurl_request.nsx_create_user.response)
}

output "nsx_user_id" {
  value = jsondecode(terracurl_request.nsx_create_user.response).id
}
