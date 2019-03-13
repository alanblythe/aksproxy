# aksproxy

Thank you all for attending and the insightful questions. If you're interested in learning more let me know and we can schedule some time to talk.

This repo contains the scripts and details used for my talk on 3/12/2019 at Orlando Backend Developers

Script and File Notes

**presentation-resources.txt**   
for a links to various resources talked about in the presentation.

**1. deploy_aks_cluster.ps1**  
Run this script to create a new AKS cluster.

**2. deploy_voyager.ps1**  
Run this script to init Helm and install Voyager

**3. deploy_aksproxydemo.ps1**  
Run this script to deploy the k8s resources that setup a new ingress and external service

**4. aksproxy_addrewrites.yaml**  
Contains some example HaProxy rewrites

**5. /AksProxyDemo**  
An asp.net core simple API to demo rewrites with.

**6. AzureDevOpsBuildTasks.txt**  
Contains the Azure DevOps yaml for the release pipeline we're using


