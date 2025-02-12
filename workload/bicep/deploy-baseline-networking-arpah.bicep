metadata name = 'AVD Accelerator - Baseline Deployment'
metadata description = 'AVD Accelerator - Deployment Baseline'
metadata owner = 'Azure/avdaccelerator'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@minLength(2)
@maxLength(4)
@sys.description('The name of the resource group to deploy. (Default: AVD1)')
param deploymentPrefix string = 'AVD1'

@allowed([
  'Dev' // Development
  'Test' // Test
  'Prod' // Production
])
@sys.description('The name of the resource group to deploy. (Default: Dev)')
param deploymentEnvironment string = 'Dev'

@sys.description('Required. Location where to deploy compute services.')
param avdSessionHostLocation string

@sys.description('Required. Location where to deploy AVD management plane.')
param avdManagementPlaneLocation string

@sys.description('AVD workload subscription ID, multiple subscriptions scenario. (Default: "")')
param avdWorkloadSubsId string = ''

@allowed([
  'ADDS' // Active Directory Domain Services
  'EntraDS' // Microsoft Entra Domain Services
  'EntraID' // Microsoft Entra ID Join
])
@sys.description('Required, The service providing domain services for Azure Virtual Desktop. (Default: ADDS)')
param avdIdentityServiceProvider string = 'ADDS'

@sys.description('FQDN of on-premises AD domain, used for FSLogix storage configuration and NTFS setup. (Default: "")')
param identityDomainName string = 'none'

@sys.description('Create new virtual network. (Default: true)')
param createAvdVnet bool = true

@sys.description('Existing virtual network subnet for AVD. (Default: "")')
param existingVnetAvdSubnetResourceId string = ''

@sys.description('Existing hub virtual network for perring. (Default: "")')
param existingHubVnetResourceId string = ''

@sys.description('AVD virtual network address prefixes. (Default: 10.10.0.0/16)')
param avdVnetworkAddressPrefixes string = '10.10.0.0/16'

@sys.description('AVD virtual network subnet address prefix. (Default: 10.10.1.0/24)')
param vNetworkAvdSubnetAddressPrefix string = '10.10.1.0/24'

@sys.description('private endpoints virtual network subnet address prefix. (Default: 10.10.2.0/27)')
param vNetworkPrivateEndpointSubnetAddressPrefix string = '10.10.2.0/27'

@sys.description('custom DNS servers IPs. (Default: "")')
param customDnsIps string = ''

@sys.description('Deploy DDoS Network Protection for virtual network. (Default: true)')
param deployDDoSNetworkProtection bool = false

@sys.description('Deploy private endpoints for key vault and storage. (Default: true)')
param deployPrivateEndpointKeyvaultStorage bool = true

@sys.description('Deploys the private link for AVD. Requires resource provider registration or re-registration. (Default: false)')
param deployAvdPrivateLinkService bool = false

@sys.description('Create new  Azure private DNS zones for private endpoints. (Default: true)')
param createPrivateDnsZones bool = true

@sys.description('Does the hub contains a virtual network gateway. (Default: false)')
param vNetworkGatewayOnHub bool = false

@sys.description('Deploy Fslogix setup. (Default: true)')
param createAvdFslogixDeployment bool = true

@sys.description('Deploy App Attach setup. (Default: false)')
param createAppAttachDeployment bool = false

@sys.description('Deploy new session hosts. (Default: true)')
param avdDeploySessionHosts bool = true

@sys.description('Deploy AVD monitoring resources and setings. (Default: false)')
param avdDeployMonitoring bool = false

@sys.description('Deploy AVD Azure log analytics workspace. (Default: true)')
param deployAlaWorkspace bool = true

@sys.description('Create and assign custom Azure Policy for diagnostic settings for the AVD Log Analytics workspace. (Default: false)')
param deployCustomPolicyMonitoring bool = false

