[Back: Home](README.md)

# Configure Flavor Mappings in VMware Aria Automation Assembler

You configure flavor mappings to define different deployment sizings.

In the sample, the following flavor mappings are used:

| **Name**  | **Account / Region**                    | **CPU Count** | **Memory Size** |
| :-        | :-                                      | :-            | :-            |
| x-small   | sfo-w01-vc01 / Datacenter:datacenter-3  | 1             | 1 GB          |
| small     | sfo-w01-vc01 / Datacenter:datacenter-3  | 2             | 2 GB          |
| medium    | sfo-w01-vc01 / Datacenter:datacenter-3  | 4             | 8GB           |
| large     | sfo-w01-vc01 / Datacenter:datacenter-3  | 8             | 16 GB         |
| x-large   | sfo-w01-vc01 / Datacenter:datacenter-3  | 16            | 32 GB         |

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Infrastructure** tab and, in the left pane, select **Configure > Flavor mappings**.

6. Click **New flavor mapping** and configure these settings.

   | **Setting**       | **Value**                              |
   | :-                | :-                                     |
   | Flavor name       | x-small                                |
   | Account / region  | sfo-w01-vc01 / Datacenter:datacenter-3 |
   | Number of CPUs    | 1                                      |
   | Memory (GB)       | 1                                      |

7. Click **Create**

8. Repeat these steps for each of the remaining flavor mappings.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```bash
    cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/04-assembler-flavor-mapping
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

[Back: Configure a Customization Specification for Photon Operating Systems](3-configure-custom-specs.md)

[Next: Configure Image Mappings in VMware Aria Automation Assembler](5-configure-image-mappings.md)
