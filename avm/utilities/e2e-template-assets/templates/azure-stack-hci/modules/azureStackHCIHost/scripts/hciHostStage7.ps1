param(
  [Parameter()]
  [String]
  $resourceGroupName,

  [Parameter()]
  [String]
  $subscriptionId,

  [Parameter()]
  [int]
  $hciNodeCount

)
Function log {
  Param (
    [string]$message,
    [string]$logPath = 'C:\temp\hciHostDeploy.log'
  )

  If (!(Test-Path -Path C:\temp)) {
    New-Item -Path C:\temp -ItemType Directory
  }

  Write-Host $message
  Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message"
}

$ErrorActionPreference = 'Stop'

$hciNodeNames = @()
for ($i = 1; $i -le $hciNodeCount; $i++) {
  $hciNodeNames += "hcinode$i"
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.ConnectedMachine -Force -AllowClobber -Scope CurrentUser -Repository PSGallery -ErrorAction SilentlyContinue
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

Login-AzAccount -Identity -Subscription $subscriptionId

log "Waiting for HCI Arc Machines to exist in the resource group '$($resourceGroupName)'..."

While (($arcMachines = Get-AzConnectedMachine -ResourceGroupName $resourceGroupName | Where-Object { $_.name -in ($hciNodeNames) }).Count -lt $hciNodeNames.Count) {
  log "Found '$($arcMachines.Count)' HCI Arc Machines, waiting for '$($hciNodeNames.Count)'..."
  Start-Sleep -Seconds 30
}

log 'Waiting up to two hours for HCI Arc Machine extensions to be installed...'
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$allExtensionsReady = $false
while (!$allExtensionsReady -and $timer.Elapsed.TotalMinutes -lt 120) {
  $allExtensionsReadyCheck = $true
  foreach ($arcMachine in $arcMachines) {
    $extensions = Get-AzConnectedMachineExtension -ResourceGroupName $resourceGroupName -MachineName $arcMachine.Name
    if ($extensions.MachineExtensionType -notcontains 'TelemetryAndDiagnostics' -or $extensions.MachineExtensionType -notcontains 'DeviceManagementExtension' -or $extensions.MachineExtensionType -notcontains 'LcmController' -or $extensions.MachineExtensionType -notcontains 'EdgeRemoteSupport') {
      log "Waiting for extensions to be installed on HCI Arc Machine '$($arcMachine.Name)'..."
      $allExtensionsReadyCheck = $false
      continue
    } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'TelemetryAndDiagnostics').ProvisioningState -ne 'Succeeded') {
      log "Waiting for TelemetryAndDiagnostics extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
      $allExtensionsReadyCheck = $false
    } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'DeviceManagementExtension').ProvisioningState -ne 'Succeeded') {
      log "Waiting for DeviceManagementExtension extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
      $allExtensionsReadyCheck = $false
    } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'LcmController').ProvisioningState -ne 'Succeeded') {
      log "Waiting for LcmController extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
      $allExtensionsReadyCheck = $false
    } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'EdgeRemoteSupport').ProvisioningState -ne 'Succeeded') {
      log "Waiting for EdgeRemoteSupport extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
      $allExtensionsReadyCheck = $false
    } else {
      log "All extensions are installed and ready on HCI Arc Machine '$($arcMachine.Name)'"
    }
  }
  $allExtensionsReady = $allExtensionsReadyCheck
  If (!$allExtensionsReady) {
    log 'waiting 30 seconds to check extensions again...'
    Start-Sleep -Seconds 30
  }
}

If (!$allExtensionsReady) {
  log 'Extensions did not install within the two hour timeout period'
  Exit 1
} Else {
  log 'All extensions are installed and ready on all HCI Arc Machines'
}

# import local administrator credential (exported in stage 6)
log "Re-importing local '$($adminUsername)' credential..."
$adminCred = Import-Clixml -Path 'C:\temp\hciHostDeployAdminCred.xml'

# name net adapters - seems to be required on 2405
log 'Renaming network adapters on HCI nodes...'
$vmNicLocalNamingOut = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
  $ErrorActionPreference = 'Stop'

  Get-NetAdapter | ForEach-Object {
    $adapter = $_

    try {
      Write-Output "Getting Hyper-V network adapter name for '$($adapter.Name)' on VM '$($env:COMPUTERNAME)'..."
      $newAdapterName = Get-NetAdapterAdvancedProperty -RegistryKeyword HyperVNetworkAdapterName -Name $adapter.Name | Select-Object -ExpandProperty DisplayValue
    } catch {
      Write-Output "Failed to get Hyper-V network adapter name for '$($adapter.Name)' on VM '$($env:COMPUTERNAME)'. Ensure DeviceNaming is turned on for the VM Network Adapter! $_ Exiting..."
      Write-Error "Failed to get Hyper-V network adapter name for '$($adapter.Name)'  on VM '$($env:COMPUTERNAME)'. Ensure DeviceNaming is turned on for the VM Network Adapter! $_ Exiting..." -ErrorAction Stop
      Exit 1
    }

    If ($adapter.InterfaceAlias -ne $newAdapterName) {
      Write-Output "Renaming network adapter '$($adapter.InterfaceAlias)' to '$newAdapterName'  on VM '$($env:COMPUTERNAME)'..."
      Rename-NetAdapter -Name $adapter.Name -NewName $newAdapterName
    } Else {
      Write-Output "Network adapter '$($adapter.InterfaceAlias)' is already named correctly on VM '$($env:COMPUTERNAME)'..."
    }
  }
}

log "VM NIC local naming output: $vmNicLocalNamingOut"