@sys.description('AVD Azure log analytics workspace data retention. (Default: 90)')
param avdAlaWorkspaceDataRetention int = 90

@sys.description('Existing Azure log analytics workspace resource ID to connect to. (Default: "")')
param alaExistingWorkspaceResourceId string = ''

// Custom Naming
// Input must followe resource naming rules on https://docs.microsoft.com/azure/azure-resource-manager/management/resource-name-rules
@sys.description('AVD resources custom naming. (Default: false)')
param avdUseCustomNaming bool = true

@maxLength(90)
@sys.description('AVD service resources resource group custom name. (Default: rg-avd-arpah-dev-use2-service-objects)')
param avdServiceObjectsRgCustomName string = 'rg-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-service-objects'

@maxLength(90)
@sys.description('AVD network resources resource group custom name. (Default: rg-avd-arpah-dev-use2-network)')
param avdNetworkObjectsRgCustomName string = 'rg-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-network'

@maxLength(90)
@sys.description('AVD network resources resource group custom name. (Default: rg-avd-arpah-dev-use2-pool-compute)')
param avdComputeObjectsRgCustomName string = 'rg-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-pool-compute'

@maxLength(90)
@sys.description('AVD network resources resource group custom name. (Default: rg-avd-arpah-dev-use2-storage)')
param avdStorageObjectsRgCustomName string = 'rg-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-storage'

@maxLength(90)
@sys.description('AVD monitoring resource group custom name. (Default: rg-avd-dev-use2-monitoring)')
param avdMonitoringRgCustomName string = 'rg-avd-${toLower(deploymentEnvironment)}-${regionAcronym}-monitoring'

@maxLength(64)
@sys.description('AVD virtual network custom name. (Default: vnet-arpah-dev-use2-001)')
param avdVnetworkCustomName string = 'vnet-avd-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(64)
@sys.description('AVD Azure log analytics workspace custom name. (Default: log-avd-arpah-dev-use2)')
param avdAlaWorkspaceCustomName string = 'log-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}'

@maxLength(80)
@sys.description('AVD virtual network subnet custom name. (Default: snet-avd-arpah-dev-use2-001)')
param avdVnetworkSubnetCustomName string = 'snet-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('private endpoints virtual network subnet custom name. (Default: snet-pe-arpah-dev-use2-001)')
param privateEndpointVnetworkSubnetCustomName string = 'snet-pe-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('AVD network security group custom name. (Default: nsg-avd-arpah-dev-use2-001)')
param avdNetworksecurityGroupCustomName string = 'nsg-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('Private endpoint network security group custom name. (Default: nsg-pe-arpah-dev-use2-001)')
param privateEndpointNetworksecurityGroupCustomName string = 'nsg-pe-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('AVD route table custom name. (Default: route-avd-arpah-dev-use2-001)')
param avdRouteTableCustomName string = 'route-avd-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('Private endpoint route table custom name. (Default: route-avd-arpah-dev-use2-001)')
param privateEndpointRouteTableCustomName string = 'route-pe-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(80)
@sys.description('AVD application security custom name. (Default: asg-arpah-dev-use2-001)')
param avdApplicationSecurityGroupCustomName string = 'asg-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

@maxLength(64)
@sys.description('AVD host pool custom name. (Default: vdpool-arpah-dev-use2-001)')
param avdHostPoolCustomName string = 'vdpool-arpah-${toLower(deploymentEnvironment)}-${regionAcronym}-001'

//
// Resource tagging
//
@sys.description('Apply tags on resources and resource groups. (Default: false)')
param createResourceTags bool = false

@sys.description('The name of workload for tagging purposes. (Default: Contoso-Workload)')
param workloadNameTag string = 'Contoso-Workload'

@allowed([
  'Light'
  'Medium'
  'High'
  'Power'
])
@sys.description('Reference to the size of the VM for your workloads (Default: Light)')
param workloadTypeTag string = 'Light'

