param (
    [string]$environmentCode, 
    [string]$partnerCode, 
    [string]$subscriptionName, 
    [string]$clusterPrefix,
    [string]$DNSMADEEASY_API_KEY,
    [string]$DNSMADEEASY_API_SECRET
)

$ErrorActionPreference = "Stop"

$resourceGroupName = "$($partnerCode)-$($environmentCode)-$($clusterPrefix)-rg"
$clusterName = "$($partnerCode)-$($environmentCode)-$($clusterPrefix)-aks"
$keyvaultName = "$($partnerCode)-$($environmentCode)-$($clusterPrefix)-kv"

az login | Out-Null
az account set --subscription $subscriptionName

az group create --name $resourceGroupName --location eastus 
az aks create --resource-group $resourceGroupName --name $clusterName --node-count 1 --enable-addons monitoring `
--generate-ssh-keys --kubernetes-version 1.9.11 --tags environmentCode=$environmentCode partnerCode=$partnerCode

az aks install-cli
az aks get-credentials --resource-group $resourceGroupName --name $clusterName

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-role --namespace=kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl create clusterrolebinding kubernetes-dashboard --namespace=kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

helm repo add appscode https://charts.appscode.com/stable/
helm init --service-account tiller --upgrade --wait
helm install --name voyager801 appscode/voyager --namespace "$($environmentCode)-voyager-proxy" --set cloudProvider=aks --set rbac.create=true

kubectl patch deploy --namespace "$($environmentCode)-voyager-proxy" voyager-voyager801 --type json -p "$(Get-Content fix-voyager-healthprobe.yaml)"

az keyvault create --resource-group $resourceGroupName --name $keyvaultName --location eastus --sku standard
az keyvault secret set --vault-name $keyvaultName --name 'DNSMADEEASY-API-KEY' --value $DNSMADEEASY_API_KEY
az keyvault secret set --vault-name $keyvaultName --name 'DNSMADEEASY-API-SECRET' --value $DNSMADEEASY_API_SECRET

write-host "az aks get-credentials --resource-group $($resourceGroupName) --name $($clusterName)"
write-host "az aks browse --resource-group $($resourceGroupName) --name $($clusterName)"



