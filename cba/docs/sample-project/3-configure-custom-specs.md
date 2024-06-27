[Back: Home](README.md)

# Create a Customization Specification for Photon Operating Systems

Create a customization specification for the Photon Operating System, for use by the virtual machine images you deploy. You can use the customization specifications when you create cloud templates in VMware Aria Automation Assembler.

## UI Procedure

1. Log in to the VI workload domain vCenter Server at **`https://<vi_workload_domain_vcenter_server_fqdn>/ui`** with a user assigned the **Administrator** role.

2. From the **Menu** select **Policies and profiles**.

3. In the left pane, click **VM customization specifications**.

4. On the **VM customization specifications** page, click **New**.

5. On the **Name and target OS** page, configure the settings and click **Next**.

    | Setting                       | Example Value                 |
    | :-                            | :-                            |
    | Name                          | Photon-4.0                    |
    | Description                   | Photon 4.0 Operation System   |
    | vCenter Server                | sfo-w01-vc01.sfo.rainpole.io  |
    | Target guest OS               | Linux                         |

6. On the **Computer name** page, configure the settings and click **Next**.

    | Setting                       | Example Value                 |
    | :-                            | :-                            |
    | Use the virtual machine name  | Selected                      |
    | Domain name                   | sfo.rainpole.io               |

7. On the **Time zone** page, configure the settings and click **Next**.

    | Setting                       | Example Value                 |
    | :-                            | :-                            |
    | Area                          | America                       |
    | Location                      | Los Angeles                   |
    | Hardware clock set to         | Local time                    |

8. On the **Customization script** page, click **Next**.

9. On the **Network** page, click **Next**.

10. On the **DNS settings** page, click **Next**.

11. On the **Ready to complete** page, review the settings and click **Finish**.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/03-vsphere-customization-spec
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

[Back: Import Photon OS OVF Images to the Publishing Content Library](2-import-photon-template.md)

[Next: Configure Flavor Mappings in VMware Aria Automation Assembler](4-configure-flavour-mappings.md)