@allowed([
  'Non-business'
  'Public'
  'General'
  'Confidential'
  'Highly-confidential'
])
@sys.description('Sensitivity of data hosted (Default: Non-business)')
param dataClassificationTag string = 'Non-business'

@sys.description('Department that owns the deployment, (Dafult: Contoso-AVD)')
param departmentTag string = 'Contoso-AVD'

@allowed([
  'Low'
  'Medium'
  'High'
  'Mission-critical'
  'Custom'
])
@sys.description('Criticality of the workload. (Default: Low)')
param workloadCriticalityTag string = 'Low'

@sys.description('Tag value for custom criticality value. (Default: Contoso-Critical)')
param workloadCriticalityCustomValueTag string = 'ARPA-H-Critical'

@sys.description('Details about the application.')
param applicationNameTag string = 'ARPA-H-AVD'

@sys.description('Service level agreement level of the worload. (Contoso-SLA)')
param workloadSlaTag string = 'ARPA-H-SLA'

@sys.description('Team accountable for day-to-day operations. (workload-admins@Contoso.com)')
param opsTeamTag string = 'workload-admins@arpa-h.gov'

@sys.description('Organizational owner of the AVD deployment. (Default: workload-owner@Contoso.com)')
param ownerTag string = 'workload-owner@arpa-h.gov'

@sys.description('Cost center of owner team. (Default: Contoso-CC)')
param costCenterTag string = 'ARPA-H-CC'

@sys.description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()

@sys.description('Enable usage and telemetry feedback to Microsoft.')
param enableTelemetry bool = true

@sys.description('Additional customer-provided static routes to be added to the route tables.')
param customStaticRoutes array = []

@sys.description('Enable Microsoft Defender for Azure Kubernetes Service. (Default: true)') 
param regionAcronym string = 'usc'

