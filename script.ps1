          				Install-Module AzureAD
					#Connect-AzureAD
					$aadApplication = New-AzureADApplication -DisplayName "ocda-app"

					# $currentUser = (Get-AzureADUser -ObjectId (Get-AzureADCurrentSessionInfo).Account.Id)
					# Add-AzureADApplicationOwner -ObjectId $aadApplication.ObjectId -RefObjectId $currentUser.ObjectId

					$appObjectId=$aadApplication.ObjectId
					$appPassword = New-AzureADApplicationPasswordCredential -ObjectId $appObjectId -CustomKeyIdentifier "ClientSecret" -EndDate (Get-Date).AddYears(2)

					#Provide Application (client) Id
					$appId=$aadApplication.AppId
					$servicePrincipal = New-AzureADServicePrincipal -AppId $appId -Tags @("WindowsAzureActiveDirectoryIntegratedApp")

					$appObjectId=$aadApplication.ObjectId
					$requiredResourcesAccess=(Get-AzureADApplication -ObjectId $appObjectId).RequiredResourceAccess

					#Provide Application (client) Id
					$appId=$aadApplication.AppId
					$servicePrincipal = Get-AzureADServicePrincipal -All $true | Where-Object {$_.AppId -eq $appId}



					#Get or provide your Office 365 Tenant Id or Tenant Domain Name
					$tenantId = (Get-AzureADTenantDetail).ObjectId
					$tenantIdSecret = ConvertTo-SecureString -String $tenantId -AsPlainText -Force
					
					#Provide Application (client) Id of your app
					$appClientId=$aadApplication.AppId
					$AppIdSecret = ConvertTo-SecureString -String $appClientId -AsPlainText -Force

					#Provide Application client secret key
					$clientSecret = $appPassword.Value
					$clientSecretSecret = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force

					New-AzKeyVault -Name "oca-key-vault" -ResourceGroupName "OCD-test" -Location "EastUS"
					Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name client-secret -SecretValue $clientSecretSecret
					Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name app-client-id -SecretValue $AppIdSecret
					Set-AzKeyVaultSecret -VaultName "oca-keyvault" -Name tenant-id -SecretValue $tenantIdSecret
