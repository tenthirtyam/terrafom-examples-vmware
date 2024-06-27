[Back: Home](README.md)

# Configure Storage Profiles in VMware Aria Automation Assembler

You configure storage for the provisioned workloads by defining a storage profile in VMware Aria Automation Assembler for the specific cloud account and region.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Infrastructure** tab and, in the left pane, select **Configure > Storage profiles**.

6. On the **Storage profiles** page, click **New storage profile**, configure the settings, and click **Create**.

   | **Setting**                       | **Value**                                |
   | :-                                | :-                                       |
   | Account / region                  | sfo-w01-vc01 / Datacenter:datacenter-3   |
   | Name                              | standard-sfo-w01-cl01-vsan-default       |
   | Description                       | standard-sfo-w01-cl01-vsan-default       |
   | Disk type                         | Standard disk                            |
   | Storage policy                    | sfo-w01-cl01 vSAN Storage Policy         |
   | Datastore / cluster               | sfo-w01-sfo-w01-vc01-sfo-w01-cl01-vsan01 |
   | Provisioning type                 | Thin                                     |
   | Shares                            | Unspecified                              |
   | Limit IOPS                        | -                                        |
   | Disk mode                         | Dependent                                |
   | Preferred storage for this region | Selected                                 |
   | Capability tags                   | tier:platinum                            |

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/09-assembler-storage-profile
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

[Back: Configure Network Profiles for Existing Networks](8-configure-network-profile.md)

[Next: Configure a Sample Project in VMware Aria Automation Assembler](10-configure-project.md)
