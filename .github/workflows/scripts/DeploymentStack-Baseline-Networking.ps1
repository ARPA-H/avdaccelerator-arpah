param (
    [string]$DeploymentStackName,
    [string]$Location,
    [string]$deploymentEnvironment,
    [string]$TemplateFile,
    [string]$ParametersFile,
    [string]$avdWorkloadSubsId,
    [string]$existingHubVnetResourceId,
    [string]$avdVnetworkAddressPrefixes,
    [string]$vNetworkAvdSubnetAddressPrefix,
    [string]$vNetworkPrivateEndpointSubnetAddressPrefix,
    [string]$update_existing_stack
)

$parameters = @{
    Name                                = $DeploymentStackName
    Location                            = $Location
    TemplateFile                        = $TemplateFile
    TemplateParameterFile               = $ParametersFile
    ActionOnUnmanage                    = "detachAll"
    DenySettingsMode                    = "none"
    deploymentEnvironment               = $deploymentEnvironment
    avdWorkloadSubsId                   = $avdWorkloadSubsId
    avdVnetworkAddressPrefixes          = $avdVnetworkAddressPrefixes
    existingHubVnetResourceId           = $existingHubVnetResourceId
    vNetworkAvdSubnetAddressPrefix      = $vNetworkAvdSubnetAddressPrefix
    vNetworkPrivateEndpointSubnetAddressPrefix = $vNetworkPrivateEndpointSubnetAddressPrefix
}

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack @parameters
} else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack @parameters
}