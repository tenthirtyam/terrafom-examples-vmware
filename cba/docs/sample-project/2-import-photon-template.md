[Back: Home](README.md)

# Import Photon OS OVF Images to the Publishing Content Library

Import virtual machine images in OVA format into a publishing content vSphere library to use for image mappings in VMware Aria Automation Assembler.

In the sample, the following operating system images are used:

   | **Operating System** | **Virtual Machine Template Name** |
   | :-                   | :-                                |
   | Photon OS            | photon-4.0                        |
   | Photon OS            | photon-4.0-uefi                   |

## UI Procedure

1. Log in to vCenter Server at **`https://<vi_workload_domain_vcenter_server_fqdn>/ui`** with a user assigned the **Administrator** role.

2. In the **Content libraries** inventory, click the content library `sfo-cba-lib01`.

3. From the **Actions** menu, select **Import item**.

4. In the **Import library item** page, select **URL** as the source file and enter the URL for the OVA file and click **Import.**

5. If a SSL certificate warning is displayed, select **Action** and then **Continue**..

6. Repeat the procedure for the second virtual machine template.

## Terraform

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/02-vsphere-content-library-items
   ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

   ```bash
   copy terraform.tfvars.example terraform.tfvars
   ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. Initialize the current directory and the required Terraform providers.

   ```terraform
   terraform init
   ```

5. Create a Terraform plan and save the output to a file.

   ```terraform
   terraform plan -out=tfplan
   ```  

6. Apply the Terraform plan.

   ```terraform
   terraform apply tfplan
   ```

## What to do next?

Initialize an on-demand image synchronization for the vCenter Server cloud account in Aria Automation Assembler.

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Select the **Infrastructure** tab and, in the left pane, select **Connections > Cloud accounts**.

6. In the card for the VI workload domain vCenter Server cloud account and click **Open**.

7. On the cloud account page, click **Sync images**.

[Back: Configure a Publishing Content Library](1-configure-content-libraries)

[Next: Configure a Customization Specification for Photon Operating Systems](3-configure-custom-specs.md)