// =========== //
// Variable declaration //
// =========== //
// Resource naming
var varDeploymentPrefixLowercase = toLower(deploymentPrefix)
var varAzureCloudName = environment().name
var varDeploymentEnvironmentLowercase = toLower(deploymentEnvironment)
var varSessionHostLocationAcronym = varLocations[varSessionHostLocationLowercase].acronym
var varManagementPlaneLocationAcronym = varLocations[varManagementPlaneLocationLowercase].acronym
var varLocations = loadJsonContent('../variables/locations.json')
var varManagementPlaneNamingStandard = '${varDeploymentPrefixLowercase}-${varDeploymentEnvironmentLowercase}-${varManagementPlaneLocationAcronym}'
var varComputeStorageResourcesNamingStandard = '${varDeploymentPrefixLowercase}-${varDeploymentEnvironmentLowercase}-${varSessionHostLocationAcronym}'
var varSessionHostLocationLowercase = toLower(replace(avdSessionHostLocation, ' ', ''))
var varManagementPlaneLocationLowercase = toLower(replace(avdManagementPlaneLocation, ' ', ''))
var varServiceObjectsRgName = avdUseCustomNaming ? avdServiceObjectsRgCustomName : 'rg-avd-${varManagementPlaneNamingStandard}-service-objects' // max length limit 90 characters
var varNetworkObjectsRgName = avdUseCustomNaming ? avdNetworkObjectsRgCustomName : 'rg-avd-${varComputeStorageResourcesNamingStandard}-network' // max length limit 90 characters
var varComputeObjectsRgName = avdUseCustomNaming ? avdComputeObjectsRgCustomName : 'rg-avd-${varComputeStorageResourcesNamingStandard}-pool-compute' // max length limit 90 characters
var varStorageObjectsRgName = avdUseCustomNaming ? avdStorageObjectsRgCustomName : 'rg-avd-${varComputeStorageResourcesNamingStandard}-storage' // max length limit 90 characters
var varMonitoringRgName = avdUseCustomNaming ? avdMonitoringRgCustomName : 'rg-avd-${varDeploymentEnvironmentLowercase}-${varManagementPlaneLocationAcronym}-monitoring' // max length limit 90 characters
var varVnetName = avdUseCustomNaming ? avdVnetworkCustomName : 'vnet-${varComputeStorageResourcesNamingStandard}-001'
var varHubVnetName = (createAvdVnet && !empty(existingHubVnetResourceId)) ? split(existingHubVnetResourceId, '/')[8] : ''
var varVnetPeeringName = 'peer-${varHubVnetName}'
var varRemoteVnetPeeringName = 'peer-${varVnetName}'
var varVnetAvdSubnetName = avdUseCustomNaming ? avdVnetworkSubnetCustomName : 'snet-avd-${varComputeStorageResourcesNamingStandard}-001'
var varVnetPrivateEndpointSubnetName = avdUseCustomNaming ? privateEndpointVnetworkSubnetCustomName : 'snet-pe-${varComputeStorageResourcesNamingStandard}-001'
var varAvdNetworksecurityGroupName = avdUseCustomNaming ? avdNetworksecurityGroupCustomName : 'nsg-avd-${varComputeStorageResourcesNamingStandard}-001'
var varPrivateEndpointNetworksecurityGroupName = avdUseCustomNaming ? privateEndpointNetworksecurityGroupCustomName : 'nsg-pe-${varComputeStorageResourcesNamingStandard}-001'
var varAvdRouteTableName = avdUseCustomNaming ? avdRouteTableCustomName : 'route-avd-${varComputeStorageResourcesNamingStandard}-001'
var varPrivateEndpointRouteTableName = avdUseCustomNaming ? privateEndpointRouteTableCustomName : 'route-pe-${varComputeStorageResourcesNamingStandard}-001'
var varApplicationSecurityGroupName = avdUseCustomNaming ? avdApplicationSecurityGroupCustomName : 'asg-${varComputeStorageResourcesNamingStandard}-001'
var varDDosProtectionPlanName = 'ddos-${varVnetName}'
var varHostPoolName = avdUseCustomNaming ? avdHostPoolCustomName : 'vdpool-${varManagementPlaneNamingStandard}-001'
var varCreateAppAttachDeployment = (varAzureCloudName == 'AzureChinaCloud') ? false : createAppAttachDeployment
var varAlaWorkspaceName = avdUseCustomNaming ? avdAlaWorkspaceCustomName : 'log-avd-${varDeploymentEnvironmentLowercase}-${varManagementPlaneLocationAcronym}'
var varDataCollectionRulesName = 'microsoft-avdi-${varSessionHostLocationLowercase}' // 'dcr-avd-${varDeploymentEnvironmentLowercase}-${varManagementPlaneLocationAcronym}'
var varCreateStorageDeployment = (createAvdFslogixDeployment || varCreateAppAttachDeployment == true) ? true : false
var varAllDnsServers = '${customDnsIps},168.63.129.16'
var varDnsServers = empty(customDnsIps) ? [] : (split(varAllDnsServers, ','))
var varCreateVnetPeering = !empty(existingHubVnetResourceId) ? true : false
// Resource tagging
// Tag Exclude-${varAvdScalingPlanName} is used by scaling plans to exclude session hosts from scaling. Exmaple: Exclude-vdscal-eus2-arpah-dev-001
var varCustomResourceTags = createResourceTags
  ? {
      WorkloadName: workloadNameTag
      WorkloadType: workloadTypeTag
      DataClassification: dataClassificationTag
      Department: departmentTag
      Criticality: (workloadCriticalityTag == 'Custom') ? workloadCriticalityCustomValueTag : workloadCriticalityTag
      ApplicationName: applicationNameTag
      ServiceClass: workloadSlaTag
      OpsTeam: opsTeamTag
      Owner: ownerTag
      CostCenter: costCenterTag
    }
  : {}
