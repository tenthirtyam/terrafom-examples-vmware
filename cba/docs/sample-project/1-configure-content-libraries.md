[Back: Home](README.md)

# Configure a Publishing Content Library

Create a content library for storing the images that you can then use to deploy virtual machines in your environment. You enable publishing for the content library, so that you can synchronize the images among different VI workload domain vCenter Server instances and ensure that all images in your environment are consistent.

## UI Procedure

1. Log in to the VI workload domain vCenter Server at **`https://<vi_workload_domain_vcenter_server_fqdn>/ui`** with a user assigned the **Administrator** role.

2. In the **Content libraries** inventory, click **Create**.

3. On the **Name and location** page, configure the settings and click **Next**.

   | **Setting**     | **Value**                                             |
   | :-              | :-                                                    |
   | Name            | sfo-cba-lib01                                         |
   | Notes           | Publishing Content Library for VMware Aria Automation |
   | vCenter Server  | sfo-w01-vc01.sfo.rainpole.io                          |

4. On the **Configure content library** page, configure the settings and click **Next**.

   | **Setting**            | **Value**   |
   | :-                     | :-          |
   | Local content library  | Selected    |
   | Enable publishing      | Selected    |
   | Enable authentication  | Disabled    |

5. On the **Apply security policy** page, click **Next**.

6. On the **Add storage** page, select the storage location `sfo-w01-sfo-w01-vc01-sfo-w01-cl01-vsan01` and click **Next**.

7. On the **Ready to complete** page, click **Finish**.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```bash
   cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/01-vsphere-content-library-publishing
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

[Back: Home](README.md)

[Next: Import Photon OS OVF Images to the Publishing Content Library](2-import-photon-template.md)