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
    [string]$vNetworkPrivateEndpointSubnetAddressPrefix
)

New-AzSubscriptionDeploymentStack -Name $DeploymentStackName -Location $Location -TemplateFile $TemplateFile -TemplateParameterFile $ParametersFile -P -ActionOnUnmanage "detachAll" -DenySettingsMode "none" `
    -deploymentEnvironment $deploymentEnvironment `
    -avdWorkloadSubsId $avdWorkloadSubsId -avdVnetworkAddressPrefixes $avdVnetworkAddressPrefixes `
    -existingHubVnetResourceId $existingHubVnetResourceId -vNetworkAvdSubnetAddressPrefix vNetworkAvdSubnetAddressPrefix `
    -vNetworkPrivateEndpointSubnetAddressPrefix $vNetworkPrivateEndpointSubnetAddressPrefix