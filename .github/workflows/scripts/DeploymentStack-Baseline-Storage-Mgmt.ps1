param (
    [string]$DeploymentStackName,
    [string]$Location,
    [string]$deploymentEnvironment,
    [string]$TemplateFile,
    [string]$ParametersFile,
    [string]$avdWorkloadSubsId,
    [string]$avdServicePrincipalObjectId,
    [string]$avdVmLocalUserName,
    [string]$avdVmLocalUserPassword,
    [string]$avdScurityPrincipalId,
    [string]$update_existing_stack
)

$securePassword = ConvertTo-SecureString $avdVmLocalUserPassword -AsPlainText -Force

$parameters = @{
    Name                                = $DeploymentStackName
    Location                            = $Location
    TemplateFile                        = $TemplateFile
    TemplateParameterFile               = $ParametersFile
    ActionOnUnmanage                    = "detachAll"
    DenySettingsMode                    = "none"
    deploymentEnvironment               = $deploymentEnvironment
    avdWorkloadSubsId                   = $avdWorkloadSubsId
    avdServicePrincipalObjectId         = $avdServicePrincipalObjectId
    avdVmLocalUserName                  = $avdVmLocalUserName
    avdVmLocalUserPassword              = $securePassword
    avdScurityPrincipalId               = $avdScurityPrincipalId
}

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack @parameters
} else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack @parameters
}