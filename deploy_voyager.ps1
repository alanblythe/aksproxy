function DeployVoyager
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$environmentCode, 

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$subscriptionName, 

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$clusterPrefix
    )

    $ErrorActionPreference = "Stop"

    $resourceGroupName = "$($environmentCode)-$($clusterPrefix)-rg"
    $clusterName = "$($environmentCode)-$($clusterPrefix)-aks"

    az login | Out-Null
    az account set --subscription $subscriptionName

    az aks get-credentials --resource-group $resourceGroupName --name $clusterName --overwrite-existing

    helm repo add appscode https://charts.appscode.com/stable/
    helm init --service-account tiller --upgrade --wait
    helm install --name voyager801 appscode/voyager --namespace "$($environmentCode)-voyager-proxy" --set cloudProvider=aks --set rbac.create=true

    kubectl patch deploy --namespace "$($environmentCode)-voyager-proxy" voyager-voyager801 --type json -p "$(Get-Content $PSScriptRoot/fix-voyager-healthprobe.yaml)"

    write-host "az aks get-credentials --resource-group $($resourceGroupName) --name $($clusterName)"
    write-host "az aks browse --resource-group $($resourceGroupName) --name $($clusterName)"
}

DeployVoyager -environmentCode "demo" -clusterPrefix "aksproxy" `
-subscriptionName "UniKey Dev - MSDN Dev and Test" `
-ErrorAction Stop

