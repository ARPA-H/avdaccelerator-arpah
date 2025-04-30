param (
    [string]$DeploymentStackName,
    [string]$Location,
    [string]$TemplateFile,
    [string]$ParametersFile,
    [string]$deploymentEnvironment,
    [string]$avdWorkloadSubsId,
    [string]$avdServicePrincipalObjectId,
    [string]$avdScurityPrincipalId,
    [string]$update_existing_stack,
    [string]$avdHostPoolType,
    [string]$hostPoolPersona
)

# $parameters = @{
#     Name                                = $DeploymentStackName
#     Location                            = $Location
#     TemplateFile                        = $TemplateFile
#     TemplateParameterFile               = $ParametersFile
#     ActionOnUnmanage                    = "detachAll"
#     DenySettingsMode                    = "none"
#     deploymentEnvironment               = $deploymentEnvironment
#     avdWorkloadSubsId                   = $avdWorkloadSubsId
#     avdServicePrincipalObjectId         = $avdServicePrincipalObjectId
#     avdVmLocalUserName                  = $avdVmLocalUserName
#     avdScurityPrincipalId               = $avdScurityPrincipalId
# }

$parameters = @{
    Name = $DeploymentStackName
    Location = $Location
    TemplateFile = $TemplateFile
    TemplateParameterFile = $ParametersFile
    ActionOnUnmanage = "detachAll"
    DenySettingsMode = "none"
    deploymentEnvironment = $deploymentEnvironment
    avdWorkloadSubsId = $avdWorkloadSubsId
    avdServicePrincipalObjectId = $avdServicePrincipalObjectId
    avdScurityPrincipalId = $avdScurityPrincipalId
    avdHostPoolType = $avdHostPoolType
    hostPoolPersona = $hostPoolPersona
}

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack @parameters
} else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack @parameters
}