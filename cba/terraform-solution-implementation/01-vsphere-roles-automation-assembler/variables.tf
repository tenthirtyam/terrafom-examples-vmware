##################################################################################
# VARIABLES
##################################################################################

# vSphere Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance"
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates"
  default     = false
}

# Aria Automation Assembler Role and Privileges

variable "assembler_vsphere_role" {
  type        = string
  description = "The name of the Aria Automation custom vSphere role. (e.g. Aria Automation Assembler to vSphere Integration)"
  default     = "Aria Automation Assembler to vSphere Integration"
}

variable "assembler_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the Aria Automation Assembler to vSphere Integration custom role"
}

# Aria Automation Orchestrator Role and Privileges

variable "orchestrator_vsphere_role" {
  type        = string
  description = "The name of the Aria Automation Orchestrator vSphere custom role. (e.g. Aria Automation Orchestrator to vSphere Integration)"
  default     = "Aria Automation Orchestrator to vSphere Integration"
}

variable "orchestrator_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the Aria Automation Orchestrator to vSphere Integration custom role"
}
