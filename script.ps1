Connect-AzAccount -Identity
$aadApplication = New-AzureADApplication -DisplayName "ocda-app"
$appObjectId=$aadApplication.ObjectId
$appPassword = New-AzureADApplicationPasswordCredential -ObjectId $appObjectId -CustomKeyIdentifier "ClientSecret" -EndDate (Get-Date).AddYears(2)
$appId=$aadApplication.AppId
$servicePrincipal = New-AzureADServicePrincipal -AppId $appId -Tags @("WindowsAzureActiveDirectoryIntegratedApp")
$appObjectId=$aadApplication.ObjectId
$requiredResourcesAccess=(Get-AzureADApplication -ObjectId $appObjectId).RequiredResourceAccess
$appId=$aadApplication.AppId
$servicePrincipal = Get-AzureADServicePrincipal -All $true | Where-Object {$_.AppId -eq $appId}
$tenantId = (Get-AzureADTenantDetail).ObjectId
$tenantIdSecret = ConvertTo-SecureString -String $tenantId -AsPlainText -Force
$appClientId=$aadApplication.AppId
$AppIdSecret = ConvertTo-SecureString -String $appClientId -AsPlainText -Force
$clientSecret = $appPassword.Value
$clientSecretSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
New-AzKeyVault -Name "oca-key-vault" -ResourceGroupName "OCD-test" -Location "EastUS"
Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name client-secret -SecretValue $clientSecretSecret
Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name app-client-id -SecretValue $AppIdSecret
Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name tenant-id -SecretValue $tenantIdSecret
