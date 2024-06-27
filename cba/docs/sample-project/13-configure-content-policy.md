[Back: Home](README.md)

# Share a Content Source for the Project in VMware Aria Automation Service Broker

You can share cloud templates and content sources within a project to enable project members to deploy these cloud templates in supported cloud zones.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Service Broker** card click **Launch Service**.

4. Click the **Content and policies** tab.

5. In the navigation pane, click **Policies > Definitions**.

6. In the **Definitions** page, click the **New policy**.

7. In the **Policy types** page, click **Content sharing policy**.

8. In the  **New policy** page, configure the settings and click **Create**.

    | **Setting**                                          | **Value**                     |
    | :-                                                   | :-                            |
    | Name                                                 | Rainpole Content Sharing      |
    | Description                                          | Content for Project: Rainpole |
    | Scope                                                | Rainpole                      |
    | Content Sharing                                      | Photon 4.0                    |
    | Share (content) with all users/groups in the project | Enabled                       |

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```bash
    cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/13-cloud-assembly-content-sharing
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

[Back: Configure a Content Source for the Project in VMware Aria Automation Service Broker](12-configure-content-source.md)

[Next: Deploy a Sample Cloud Template in VMware Aria Automation Service Broker](14-deploy-cloud-template.md)
