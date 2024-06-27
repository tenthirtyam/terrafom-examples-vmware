# Copyright 2023 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<#
    .NOTES
    ===================================================================================================================
    Created by: Gary Blake - Senior Staff Solutions Architect
    Date:       2022-10-21
    ===================================================================================================================
    .CHANGE_LOG

    - 1.1.0 (Gary Blake / 2023-04-28) - Updated for VMware Aria Automation Branding
                                        Improvements to PowerShell prerequisite checking

    ===============================================================================================================
    .SYNOPSIS
    Menu for Executing Terraform Plans Under Cloud-Based Automation for VMware Cloud Foundation validated solution

    .DESCRIPTION
    The cbaTerraformMenu.ps1 provides a menu for executing the Terraform plans that support the implementation of the 
    Cloud-Based Automation for VMWare Cloud Foundation validated solution. Each menu item reads the Planning and
    Preparation Workbook to populate the terraform.tfvars.template file then attempts to apply the Terraform plan.

    .EXAMPLE
    cbaTerraformMenu.ps1 -workbook F:\vvs\PnP.xlsx -parentPath F:\vvs\cba
    This example loads the Cloud-Based Automation for VMware Cloud Foundation PowerShell menu
#>

Param (
    [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$workbook,
    [Parameter (Mandatory = $true)] [ValidateNotNullOrEmpty()] [String]$parentPath
)

#Region    Supporting Functions

Function Test-CbaMenuPrereq {
    <#
		.SYNOPSIS
        Validate prerequisites to run the PowerShell module

        .DESCRIPTION
        The Test-CbaMenuPrereq cmdlet checks that all the prerequisites have been met to run the PowerShell module

        .EXAMPLE
        Test-CbaMenuPrereq
        This example runs the prerequisite validation
    #>

    Try {
        $modules = @(
            @{ Name=("VMware.PowerCLI"); MinimumVersion=("12.7.0")}
            @{ Name=("VMware.vSphere.SsoAdmin"); MinimumVersion=("1.3.9")}
            @{ Name=("PowerVCF"); MinimumVersion=("2.3.0")}
            @{ Name=("PowerValidatedSolutions"); MinimumVersion=("2.2.0")}
            @{ Name=("WriteAscii"); MinimumVersion=("1.2.2")}
        )

        foreach ($module in $modules ) {
            if ((Get-InstalledModule -ErrorAction SilentlyContinue -Name $module.Name).Version -lt $module.MinimumVersion) {
                $message = "PowerShell Module: $($module.Name) $($module.MinimumVersion) minimum required version is not installed"
                Show-CbaMenuLogMessage -type ERROR -message $message
                $failedPrereq = "True"
            } else {
                $moduleCurrentVersion = (Get-InstalledModule -Name $module.Name).Version
                $message = "PowerShell Module: $($module.Name) $($moduleCurrentVersion) is installed and supports the minimum required version"
                Show-CbaMenuLogMessage -type INFO -message $message
            }
        }
        if ($failedPrereq -eq $true) {
            Break
        }
    }
    Catch {
        Write-Error $_.Exception.Message
    }
}

Function Show-CbaMenuLogMessage {
    Param (
        [Parameter (Mandatory = $true)] [AllowEmptyString()] [String]$message,
        [Parameter (Mandatory = $false)] [ValidateSet("INFO", "ERROR", "WARNING", "EXCEPTION","ADVISORY","NOTE","QUESTION","WAIT")] [String]$type = "INFO",
        [Parameter (Mandatory = $false)] [Switch]$skipnewline
    )

    If ($type -eq "INFO") {
        $messageColour = "92m" #Green
    } elseIf ($type -in "ERROR","EXCEPTION") {
        $messageColour = "91m" # Red
    } elseIf ($type -in "WARNING","ADVISORY","QUESTION") {
        $messageColour = "93m" #Yellow
    } elseIf ($type -in "NOTE","WAIT") {
        $messageColour = "97m" # White
    }

    $ESC = [char]0x1b
    $timestampColour = "97m"

    $timeStamp = Get-Date -Format "MM-dd-yyyy_HH:mm:ss"

    If ($skipnewline) {
        Write-Host -NoNewline "$ESC[${timestampcolour} [$timestamp]$ESC[${threadColour} $ESC[${messageColour} [$type] $message$ESC[0m"
    } else {
        Write-Host "$ESC[${timestampcolour} [$timestamp]$ESC[${threadColour} $ESC[${messageColour} [$type] $message$ESC[0m"
    }
}

Function anyKey {
    Write-Host ''; Write-Host -Object ' Press any key to continue/return to menu...' -ForegroundColor Yellow; Write-Host '';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

Function executeTerraformPlan {
    Param ( 
        [Parameter(Mandatory=$true)] [String]$planDirectory,
        [Parameter(Mandatory=$false)] [Switch]$planOnly,
        [Parameter(Mandatory=$false)] [Switch]$skipCheck
    )

    Try {
        $originalLocation = Get-Location
        $GlobaL:origEnvPath = $env:path
        $env:path = $origEnvPath+";C:\Users\All Users\chocolatey\bin"
        Set-Location -Path $planDirectory
        if (!(Test-Path -Path ".terraform.lock.hcl")) {
            Show-CbaMenuLogMessage -type INFO -message "Installing the Terrform Providers (terraform init)"
            $terraformOutput = Invoke-Expression "terraform init"
        } else {
            Show-CbaMenuLogMessage -type NOTE -message "Installing the Terrform Providers (terraform init), already installed : SKIPPED"
        }

        if ($PsBoundParameters.ContainsKey("skipCheck")) {
            Show-CbaMenuLogMessage -type NOTE -message "Generating Terraform Plan (terraform plan -out=tfplan)"
            $terraformOutput += Invoke-Expression "terraform plan -out=tfplan"
            Show-CbaMenuLogMessage -type NOTE -message "Applying Terraform Plan (terraform apply tfplan)"
            $terraformOutput += Invoke-Expression "terraform apply tfplan" 
            $terraformOutput | Out-File "terraform-output.log"
            Show-CbaMenuLogMessage -type INFO -message "Attempting to apply Terraform plan ($($($planDirectory.Split('\')[-1]))), $(($terraformOutput | Select-String -Pattern "Apply complete")[-1]): SUCCESSFUL"
        } else {
            if (!(Test-Path -Path "terraform.tfstate")) {
                if (Test-Path -Path "tfplan") {
                    Remove-Item "tfplan" -Confirm:$false
                }
                Show-CbaMenuLogMessage -type NOTE -message "Generating Terraform Plan (terraform plan -out=tfplan)"
                $terraformOutput += Invoke-Expression "terraform plan -out=tfplan"
                if ($PsBoundParameters.ContainsKey("planOnly")) {
                    return
                }
                Show-CbaMenuLogMessage -type NOTE -message "Applying Terraform Plan (terraform apply tfplan)"
                $terraformOutput += Invoke-Expression "terraform apply tfplan" 
                $terraformOutput | Out-File "terraform-output.log"
                if (Test-Path -Path "terraform.tfstate") {
                    Show-CbaMenuLogMessage -type INFO -message "Attempting to apply Terraform plan ($($($planDirectory.Split('\')[-1]))), $(($terraformOutput | Select-String -Pattern "Apply complete")[-1]): SUCCESSFUL"
                } else {
                    Show-CbaMenuLogMessage -type ERROR -message "Attempting to apply Terraform plan ($($($planDirectory.Split('\')[-1]))), see 'terraform-output.log': PRE_VALIDATION_FAILED"
                }
            } else {
                Show-CbaMenuLogMessage -type NOTE -message "Attempting to apply Terraform plan ($($($planDirectory.Split('\')[-1]))), already applied: SKIPPED"
            }
        }
        $env:path = $origEnvPath
        Set-Location -path $originalLocation
    } Catch {
        Debug-CatchWriter -object $_
    }
}

#EndRegion Supporting Functions

#Region     Solution Implementation

Function createCbaVsphereRoles {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    Try {
        if (Test-Path -path $workbook) {
            if (Test-Path -path $planPath) {
                $pnpWorkbook = Open-ExcelPackage -Path $Workbook
                $templateFile = "$planPath\terraform.tfvars.template"
                $templateContents = Get-Content $templateFile   
                $templateContents | ForEach-Object { $_ `
                    -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                    -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                    -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                    -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER ROLE NAME-->',$pnpWorkbook.Workbook.Names["vmc_ca_vsphere_role_name"].Value `
                    -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR ROLE NAME-->',$pnpWorkbook.Workbook.Names["vmc_vro_vsphere_role_name"].Value `
                } | Set-Content -Path "$planPath\terraform.tfvars"
                Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
                executeTerraformPlan -planDirectory $planPath
            }
        }
    } Catch {
        Debug-CatchWriter -object $_
    }
}

Function createCbaApplianceFolder {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    Try {
        if (Test-Path -path $workbook) {
            if (Test-Path -path $planPath) {
                $pnpWorkbook = Open-ExcelPackage -Path $Workbook
                $templateFile = "$planPath\terraform.tfvars.template"
                $templateContents = Get-Content $templateFile   
                $templateContents | ForEach-Object { $_ `
                    -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                    -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                    -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                    -replace '<!--REPLACE WITH MANAGEMENT DATACENTER-->',$pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value `
                    -replace '<!--REPLACE WITH CLOUD BASED AUTOMATION FOLDER-->',$pnpWorkbook.Workbook.Names["vmc_vm_folder"].Value `
                } | Set-Content -Path "$planPath\terraform.tfvars"
                Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
                executeTerraformPlan -planDirectory $planPath
            }
        }
    } Catch {
        Debug-CatchWriter -object $_
    }
}

Function createCbaWorkloadFolders {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    Try {
        if (Test-Path -path $workbook) {
            if (Test-Path -path $planPath) {
                $pnpWorkbook = Open-ExcelPackage -Path $Workbook
                $templateFile = "$planPath\terraform.tfvars.template"
                $templateContents = Get-Content $templateFile   
                $templateContents | ForEach-Object { $_ `
                    -replace '<!--REPLACE WITH WORKLOAD VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["wld_vc_fqdn"].Value `
                    -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                    -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD DATACENTER-->',$pnpWorkbook.Workbook.Names["wld_datacenter"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD CLUSTER-->',$pnpWorkbook.Workbook.Names["wld_cluster"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_vm_folder"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD STORAGE LOCAL FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_storage_folder"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD STORAGE READ ONLY FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_storage_readonly_folder"].Value `
                    -replace '<!--REPLACE WITH WORKLOAD RESOURCE POOL-->',$pnpWorkbook.Workbook.Names["wld_vmc_vm_rp"].Value `
                } | Set-Content -Path "$planPath\terraform.tfvars"
                Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
                executeTerraformPlan -planDirectory $planPath
            }
        }
    } Catch {
        Debug-CatchWriter -object $_
    }
}

Function applyCbaGlobalPermissions {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH SDDC MANAGER FQDN-->',$pnpWorkbook.Workbook.Names["sddc_mgr_fqdn"].Value `
                -replace '<!--REPLACE WITH SDDC MANAGER USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SDDC MANAGER PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH DOMAIN FQDN-->',$pnpWorkbook.Workbook.Names["region_ad_child_fqdn"].Value `
                -replace '<!--REPLACE WITH DOMAIN BIND USER-->',$pnpWorkbook.Workbook.Names["child_svc_vsphere_ad_user"].Value `
                -replace '<!--REPLACE WITH DOMAIN BIND PASSWORD-->',$pnpWorkbook.Workbook.Names["child_svc_vsphere_ad_password"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER SERVICE ACCOUNT-->',$pnpWorkbook.Workbook.Names["user_svc_ca_vsphere"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER ROLE NAME-->',$pnpWorkbook.Workbook.Names["vmc_ca_vsphere_role_name"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR SERVICE ACCOUNT-->',$pnpWorkbook.Workbook.Names["user_svc_vmc_vro_vsphere"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR ROLE NAME-->',$pnpWorkbook.Workbook.Names["vmc_vro_vsphere_role_name"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function applyCbaMgmtRestrictions {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["region_ad_child_netbios"].Value + "\\" + $pnpWorkbook.Workbook.Names["user_svc_ca_vsphere"].Value) `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["region_ad_child_netbios"].Value + "\\" + $pnpWorkbook.Workbook.Names["user_svc_vmc_vro_vsphere"].Value) `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function applyCbaWldRestrictions {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH WORKLOAD VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["wld_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH WORKLOAD DATACENTER-->',$pnpWorkbook.Workbook.Names["wld_datacenter"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["region_ad_child_netbios"].Value + "\\" + $pnpWorkbook.Workbook.Names["user_svc_ca_vsphere"].Value) `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["region_ad_child_netbios"].Value + "\\" + $pnpWorkbook.Workbook.Names["user_svc_vmc_vro_vsphere"].Value) `
                -replace '<!--REPLACE WITH WORKLOAD DATACENTER-->',$pnpWorkbook.Workbook.Names["wld_datacenter"].Value `
                -replace '<!--REPLACE WITH WORKLOAD EDGE FOLDER-->',$pnpWorkbook.Workbook.Names["wld_user_edge_vm_folder"].Value `
                -replace '<!--REPLACE WITH WORKLOAD STORAGE LOCAL FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_storage_folder"].Value `
                -replace '<!--REPLACE WITH WORKLOAD STORAGE READ ONLY FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_storage_readonly_folder"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function applyCbaNsxPermissions {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH WORKLOAD NSX MANAGER FQDN-->',$pnpWorkbook.Workbook.Names["wld_nsxt_vip_fqdn"].Value `
                -replace '<!--REPLACE WITH WORKLOAD NSX MANAGER ADMIN PASSWORD-->',$pnpWorkbook.Workbook.Names["nsxt_lm_admin_password"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["user_svc_vmc_nsx"].Value + "@" + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function deployCbaProxy {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH ESXI HOST-->',($pnpWorkbook.Workbook.Names["mgmt_az1_host1_hostname"].Value + "." + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH MANAGEMENT DATACENTER-->',$pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value `
                -replace '<!--REPLACE WITH CLOUD BASED AUTOMATION FOLDER-->',$pnpWorkbook.Workbook.Names["vmc_vm_folder"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT CLUSTER-->',$pnpWorkbook.Workbook.Names["mgmt_cluster"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT DATASTORE-->',$pnpWorkbook.Workbook.Names["mgmt_vsan_datastore"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT NETWORK-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_pg"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY ROOT PASSWORD-->',$pnpWorkbook.Workbook.Names["cdp_root_password"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY NAME-->',$pnpWorkbook.Workbook.Names["vmc_cdp_hostname"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY IP ADDRESS-->',$pnpWorkbook.Workbook.Names["vmc_cdp_ip"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY NETMASK-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_mask"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY GATEWAY-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DOMAIN-->',$pnpWorkbook.Workbook.Names["vmc_cdp_qdn"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DNS SEARCH-->',$pnpWorkbook.Workbook.Names["child_dns_zone"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DNS SERVERS-->',($pnpWorkbook.Workbook.Names["region_dns1_ip"].Value + "," + $pnpWorkbook.Workbook.Names["region_dns2_ip"].Value) `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function deployCbaExtensibilityProxy {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH ESXI HOST-->',($pnpWorkbook.Workbook.Names["mgmt_az1_host1_hostname"].Value + "." + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH MANAGEMENT DATACENTER-->',$pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value `
                -replace '<!--REPLACE WITH CLOUD BASED AUTOMATION FOLDER-->',$pnpWorkbook.Workbook.Names["vmc_vm_folder"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT CLUSTER-->',$pnpWorkbook.Workbook.Names["mgmt_cluster"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT DATASTORE-->',$pnpWorkbook.Workbook.Names["mgmt_vsan_datastore"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT NETWORK-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_pg"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY HOSTNAME-->',($pnpWorkbook.Workbook.Names["vmc_cep_hostname"].Value + "." + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH CLOUD PROXY ROOT PASSWORD-->',$pnpWorkbook.Workbook.Names["cep_root_password"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY NAME-->',$pnpWorkbook.Workbook.Names["vmc_cep_hostname"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY IP ADDRESS-->',$pnpWorkbook.Workbook.Names["vmc_cep_ip"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY NETMASK-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_mask"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY GATEWAY-->',$pnpWorkbook.Workbook.Names["mgmt_az1_mgmt_gateway_ip"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DNS SERVERS-->',($pnpWorkbook.Workbook.Names["region_dns1_ip"].Value + "," + $pnpWorkbook.Workbook.Names["region_dns2_ip"].Value) `
                -replace '<!--REPLACE WITH CLOUD PROXY NTP SERVERS-->',$pnpWorkbook.Workbook.Names["region_ntp1_server"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DOMAIN-->',$pnpWorkbook.Workbook.Names["vmc_cep_fqdn"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY DNS SEARCH-->',$pnpWorkbook.Workbook.Names["child_dns_zone"].Value `
                -replace '<!--REPLACE WITH K8S CLUSTER CIDR-->',$pnpWorkbook.Workbook.Names["cep_k8s_internal_cidr"].Value `
                -replace '<!--REPLACE WITH K8S SERVICE CIDR-->',$pnpWorkbook.Workbook.Names["cep_k8s_service_cidr"].Value `
                -replace '<!--REPLACE WITH VRO INTEGRATION NAME-->',($pnpWorkbook.Workbook.Names["wld_sddc_domain"].Value + "-vro-Integration") `
                -replace '<!--REPLACE WITH VRO INTEGRATION TAG-->',$pnpWorkbook.Workbook.Names["vmc_vro_integration_tag"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function importCbaTrustedCertificate {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY HOSTNAME-->',($pnpWorkbook.Workbook.Names["vmc_cep_hostname"].Value + "." + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function importCbaWldVcenter {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY HOSTNAME-->',($pnpWorkbook.Workbook.Names["vmc_cep_hostname"].Value + "." + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH SDDC MANAGER FQDN-->',$pnpWorkbook.Workbook.Names["sddc_mgr_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH WORKLOAD DOMAIN NAME-->',$pnpWorkbook.Workbook.Names["wld_sddc_domain"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR SERVICE ACCOUNT-->',$pnpWorkbook.Workbook.Names["user_svc_vmc_vro_vsphere"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ORCHESTRATOR SERVICE PASSWORD-->',$pnpWorkbook.Workbook.Names["svc_vmc_vro_vsphere_password"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function createCbaAvailabilityZoneGroup {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH MANAGEMENT VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["mgmt_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH SSO USERNAME-->',$pnpWorkbook.Workbook.Names["sso_default_admin"].Value `
                -replace '<!--REPLACE WITH SSO PASSWORD-->',$pnpWorkbook.Workbook.Names["administrator_vsphere_local_password"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT DATACENTER-->',$pnpWorkbook.Workbook.Names["mgmt_datacenter"].Value `
                -replace '<!--REPLACE WITH MANAGEMENT CLUSTER-->',$pnpWorkbook.Workbook.Names["mgmt_cluster"].Value `
                -replace '<!--REPLACE WITH AZ1 HOST GROUP NAME-->',($pnpWorkbook.Workbook.Names["mgmt_sddc_domain"].Value + "-hostgroup-az1") `
                -replace '<!--REPLACE WITH CLOUD BASED AUTOMATION VM GROUP NAME-->',$pnpWorkbook.Workbook.Names["vmc_az_vm_group"].Value `
                -replace '<!--REPLACE WITH CLOUD PROXY NAME-->',$pnpWorkbook.Workbook.Names["vmc_cdp_hostname"].Value `
                -replace '<!--REPLACE WITH CLOUD EXTENSIBILITY PROXY NAME-->',$pnpWorkbook.Workbook.Names["vmc_cep_hostname"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function createCbaCloudAccounts {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH WORKLOAD VCENTER HOSTNAME-->',$pnpWorkbook.Workbook.Names["wld_vc_hostname"].Value `
                -replace '<!--REPLACE WITH WORKLOAD VCENTER FQDN-->',$pnpWorkbook.Workbook.Names["wld_vc_fqdn"].Value `
                -replace '<!--REPLACE WITH VSPHERE SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["user_svc_ca_vsphere"].Value + "@" + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH VSPHERE SERVICE ACCOUNT PASSWORD-->',$pnpWorkbook.Workbook.Names["svc_ca_vsphere_password"].Value `
                -replace '<!--REPLACE WITH VSPHERE DATACENTER MOREF-->',$pnpWorkbook.Workbook.Names["vmc_wld_datacenter_moref"].Value `
                -replace '<!--REPLACE WITH VSPHERE CLOUD ACCOUNT DESCRIPTION-->',("Workload Domain - " + $pnpWorkbook.Workbook.Names["wld_sddc_domain"].Value) `
                -replace '<!--REPLACE WITH CLOUD ACCOUNT VCENTER TAG-->',$pnpWorkbook.Workbook.Names["vmc_cloud_zone_tag"].Value `
                -replace '<!--REPLACE WITH WORKLOAD NSX MANAGER ASSOCIATION-->',$pnpWorkbook.Workbook.Names["wld_nsxt_hostname"].Value `
                -replace '<!--REPLACE WITH WORKLOAD NSX MANAGER HOSTNAME-->',$pnpWorkbook.Workbook.Names["wld_nsxt_hostname"].Value `
                -replace '<!--REPLACE WITH WORKLOAD NSX MANAGER FQDN-->',$pnpWorkbook.Workbook.Names["wld_nsxt_vip_fqdn"].Value `
                -replace '<!--REPLACE WITH NSX SERVICE ACCOUNT-->',($pnpWorkbook.Workbook.Names["user_svc_vmc_nsx"].Value + "@" + $pnpWorkbook.Workbook.Names["child_dns_zone"].Value) `
                -replace '<!--REPLACE WITH NSX SERVICE ACCOUNT PASSWORD-->',$pnpWorkbook.Workbook.Names["svc_vmc_nsx_password"].Value `
                -replace '<!--REPLACE WITH NSX CLOUD ACCOUNT DESCRIPTION-->',("Workload Domain - " + $pnpWorkbook.Workbook.Names["wld_nsxt_hostname"].Value) `
                -replace '<!--REPLACE WITH CLOUD ACCOUNT NSX TAG-->',("cloud:" + $pnpWorkbook.Workbook.Names["vmc_cloud_region_tag"].Value) `
                -replace '<!--REPLACE WITH CLOUD PROXY NAME-->',$pnpWorkbook.Workbook.Names["vmc_cdp_hostname"].Value `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath
        }
    }
}

Function configureCbaCloudZone {
    Param (
        [Parameter(Mandatory=$true)] [String]$planPath,
        [Parameter(Mandatory=$true)] [String]$Workbook
    )

    if (Test-Path -path $workbook) {
        if (Test-Path -path $planPath) {
            $pnpWorkbook = Open-ExcelPackage -Path $Workbook
            $templateFile = "$planPath\terraform.tfvars.template"
            $templateContents = Get-Content $templateFile   
            $templateContents | ForEach-Object { $_ `
                -replace '<!--REPLACE WITH CSP TOKEN-->',$pnpWorkbook.Workbook.Names["csp_api_token"].Value `
                -replace '<!--REPLACE WITH WORKLOAD VCENTER HOSTNAME-->',$pnpWorkbook.Workbook.Names["wld_vc_hostname"].Value `
                -replace '<!--REPLACE WITH WORKLOAD FOLDER-->',$pnpWorkbook.Workbook.Names["wld_vmc_vm_folder"].Value `
                -replace '<!--REPLACE WITH ARIA AUTOMATION ASSEMBLER FABRIC NAME-->',($pnpWorkbook.Workbook.Names["wld_cluster"].Value + " / " + $pnpWorkbook.Workbook.Names["wld_vmc_vm_rp"].Value) `
            } | Set-Content -Path "$planPath\terraform.tfvars"
            
            executeTerraformPlan -planDirectory $planPath -planOnly
            Request-CSPToken -apiToken $($pnpWorkbook.Workbook.Names["csp_api_token"].Value) -environment production | Out-Null
            $uri = "https://api.mgmt.cloud.vmware.com/iaas/api/zones"
            $cloudZoneId = ((Invoke-RestMethod -Method 'GET' -Uri $uri -Headers $cspHeader).content | Where-Object {$_.name -eq $($pnpWorkbook.Workbook.Names["wld_vc_hostname"].Value)}).id
            $terraformOutput = Invoke-Expression "terraform import vra_zone.cloud_zone_update $cloudZoneId"
            $uri = "https://api.mgmt.cloud.vmware.com/iaas/api/fabric-computes"
            $resourcePoolId = ((Invoke-RestMethod -Method 'GET' -Uri $uri -Headers $cspHeader).content | Where-Object {$_.name -eq $($pnpWorkbook.Workbook.Names["wld_cluster"].Value + " / " + $pnpWorkbook.Workbook.Names["wld_vmc_vm_rp"].Value)}).id
            $terraformOutput = Invoke-Expression "terraform import vra_fabric_compute.resource_pool $resourcePoolId"
            Close-ExcelPackage $pnpWorkbook -NoSave -ErrorAction SilentlyContinue
            executeTerraformPlan -planDirectory $planPath -skipCheck
        }
    }
}

#EndRegion  Solution Implementation

#Region     Menu

Function CBATerraformMenu { 
    Param (
        [Parameter(Mandatory=$true)] [String]$solutionName
    )

    $headingItem00 = "$solutionName for VMware Cloud Foundation - Implementation Tasks"
    $menuitem01 = "vCenter Server: Define Custom Roles in vSphere"
    $menuitem02 = "vCenter Server: Create a Virtual Machine and Template Folder for Cloud Proxy Appliances"
    $menuitem03 = "vCenter Server: Create Folders and a Resource Pool for Managed Workloads"
    $menuitem04 = "vCenter Server: Configure Service Account Permissions for vSphere Integration"
    $menuitem05 = "vCenter Server: Restrict Service Account Access to the Management Domain"
    $menuitem06 = "vCenter Server: Restrict Service Account Access to Virtual Machine and Datastore Folders in a VI Workload Domain"
    $menuitem07 = "NSX Manager: Configure Service Account Permissions for Automation Assembler Integration to NSX"
    $menuitem08 = "Automation Assembler: Deploy a Cloud Proxy Appliance for the Automation Assembler Service"
    $menuitem09 = "Automation Assembler: Deploy the Cloud Extensibility Proxy and Configure Integration"
    $menuitem10 = "Automation Assembler: Import the Trusted Certificates to Automation Orchestrator"
    #$menuitem11 = "Automation Assembler: Replace the Certificate of the Automation Orchestrator Instance"
    $menuitem12 = "Automation Assembler: Add the VI Workload Domain vCenter Server to Automation Orchestrator"
    $menuitem13 = "vCenter Server: Add the Cloud Proxy Appliances to the First Availability Zone VM Group"
    $menuitem14 = "Automation Assembler: Add Cloud Accounts for VI Workload Domains to Automation Assembler"
    $menuitem15 = "Automation Assembler: Configure the Cloud Zones in Automation Assembler"

    Do {
        Clear-Host
        Write-Host ""; Write-Ascii -InputObject $solutionName -ForegroundColor Cyan

        Write-Host -Object ""; Write-Host -Object " $headingItem00" -ForegroundColor Yellow; Write-Host ""
        Write-Host -Object " 01. $menuItem01" -ForegroundColor White
        Write-Host -Object " 02. $menuItem02" -ForegroundColor White
        Write-Host -Object " 03. $menuItem03" -ForegroundColor White
        Write-Host -Object " 04. $menuItem04" -ForegroundColor White
        Write-Host -Object " 05. $menuItem05" -ForegroundColor White
        Write-Host -Object " 06. $menuItem06" -ForegroundColor White
        Write-Host -Object " 07. $menuItem07" -ForegroundColor White
        Write-Host -Object " 08. $menuItem08" -ForegroundColor White
        Write-Host -Object " 09. $menuItem09" -ForegroundColor White
        Write-Host -Object " 10. $menuItem10" -ForegroundColor White
        #Write-Host -Object " 11. $menuItem11" -ForegroundColor White
        Write-Host -Object " 12. $menuItem12" -ForegroundColor White
        Write-Host -Object " 13. $menuItem13" -ForegroundColor White
        Write-Host -Object " 14. $menuItem14" -ForegroundColor White
        Write-Host -Object " 15. $menuItem15" -ForegroundColor White

        Write-Host -Object ""; Write-Host -Object " Navigation"-ForegroundColor Yellow; Write-Host ""
        Write-Host -Object " Q. Quit" -ForegroundColor White
        Write-Host -Object ''
        Write-Host -Object $errout
        $MenuInput = Read-Host -Prompt ' Select Number, Q'
        $MenuInput = $MenuInput -replace "`t|`n|`r",""
        if ($MenuInput -like "0*") {$MenuInput = ($MenuInput -split("0"),2)[1]}
        Switch ($MenuInput) 
        {
            1 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem01
                $StatusMsg = createCbaVsphereRoles -planPath ($parentPath + "\terraform-solution-implementation\01-vsphere-roles-automation-assembler") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            2 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem02
                $StatusMsg = createCbaApplianceFolder -planPath ($parentPath + "\terraform-solution-implementation\02-vsphere-folders-appliance-management") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            3 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem03
                $StatusMsg = createCbaWorkloadFolders -planPath ($parentPath + "\terraform-solution-implementation\03-vsphere-folders-managed-workloads") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            4 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem04
                $StatusMsg = applyCbaGlobalPermissions -planPath ($parentPath + "\terraform-solution-implementation\04-vsphere-permissions-apply-global") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            5 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem05
                $StatusMsg = applyCbaMgmtRestrictions -planPath ($parentPath + "\terraform-solution-implementation\05-vsphere-permissions-restrict-vcenters") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            6 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem06
                $StatusMsg = applyCbaWldRestrictions -planPath ($parentPath + "\terraform-solution-implementation\06-vsphere-permissions-restrict-folders") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            7 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem07
                $StatusMsg = applyCbaNsxPermissions -planPath ($parentPath + "\terraform-solution-implementation\07-nsx-permissions-apply-role") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            8 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem08
                $StatusMsg = deployCbaProxy -planPath ($parentPath + "\terraform-solution-implementation\08-assembler-deploy-cloud-proxy") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            9 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem09
                $StatusMsg = deployCbaExtensibilityProxy -planPath ($parentPath + "\terraform-solution-implementation\09-assembler-deploy-cloud-extensibility-proxy") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            10 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem10
                $StatusMsg = importCbaTrustedCertificate -planPath ($parentPath + "\terraform-solution-implementation\10-orchestrator-import-trusted-certificate") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            12 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem12
                $StatusMsg = importCbaWldVcenter -planPath ($parentPath + "\terraform-solution-implementation\12-orchestrator-add-vcenter-server") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            13 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem13
                $StatusMsg = createCbaAvailabilityZoneGroup -planPath ($parentPath + "\terraform-solution-implementation\13-vsphere-drs-az-vm-group") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            14 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem14
                $StatusMsg = createCbaCloudAccounts -planPath ($parentPath + "\terraform-solution-implementation\14-assembler-create-cloud-accounts") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            15 {
                Clear-Host
                Write-Host ""; Show-CbaMenuLogMessage -Type INFO -Message $menuitem15
                $StatusMsg = configureCbaCloudZone -planPath ($parentPath + "\terraform-solution-implementation\15-assembler-cloud-zone-config") -Workbook $workbook -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -WarningVariable WarnMsg -ErrorVariable ErrorMsg
                if ( $StatusMsg ) { Show-CbaMenuLogMessage -Type INFO -Message "$StatusMsg" } if ( $WarnMsg ) { Show-CbaMenuLogMessage -Type WARNING -Message $WarnMsg } if ( $ErrorMsg ) { Show-CbaMenuLogMessage -Type ERROR -Message $ErrorMsg }
                anyKey
            }
            Q {
                Break
            }
        }
    }
    Until ($MenuInput -eq 'q')
}

#EndRegion  Menu

#Region     Main Script

Try {
    $solutionName = "Cloud-Based Automation"
    Clear-Host; Write-Host ""

    Test-CbaMenuPrereq
    Start-SetupLogFile -Path $parentPath -ScriptName $MyInvocation.MyCommand.Name

    Show-CbaMenuLogMessage -Type INFO -Message "Starting the Process of Loading the Terraform Menu for Cloud-Based Automation for VMWare Cloud Foundation"
    Show-CbaMenuLogMessage -Type INFO -Message "Setting up the log file to path $parentPath"
    Show-CbaMenuLogMessage -Type INFO -Message "Checking Existance of Planning and Preparation Workbook: $workbook"
    if (!(Test-Path -Path $workbook )) {
        Show-CbaMenuLogMessage -Type ERROR -Message "Unable to Find Planning and Preparation Workbook: $workbook, check details and try again"
        Break
    }
    else {
        Show-CbaMenuLogMessage -Type INFO -Message "Found Planning and Preparation Workbook: $workbook"
    }
    CBATerraformMenu -solutionName $solutionName
}
Catch {
    Debug-CatchWriter -object $_
}

#EndRegion  Main Script
