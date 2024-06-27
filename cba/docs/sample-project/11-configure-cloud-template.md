[Back: Home](README.md)

# Configure a Sample Cloud Template in VMware Aria Automation Assembler

Cloud templates determine the specifications, such as target cloud region, resources, guest operating systems, and others, for the services or applications that consumers of this template can deploy.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

4. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile.

5. Click the **Design** tab and, in the left pane, click **Cloud templates**, and from the **New from** drop-down menu, select **Blank canvas**.

6. In the **New cloud template** dialog box, configure the settings and click **Create**.

  | **Setting**                               | **Value**                     |
  | :-                                        | :-                            |
  | Name                                      | Photon 4.0                    |
  | Description                               | Default Photon 4.0 OS         |
  | Project                                   | Rainpole                      |
  | Cloud template sharing in Service Broker  | Share only with this project  |

7. On the `Photon 4.0` template design page, in the **Code** tab, enter the following example YAML.

```yaml
name: Photon 4.0
formatVersion: 1
inputs:
  targetCloud:
    type: string
    oneOf:
      - title: VMware Cloud Foundation
        const: cloud:private
    title: Cloud
    description: Select a target cloud.
  targetRegion:
    type: string
    oneOf:
      - title: sfo-w01-vc01
        const: region:sfo
    title: Region
    description: Select a target region.
  targetEnvironment:
    type: string
    oneOf:
      - title: Production
        const: enabled:true
    title: Environment
    description: Select a target environment.
  targetFunction:
    type: string
    oneOf:
      - title: General Application
        const: function:general
    title: Function
    description: Select a target function.
  performanceTier:
    type: string
    oneOf:
      - title: Platinum
        const: tier:platinum
    title: Performance Tier
    description: Select a performance tier.
  operatingSystem:
    type: string
    oneOf:
      - title: Photon 4.0
        const: photon-4.0
      - title: photon 4.0 (UEFI)
        const: photon-4.0-uefi
    title: Operating System and Version
    description: Select a operating system and version.
  nodeSize:
    type: string
    oneOf:
      - title: X-Small
        const: x-small
      - title: Small
        const: small
      - title: Medium
        const: medium
      - title: Large
        const: large
      - title: X-Large
        const: x-large
    title: Node Size
  nodeCount:
    type: integer
    default: 1
    maximum: 5
    title: Node Count
    description: Select the number of VMs between 1 and 5.
resources:
  Cloud_vSphere_Machine_1:
    type: Cloud.vSphere.Machine
    properties:
      image: ${input.operatingSystem}
      flavor: ${input.nodeSize}
      count: ${input.nodeCount}
      customizationSpec: Photon-4.0
      constraints:
        - tag: ${input.targetCloud}
        - tag: ${input.targetRegion}
      networks:
        - network: ${resource.Cloud_NSX_Network_1.id}
          assignment: static
      attachedDisks: []
  Cloud_NSX_Network_1:
    type: Cloud.NSX.Network
    properties:
      networkType: existing
      constraints:
        - tag: ${input.targetEnvironment}
```

8. Test the cloud template.

  a. On the `Photon 4.0` template design page, click **Test**.

  b. In the **Testing Photon 4.0** dialog box, configure the settings and click **Test**.

  | **Setting**                   | **Value**                 |
  | :-                            | :-                        |
  | Cloud                         | VMware Cloud Foundation   |
  | Region                        | sfo-w01-vc01              |
  | Environment                   | Production                |
  | Function                      | General Application       |
  | Performance Tier              | Platinum                  |
  | Operating System and Version  | Photon 4.0                |
  | Node Size                     | X-Small                   |
  | Node Count                    | 1                         |

  c. Verify that the test finishes successfully, and close the window. 

9. Version the cloud template.

  a. On the `Photon 4.0` template design page, click **Version**.

  b. In the **Creating version** dialog box, configure the settings and click **Create**.

  | **Setting**                           | **Value**             |
  | :-                                    | :-                    |
  | Version                               | 1.0.0                 |
  | Description                           | Default Photon 4.0 OS |
  | Change log                            | Initial release       |
  | Release this version to the catalog   | Selected              |

  c. On the `Photon 4.0` template design page, click **Close**.

## Terraform Procedure

1. Navigate to the Terraform example in the repository.

  ```bash
  cd /validated-solutions-for-cloud-foundation/cba/terraform-sample-project/11-assembler-cloud-template
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

7. Test the cloud template by using the UI.

  a. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

  b. On the main navigation bar, click **Services**.

  c. Under **My services**, in the **VMware Aria Automation** card click **Launch Service**.

  d. On the **Welcome to VMware Aria Automation** page, click the **Assembler** tile. 
  
  e. Click the **Design** tab and, click the `Photon 4.0` template design page, click **Test**.

  f. In the **Testing Sample** dialog box, configure the settings and click **Test**.

  | Setting                       | Value                     |
  | :-                            | :-                        |
  | Cloud                         | VMware Cloud Foundation   |
  | Region                        | sfo-w01-vc01              |
  | Environment                   | Production                |
  | Function                      | General Application       |
  | Performance Tier              | Platinum                  |
  | Operating System and Version  | Photon 4.0                |
  | Node Size                     | X-Small                   |
  | Node Count                    | 1                         |

  g. Verify that the test finishes successfully, and close the window.

[Back: Configure a Sample Project in VMware Aria Automation Assembler](10-configure-project.md)

[Next: Configure a Content Source for the Project in VMware Aria Automation Service Broker](12-configure-content-source.md)