var varAllComputeStorageTags = {
  DomainName: identityDomainName
  IdentityServiceProvider: avdIdentityServiceProvider
}
var varAvdDefaultTags = {
  'cm-resource-parent': '/subscriptions/${avdWorkloadSubsId}/resourceGroups/${varServiceObjectsRgName}/providers/Microsoft.DesktopVirtualization/hostpools/${varHostPoolName}'
  Environment: deploymentEnvironment
  ServiceWorkload: 'AVD'
  CreationTimeUTC: time
}

var varTelemetryId = 'pid-2ce4228c-d72c-43fb-bb5b-cd8f3ba2138e-${avdManagementPlaneLocation}'
var varResourceGroups = [
  // {
  //   purpose: 'Service-Objects'
  //   name: varServiceObjectsRgName
  //   location: avdManagementPlaneLocation
  //   enableDefaultTelemetry: false
  //   tags: createResourceTags
  //     ? union(varCustomResourceTags, varAvdDefaultTags)
  //     : union(varAvdDefaultTags, varAllComputeStorageTags)
  // }
  {
    purpose: 'Pool-Compute'
    name: varComputeObjectsRgName
    location: avdSessionHostLocation
    enableDefaultTelemetry: false
    tags: createResourceTags
      ? union(varAllComputeStorageTags, varAvdDefaultTags)
      : union(varAvdDefaultTags, varAllComputeStorageTags)
  }
]

// =========== //
// Deployments //
// =========== //

//  Telemetry Deployment
resource telemetrydeployment 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: varTelemetryId
  location: avdManagementPlaneLocation
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

// Resource groups.
// Compute, service objects, network
// Network
module baselineNetworkResourceGroup '../../avm/1.0.0/res/resources/resource-group/main.bicep' = if (createAvdVnet || createPrivateDnsZones) {
  scope: subscription(avdWorkloadSubsId)
  name: 'Deploy-Network-RG-${time}'
  params: {
    name: varNetworkObjectsRgName
    location: avdSessionHostLocation
    enableTelemetry: false
    tags: createResourceTags ? union(varCustomResourceTags, varAvdDefaultTags) : varAvdDefaultTags
  }
}

// Compute, service objects
module baselineResourceGroups '../../avm/1.0.0/res/resources/resource-group/main.bicep' = [
  for resourceGroup in varResourceGroups: {
    scope: subscription(avdWorkloadSubsId)
    name: '${resourceGroup.purpose}-${time}'
    params: {
      name: resourceGroup.name
      location: resourceGroup.location
      enableTelemetry: resourceGroup.enableDefaultTelemetry
      tags: resourceGroup.tags
    }
  }
]

// Storage
module baselineStorageResourceGroup '../../avm/1.0.0/res/resources/resource-group/main.bicep' = if (varCreateStorageDeployment) {
  scope: subscription(avdWorkloadSubsId)
  name: 'Storage-RG-${time}'
  params: {
    name: varStorageObjectsRgName
    location: avdSessionHostLocation
    enableTelemetry: false
    tags: createResourceTags
      ? union(varAllComputeStorageTags, varAvdDefaultTags)
      : union(varAvdDefaultTags, varAllComputeStorageTags)
  }
}

