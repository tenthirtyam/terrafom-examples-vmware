[Back: Home](README.md)

# Configure NSX Overlay Segments to NSX-T Data Center

Before project members can request workloads on existing networks, you must add the network segments to the VI workload domain NSX Local Manager.

NSX Segments for Existing Networks

| **Setting**       | **Production Workloads**                 | **Development Workloads**                |
| :-                | :-                                       | :-                                       |
| Segment name      | sfo-prod-192-168-50-0-24                 | sfo-dev-192-168-51-0-24                  |
| Connected gateway | sfo-w01-ec01-t1-gw01                     | sfo-w01-ec01-t1-gw01                     |
| Transport zone    | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io |
| Subnets           | 192.168.50.1/24                          | 192.168.51.1/24                          |

## UI Procedure

1. Log in to the NSX Local Manager cluster for the VI workload domain at **`https://<vi_workload_nsx_local_manager_fqdn>/login.jsp?local=true`** as **admin**.

2. On the main navigation bar, click **Networking**.

3. In the navigation pane, under **Connectivity**, click **Segments**.

4. On the **Segments** tab, click **Add segment**, configure these settings and click **Save**.

   | **Setting**                 | **Value**                                |
   | :-                          | :-                                       |
   | Segment name                | sfo-prod-192-168-50-0-24                 |
   | Connected gateway           | sfo-w01-ec01-t1-gw01                     |
   | Transport zone              | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io |
   | Subnets (Gateway CIDR IPv4) | 192.168.50.1/24                          |
   | Admin state                 | Turned on                                |

5. In the **Want to continue configuring this Segment?** dialog box, click **No**.

6. Repeat this procedure for the NSX segment for development workloads.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/06-nsx-network-create-segment
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

[Back: Configure Image Mappings in VMware Aria Automation Assembler](5-configure-image-mappings.md)

[Next: Configure Network IP Address Settings for Existing Networks](7-configure-segment-networking.md)
