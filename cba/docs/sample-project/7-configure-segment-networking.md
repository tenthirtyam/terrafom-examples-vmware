[Back: Home](README.md)

# Configure Network IP Address Settings for Existing Networks

Each network profile is configured for a specific network port group or network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Infrastructure** tab and, in the left pane, select **Resources > Networks**.

6. Select the `sfo-prod-192-168-50-0-24` network object assigned to the NSX Local Manager.

7. Configure these settings, and click **Save**.

   | **Setting**           | **Value**                |
   | :-                    | :-                       |
   | Domain                | sfo.rainpole.io          |
   | DNS servers           | 172.16.11.4, 172.16.11.5 |
   | DNS search domains    | sfo.rainpole.io          |

8. Repeat this procedure for the NSX segment for development workloads.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/07-assembler-network-fabric
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

6. Import the current state of two existing networks, by obtaining the UUID from the Aria Automation Assembler console.

   a. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

   b. On the main navigation bar, click **Services**.

   c. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

   d. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

   e. Click the **Infrastructure** tab and, in the left pane, select **Resources > Networks**.

   g. Select the `sfo-prod-192-168-50-0-24` network object assigned to the NSX Local Manager.

   h. Using the browser URL obtain the UUID from the URL.

   i. Import the Production network using the ID displayed next to data.vra_fabric_compute.compute_id.terraform

   ```terraform
   terraform import vra_fabric_network_vsphere.network0 <UUID_of_sfo-prod-192-168-50-0-24>
   ```

   b. Repeat this procedure for the NSX segment for development workloads.

   ```terraform
   terraform import vra_fabric_network_vsphere.network1 <UUID_of_sfo-dev-192-168-51-0-24>
   ```

7. Create a Terraform plan and save the output to a file.

   ```terraform
   terraform plan -out=tfplan
   ```  

8. Apply the Terraform plan.

   ```terraform
   terraform apply tfplan
   ```

[Back: Configure NSX Overlay Segments to NSX-T Data Center](6-configure-nsx-segements.md)

[Next: Configure Network Profiles for Existing Networks](8-configure-network-profile.md)
