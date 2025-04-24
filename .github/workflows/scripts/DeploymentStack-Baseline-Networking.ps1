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

if ($update_existing_stack -eq 'true') {
    Write-Host "Updating existing stack"
    Set-AzSubscriptionDeploymentStack -Name $DeploymentStackName -Location $Location -TemplateFile $TemplateFile -TemplateParameterFile $ParametersFile -P -ActionOnUnmanage "detachAll" -DenySettingsMode "none" `
        -deploymentEnvironment $deploymentEnvironment `
        -avdWorkloadSubsId $avdWorkloadSubsId -avdVnetworkAddressPrefixes $avdVnetworkAddressPrefixes `
        -existingHubVnetResourceId $existingHubVnetResourceId -vNetworkAvdSubnetAddressPrefix vNetworkAvdSubnetAddressPrefix `
        -vNetworkPrivateEndpointSubnetAddressPrefix $vNetworkPrivateEndpointSubnetAddressPrefix
    return
} else {
    Write-Host "Creating new stack"
    New-AzSubscriptionDeploymentStack -Name $DeploymentStackName -Location $Location -TemplateFile $TemplateFile -TemplateParameterFile $ParametersFile -P -ActionOnUnmanage "detachAll" -DenySettingsMode "none" `
    -deploymentEnvironment $deploymentEnvironment `
    -avdWorkloadSubsId $avdWorkloadSubsId -avdVnetworkAddressPrefixes $avdVnetworkAddressPrefixes `
    -existingHubVnetResourceId $existingHubVnetResourceId -vNetworkAvdSubnetAddressPrefix vNetworkAvdSubnetAddressPrefix `
    -vNetworkPrivateEndpointSubnetAddressPrefix $vNetworkPrivateEndpointSubnetAddressPrefix
    return
}