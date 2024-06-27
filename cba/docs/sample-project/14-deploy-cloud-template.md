[Back: Home](README.md)

# Deploy a Sample Cloud Template from VMware Aria Automation Service Broker

After you import the cloud template and share it with members of your project, you test the provisioning by requesting a deployment.

## Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Service Broker** card click **Launch Service**.

4. On the **Catalog** tab, in the `Photon 4.0` card, click **Request**.

5. On the **New request** page, configure the settings and click **Submit**.

    | **Setting**                   | **Value**                 |
    | :-                            | :-                        |
    | Project                       | Rainpole                  |
    | Deployment Name               | MyPhotonVM                |
    | Node Size                     | X-Small                   |
    | Node Count                    | 1                         |
    | Cloud                         | VMware Cloud Foundation   |
    | Region                        | sfo-w01-vc01              |
    | Function                      | General Application       |
    | Performance Tier              | Platinum                  |
    | Operating System and Version  | Photon 4.0                |
    | Environment                   | Production                |

6. Verify that the deployment completed successfully.

    a. Click the **Deployments > Deployments** and click `MyPhotonVM`. 

    b. Click the **History** tab and click the **Request details** tab.

7. Verify that the table shows the applied cloud template constraint tags.

8. When the deployment completes, verify that the deployment card has the Create successful tag.

![Skylar is happy!](../images/illustration-success.png)
