variable "csp_uri" {
  type        = string
  description = "Base URL for VMware Cloud Service API endpoint"
  default     = "https://console.cloud.vmware.com"
}

variable "vmc_uri" {
  type        = string
  description = "Base URL for VMware Cloud Console API endpoint"
  default     = "https://vmc.vmware.com"
}

variable "debug" {
  type        = bool
  description = "Enable debugging"
}

variable "refresh_token" {
  type        = string
  description = "VMware Cloud Service Refresh Token"
  sensitive   = true
}

variable "org_id" {
  type        = string
  description = "VMware Cloud on AWS Organization ID"
  sensitive   = true
}

variable "sddc_id" {
  type        = string
  description = "VMware Cloud on AWS SDDC ID"
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "Name of SDDC Cluser to activate Tanzu services"
}

variable "ingress_cidr" {
  type        = string
  description = "This block of addresses is allocated to receive inbound traffic through load-balancers to containers. The system allocates a destination NAT (DNAT) address from this pool for each namespace in the cluster, so a span of /23 or /26 should be adequate."
}

variable "egress_cidr" {
  type        = string
  description = "This block of addresses is allocated to outbound traffic from containers and guest clusters. The system allocates a source NAT (SNAT) IP address from this pool for each namespace in the cluster, so a span of /23 or /26 should be adequate."
}

variable "service_cidr" {
  type        = string
  description = "This block of addresses is allocated to Tanzu supervisor services for the cluster. You can use the default CIDR block (10.96.0.0/24) or pick another one, but a span of at least /24 is required."
}

variable "namespace_cidr" {
  type        = string
  description = "This block of addresses is allocated to namespace segments. It should have a span of at least /23 to provide adequate capacity for Tanzu Kubernetes Grid workloads in the cluster. Consider a span of /16 or /12."
}