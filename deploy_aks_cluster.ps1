
$ErrorActionPreference = "Stop"

function CreateAksAndKeyVault
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$subscriptionName, 

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,6)]
        [string]$environmentCode, 

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,10)]
        [string]$clusterPrefix,

        [Parameter(Mandatory=$true)]
        [ValidateLength(36,36)]
        [string]$DNSMADEEASY_API_KEY,

        [Parameter(Mandatory=$true)]
        [ValidateLength(36,36)]
        [string]$DNSMADEEASY_API_SECRET
    )

    $resourceGroupName = "$($environmentCode)-$($clusterPrefix)-rg"
    $clusterName = "$($environmentCode)-$($clusterPrefix)-aks"
    $keyvaultName = "$($environmentCode)-$($clusterPrefix)-kv"

    az login | Out-Null
    az account set --subscription $subscriptionName

    az group create --name $resourceGroupName --location eastus
    az aks create --resource-group $resourceGroupName --name $clusterName --node-count 1 --enable-addons monitoring `
    --generate-ssh-keys --kubernetes-version 1.11.8 --tags environmentCode=$environmentCode partnerCode=$partnerCode

    az aks install-cli
    az aks get-credentials --resource-group $resourceGroupName --name $clusterName

    az keyvault create --resource-group $resourceGroupName --name $keyvaultName --location eastus --sku standard
    az keyvault secret set --vault-name $keyvaultName --name 'DNSMADEEASY-API-KEY' --value $DNSMADEEASY_API_KEY
    az keyvault secret set --vault-name $keyvaultName --name 'DNSMADEEASY-API-SECRET' --value $DNSMADEEASY_API_SECRET

    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-role --namespace=kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    kubectl create clusterrolebinding kubernetes-dashboard --namespace=kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

    write-host "az aks get-credentials --resource-group $($resourceGroupName) --name $($clusterName)"
    write-host "az aks browse --resource-group $($resourceGroupName) --name $($clusterName)"
    }

CreateAksAndKeyVault -environmentCode "demo" -clusterPrefix "aksproxy" `
-subscriptionName "UniKey Dev - MSDN Dev and Test" `
-DNSMADEEASY_API_KEY "0fae3ae1-22c1-40a6-813b-d5a9510d5e7d" -DNSMADEEASY_API_SECRET "eca9715a-aa7a-4f35-a475-397e67e10314" `
-ErrorAction Stop

