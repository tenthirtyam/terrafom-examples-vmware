##################################################################################
# PROVIDERS
##################################################################################


##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

resource "null_resource" "create_custom_spec" {
  provisioner "local-exec" {
    command     = <<EOT
    Connect-VIServer -Server ${var.vsphere_server} -User "${var.vsphere_username}" -Password "${var.vsphere_password}" | Out-Null
    New-OSCustomizationSpec -Name "${var.customization_name}" -Description "${var.customization_description}" -OSType "${var.customization_type}"  -NamingScheme vm -Domain "${var.customization_domain}"
    $customizationSpec = Get-View -Id 'CustomizationSpecManager-CustomizationSpecManager'
    $item = $customizationSpec.GetCustomizationSpec("${var.customization_name}")
    $item.Spec.Identity.HwClockUTC = $false
    $item.Spec.Identity.TimeZone = "${var.customization_timezone}"
    $customizationSpec.OverwriteCustomizationSpec($item)
    Disconnect-VIServer -Server ${var.vsphere_server} -Confirm:$false
    EOT 
    interpreter = ["PowerShell", "-Command"]
  }
}