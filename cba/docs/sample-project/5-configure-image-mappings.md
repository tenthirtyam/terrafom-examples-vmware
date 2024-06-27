[Back: Home](README.md)

# Configure Image Mappings in VMware Aria Automation Assembler

You configure image mappings for images in content libraries.

In the sample, the following image mappings are used:

| Name            | Account / Region                        | Content Library / Image         |
| :-              | :-                                      | :-                              |
| photon-4.0      | sfo-w01-vc01 / Datacenter:datacenter-3  | sfo-cba-lib01 / photon-4.0      |
| photon-4.0-uefi | sfo-w01-vc01 / Datacenter:datacenter-3  | sfo-cba-lib01 / photon-4.0-uefi |

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Infrastructure** tab and, in the left pane, select **Configure > Image mappings**.

6. Click **New image mapping**, configure these settings.

   | **Setting**           | **Value**                               |
   | :-                    | :-                                      |
   | Image name            | photon-4.0                              |
   | Account / region      | sfo-w01-vc01 / Datacenter:datacenter-3  |
   | Image                 | sfo-cba-lib01 / photon-4.0              |
   | Constraints           | -                                       |
   | Cloud configuration   | -                                       |

7. Click **Create**.

8. Repeat these steps for each of the remaining image mappings.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/05-assembler-image-mapping
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

[Back: Configure Flavor Mappings in VMware Aria Automation Assembler](4-configure-flavour-mappings.md)

[Next: Configure NSX Overlay Segments to NSX-T Data Center](6-configure-nsx-segements.md)
