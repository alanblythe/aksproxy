param(
[String]$path,
[String]$environmentCode
)

Write-Output 'found yaml files:'

Foreach ($file in Get-ChildItem -Path $path -Filter "$($environmentCode)*.yaml")
{
    Write-Host "Deploying file: $($file.Name)"
    kubectl -v=8 apply -f $file.FullName
}