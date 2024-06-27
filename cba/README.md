![vvs](../icon.png)

# Cloud-Based Automation for VMware Cloud Foundation

## Table of Contents

- [Cloud-Based Automation for VMware Cloud Foundation](#cloud-based-automation-for-vmware-cloud-foundation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
    - [Terraform](#terraform)
    - [Installing Terraform Providers](#installing-terraform-providers)
  - [Get Started](#get-started)
    - [Clone the Repository](#clone-the-repository)
    - [Implementation of the Cloud-Based Automation for VMware Cloud Foundation](#implementation-of-the-cloud-based-automation-for-vmware-cloud-foundation)
    - [Setup the Sample Project in VMware Aria Automation](#setup-the-sample-project-in-vmware-aria-automation)
  - [Issues](#issues)

## Introduction

This content supports the [Cloud-Based Automation for VMware Cloud Foundation](https://core.vmware.com/cloud-based-automation-vmware-cloud-foundation) validated solution which enables a cloud-based infrastructure automation platform that delivers an agnostic self-service catalog for VMware Cloud Foundation and multi-cloud environments.

## Requirements

### Terraform

If you want to use the Terraform procedures to perform implementation and configuration procedures:

- Verify that your system has Terraform 1.2.0 or later installed. Learn more at [terraform.io](https://terraform.io).

- Verify the your system has a code editor installed. Microsoft Visual Studio Code is recommended. Learn more at [Visual Studio Code](https://code.visualstudio.com/).

- Install the Terraform Visual Studio Code extension 2.27.0 or later by HashiCorp for syntax highlighting and other editing features for Terraform files. Learn more at [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).

### Installing Terraform Providers

The Terraform providers used in this repository are official and verified providers. Official providers are managed by HashiCorp. Verified providers are owned and maintained by members of the HashiCorp Technology Partner Program. HashiCorp verifies the authenticity of the publisher and the providers are listed on the [Terraform Registry](https://registry.terraform.io) with a verified tier label.

Providers listed on the Terraform Registry can be automatically downloaded when initializing a working directory with `terraform init`. The Terraform configuration block is used to configure some behaviors of Terraform itself, such as the Terraform version and the required providers and versions.

However, some environments do not allow systems direct access to the Internet. The latest releases of the providers can be found on GitHub. You can download the appropriate version of the provider for your operating system using a command line shell or a browser and then prepare for "dark site" use.

## Get Started

### Clone the Repository

Clone `main` for the latest updates.

**Example**:

```bash
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

### Implementation of the Cloud-Based Automation for VMware Cloud Foundation

Each procedure contained within the **Cloud-Based Automation for VMware Cloud Foundation** implementation guide corresponds to a terraform plan contained within the *terraform-solution-implementation* folder, following the implementation guide you execute a number of manual steps which include:

- Copying the terraform.tfvars.example file to terraform.tfvars file.
- Updating the terraform.tfvars file with values from your Planning and Preparation Workbook.
- Initializing the terraform providers with the `terraform init` command.
- Previewing the actions Terraform will take to modify your infrastructure with the `terraform plan -out=tfplan` command.
- Applying the terraform plan to your environment with the `terraform apply tfplan` command.

To help simplify this end-to-end process, a PowerShell based menu has also been provided in the root folder, this menu not only reduces the manual typing of commands terraform command execution but also automates the process of creating and populating the terraform.tfvars file by extracting the required input values from the Planning and Preparation Workbook.

```powershell
.\cbaTerraformMenu.ps1 -workbook F:\MyLab\pnpWorkbook.xlsx -parentPath F:\validated-solutions-for-cloud-foundation\cba
```

### Setup the Sample Project in VMware Aria Automation

Once you have deployed the **Cloud-Based Automation for VMware Cloud Foundation** validated solution, you can use the step-by-step implementation guidance to create a **sample** project in VMware Aria Automation after deploying the solution using either the UI or infrastructure-as-code procedures.

No matter which path you choose to use - IaC or UI - the sample project implementation guidance can help you:

1. Learn how to get up and running with VMware Aria Automation.
2. Ensure the solution is operational.
3. Learn how to get started managing the desired state configuration of VMware Aria Automation using Terraform.

Learn more on how to [Configure a Sample Project in VMware Aria Automation](docs/sample-project/README.md).

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).
