# Terraform Examples for VMware Solutions

## Introduction

This repository provides infrastructure-as-code examples to automate the creation of resources on VMware products / solutions.

Examples are provided for the following:

**VMware Cloud Services**
- Cloud Proxy for Skyline
- Cloud Proxy for vRealize Operations Cloud
- Cloud Proxy for vRealize Log Insight Cloud
- Cloud Proxy for vRealize Network Insight Cloud
- Cloud Proxy for vRealize Automation Cloud
- Cloud Extensibility Proxy for vRealize Automation Cloud

**VMware vSphere**
- vSphere Content Library
  - Publisher
  - Subscriber
  - Subscriber for Tanzu
  - Items
- vSphere DRS Anti-Affinty Rules
- vSphere DRS VM-VM Rules
- vSphere Folders
- vSphere Folders and Resource Pools
- vSphere HA VM-Host Groups
- vSphere HA VM Overrides
- vSphere Custom Roles for vRealize Suite
- vSphere Custom Role for Packer
- vSphere dvPortGroup for NFS Storage
- vSphere NFS Datastore
- vSphere Storage Policy for Tanzu


**VMware NSX-T Data Center**
- NSX Segments for Existing Networks in vRealize Automation
- NSX Segments for On-Demand Networks in vRealize Automation

**VMware vRealize Automation**
- Cloud Accounts
  - vCenter Server
  - NSX-T Data Center
- Image Mappings
- Flavor Mappings
- Storage Profiles
- Network Profiles
  - Existing Networks
  - On-Demand Networks
- Fabric Networks
  - Existing Networks
  - On-Demand Networks
- Cloud Template
- Projects
- Content Source
- Content Item

## Getting Started

If you'd like to automate the creation of the custom vSphere role, a Terraform example is included in the project.

1. Clone the repository.

```
git clone https://github.com/tenthirtyam/terraform-examples-vmware.git
```

2. Navigate to the directory for the example.

```
cd terraform-examples-vmware/vsphere/vsphere-roles-vrealize
```

3. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

```
cp terraform.tfvars.example terraform.tfvars
```

4. Open the `terraform.tfvars` file and update the variables according to your environment.

5. Initialize the current directory and the required Terraform provider for VMware vSphere.

```
terraform init
```

6. Create a Terraform plan and save the output to a file.

```
terraform plan -out=tfplan
```

6. Apply the Terraform plan.

```
terraform apply tfplan
```

## Author

The following are active maintainers of this repository.

* [Ryan Johnson](https://github.com/tenthirtyam), Staff Solutions Architect, VMware, Inc.