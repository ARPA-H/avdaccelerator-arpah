﻿param (
    [string]$DeploymentStackName,
    [string]$Location,
    [string]$TemplateFile,
    [string]$ParametersFile,
    [string]$deploymentEnvironment,
    [string]$avdWorkloadSubsId,
    [string]$avdDeploySessionHostsCount,
    [string]$avdSessionHostCustomNamePrefix,
    [string]$imageGallerySubscriptionId,
    [string]$hostPoolPersona,
    [string]$update_existing_stack,
    [int]$avdSessionHostCountIndex
)

$parameters = @{
    Name                           = $DeploymentStackName
    Location                       = $Location
    TemplateFile                   = $TemplateFile
    TemplateParameterFile          = $ParametersFile
    ActionOnUnmanage               = "detachAll"
    DenySettingsMode               = "none"
    deploymentEnvironment          = $deploymentEnvironment
    avdWorkloadSubsId              = $avdWorkloadSubsId
    avdDeploySessionHostsCount     = $avdDeploySessionHostsCount
    avdSessionHostCustomNamePrefix = $avdSessionHostCustomNamePrefix
    imageGallerySubscriptionId     = $imageGallerySubscriptionId
    hostPoolPersona                = $hostPoolPersona
    avdSessionHostCountIndex       = $avdSessionHostCountIndex
}

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack @parameters
}
else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack @parameters
}