
function DeployAksProxyDemo
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$subscriptionName,

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$clusterName,

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$resourceGroupName
    )
    
    az login | Out-Null
    az account set --subscription $subscriptionName

    $file = Get-Item -Path "$($PSScriptRoot)\aksproxy.yaml"

    az aks get-credentials --resource-group $resourceGroupName --name $clusterName
    kubectl -v=8 apply -f $file.FullName
}

DeployAksProxyDemo -subscriptionName "UniKey Dev - MSDN Dev and Test" -clusterName "demo-aksproxy-aks" `
-resourceGroupName "demo-aksproxy-rg" `
-ErrorAction Stop


