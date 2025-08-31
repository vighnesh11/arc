# Add the service principal application ID and secret here
ServicePrincipalId="1c1f52eb-af29-4fff-a3f0-8259f0d347d4";
ServicePrincipalClientSecret="QeY8Q~juqsf1EUysNCupQo9IsPrI.qicFQaM4cDQ";


export subscriptionId="8b0fbf42-b133-4d15-a317-1c7456bfd750";
export resourceGroup="my-rg-01";
export tenantId="11b76eef-195d-4fda-8672-8688d247437d";
export location="southeastasia";
export authType="principal";
export correlationId="aaeead3b-be7d-4b6b-ae6c-b11f903d7227";
export cloud="AzureCloud";
LINUX_INSTALL_SCRIPT="/tmp/install_linux_azcmagent.sh"
if [ -f "$LINUX_INSTALL_SCRIPT" ]; then rm -f "$LINUX_INSTALL_SCRIPT"; fi;
output=$(wget https://gbl.his.arc.azure.com/azcmagent-linux -O "$LINUX_INSTALL_SCRIPT" 2>&1);
if [ $? != 0 ]; then wget -qO- --method=PUT --body-data="{\"subscriptionId\":\"$subscriptionId\",\"resourceGroup\":\"$resourceGroup\",\"tenantId\":\"$tenantId\",\"location\":\"$location\",\"correlationId\":\"$correlationId\",\"authType\":\"$authType\",\"operation\":\"onboarding\",\"messageType\":\"DownloadScriptFailed\",\"message\":\"$output\"}" "https://gbl.his.arc.azure.com/log" &> /dev/null || true; fi;
echo "$output";
bash "$LINUX_INSTALL_SCRIPT";
sleep 5;
sudo azcmagent connect --service-principal-id "$ServicePrincipalId" --service-principal-secret "$ServicePrincipalClientSecret" --resource-group "$resourceGroup" --tenant-id "$tenantId" --location "$location" --subscription-id "$subscriptionId" --cloud "$cloud" --tags 'ArcSQLServerExtensionDeployment=Disabled' --correlation-id "$correlationId";
