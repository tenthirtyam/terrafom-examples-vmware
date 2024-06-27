[Back: Home](README.md)

# Configure a Sample Project in VMware Aria Automation Assembler

You configure a project to define the users that can provision workloads, the priority and cloud zone of deployments, and the maximum allowed deployment instances.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Infrastructure** tab and, in the left pane, select **Administration > Projects**.

6. Click **New project**.

7. On the **Summary** tab, configure the settings.

    | **Setting**  | **Value**                |
    | :-           | :-                       |
    | Name         | Rainpole                 |
    | Description  | Sample Project: Rainpole |

8. Click the **Users** tab, and select **Deployments are shared between all users in the project**.

9. Click the **Provisioning** tab and, from the **Add zone** drop-down menu, select **Cloud zone**.

10. Configure these settings, and click **Add**.

    | **Setting**           | **Value**    |
    | :-                    | :-           |
    | Cloud zone            | sfo-w01-vc01 |
    | Provisioning priority | 1            |
    | Instances limit       | 0            |
    | Memory limit (GB)     | 0            |
    | CPU limit             | 0            |
    | Storage limit(GB)     | 0            |

11. On the **Provisioning** tab, under **Custom naming**, in the **Template** text box, enter the naming template for the machines in this project, **`${project.name}-${###}`**.

12. Click **Create**.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```bash
    cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/10-assembler-project
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

[Back: Configure Storage Profiles in VMware Aria Automation Assembler](9-configure-storage-profile.md)

[Next: Configure a Sample Cloud Template in VMware Aria Automation Assembler](11-configure-cloud-template.md)
