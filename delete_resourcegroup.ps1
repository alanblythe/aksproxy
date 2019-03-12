
$ErrorActionPreference = "Stop"

function DeleteResourceGroup
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateLength(2,30)]
        [string]$subscriptionName, 

        [Parameter(Mandatory=$true)]
        [ValidateLength(2,20)]
        [string]$resourceGroupName
    )

    az login | Out-Null
    az account set --subscription $subscriptionName

    az group delete --name $resourceGroupName
}

DeleteResourceGroup -resourceGroupName "demo-aksproxy-rg" `
-subscriptionName "UniKey Dev - MSDN Dev and Test" `
-ErrorAction Stop