// Azure Policies for monitoring Diagnostic settings. Performance couunters on new or existing Log Analytics workspace. New workspace if needed.
module monitoringDiagnosticSettings './modules/avdInsightsMonitoring/deploy.bicep' = if (avdDeployMonitoring) {
  name: 'Monitoring-${time}'
  params: {
    location: avdManagementPlaneLocation
    deployAlaWorkspace: deployAlaWorkspace
    computeObjectsRgName: varComputeObjectsRgName
    serviceObjectsRgName: varServiceObjectsRgName
    dataCollectionRulesName: varDataCollectionRulesName
    storageObjectsRgName: (createAvdFslogixDeployment || createAppAttachDeployment) ? varStorageObjectsRgName : ''
    networkObjectsRgName: (createAvdVnet) ? varNetworkObjectsRgName : ''
    monitoringRgName: varMonitoringRgName
    deployCustomPolicyMonitoring: deployCustomPolicyMonitoring
    alaWorkspaceId: deployAlaWorkspace ? '' : alaExistingWorkspaceResourceId
    alaWorkspaceName: deployAlaWorkspace ? varAlaWorkspaceName : ''
    alaWorkspaceDataRetention: avdAlaWorkspaceDataRetention
    subscriptionId: avdWorkloadSubsId
    tags: createResourceTags ? union(varCustomResourceTags, varAvdDefaultTags) : varAvdDefaultTags
  }
  dependsOn: [
    baselineNetworkResourceGroup
    baselineResourceGroups
    baselineStorageResourceGroup
  ]
}

// Networking
module networking './modules/networking/deploy.bicep' = if (createAvdVnet || createPrivateDnsZones || avdDeploySessionHosts || createAvdFslogixDeployment || varCreateAppAttachDeployment) {
  name: 'Networking-${time}'
  params: {
    createVnet: createAvdVnet
    deployAsg: (avdDeploySessionHosts || createAvdFslogixDeployment || varCreateAppAttachDeployment) ? true : false
    existingAvdSubnetResourceId: existingVnetAvdSubnetResourceId
    createPrivateDnsZones: (deployPrivateEndpointKeyvaultStorage || deployAvdPrivateLinkService)
      ? createPrivateDnsZones
      : false
    applicationSecurityGroupName: varApplicationSecurityGroupName
    computeObjectsRgName: varComputeObjectsRgName
    networkObjectsRgName: varNetworkObjectsRgName
    avdNetworksecurityGroupName: varAvdNetworksecurityGroupName
    privateEndpointNetworksecurityGroupName: varPrivateEndpointNetworksecurityGroupName
    avdRouteTableName: varAvdRouteTableName
    privateEndpointRouteTableName: varPrivateEndpointRouteTableName
    vnetAddressPrefixes: avdVnetworkAddressPrefixes
    vnetName: varVnetName
    vnetPeeringName: varVnetPeeringName
    remoteVnetPeeringName: varRemoteVnetPeeringName
    vnetAvdSubnetName: varVnetAvdSubnetName
    vnetPrivateEndpointSubnetName: varVnetPrivateEndpointSubnetName
    createVnetPeering: varCreateVnetPeering
    deployDDoSNetworkProtection: deployDDoSNetworkProtection
    ddosProtectionPlanName: varDDosProtectionPlanName
    deployPrivateEndpointSubnet: (deployPrivateEndpointKeyvaultStorage || deployAvdPrivateLinkService) ? true : false //adding logic that will be used when also including AVD control plane PEs
    deployAvdPrivateLinkService: deployAvdPrivateLinkService
    vNetworkGatewayOnHub: vNetworkGatewayOnHub
    existingHubVnetResourceId: existingHubVnetResourceId
    location: avdDeploySessionHosts ? avdSessionHostLocation : avdManagementPlaneLocation
    vnetAvdSubnetAddressPrefix: vNetworkAvdSubnetAddressPrefix
    vnetPrivateEndpointSubnetAddressPrefix: vNetworkPrivateEndpointSubnetAddressPrefix
    workloadSubsId: avdWorkloadSubsId
    dnsServers: varDnsServers
    tags: createResourceTags ? union(varCustomResourceTags, varAvdDefaultTags) : varAvdDefaultTags
    alaWorkspaceResourceId: avdDeployMonitoring
      ? (deployAlaWorkspace
          ? monitoringDiagnosticSettings.outputs.avdAlaWorkspaceResourceId
          : alaExistingWorkspaceResourceId)
      : ''
    customStaticRoutes: customStaticRoutes
  }
  dependsOn: [
    baselineNetworkResourceGroup
    baselineResourceGroups
  ]
}
