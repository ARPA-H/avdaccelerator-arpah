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
    [string]$avdHostPoolPersona
)

$parameters = @{
    DeploymentStackName = $DeploymentStackName
    Location = $Location
    TemplateFile = $TemplateFile
    ParametersFile = $ParametersFile
    deploymentEnvironment = $deploymentEnvironment
    avdWorkloadSubsId = $avdWorkloadSubsId
    avdServicePrincipalObjectId = $avdServicePrincipalObjectId
    avdScurityPrincipalId = $avdScurityPrincipalId
    update_existing_stack = $update_existing_stack
    avdHostPoolType = $avdHostPoolType
    avdHostPoolPersona = $avdHostPoolPersona
}

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack @parameters
} else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack @parameters
}