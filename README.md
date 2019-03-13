# aksproxy

Thank you all for attending and the insightful questions. If you're interested in learning more let me know and we can schedule some time to talk.

This repo contains the scripts and details used for my talk on 3/12/2019 at Orlando Backend Developers

Script and File Notes

**presentation-resources.txt** 
for a links to various resources talked about in the presentation.

**deploy_aks_cluster.ps1**
1. Run this script to create a new AKS cluster.

**deploy_voyager.ps1**
2. Run this script to init Helm and install Voyager

**deploy_aksproxydemo.ps1**
3. Run this script to deploy the k8s resources that setup a new ingress and external service

**aksproxy_addrewrites.yaml**
4. Contains some example HaProxy rewrites

**/AksProxyDemo**
5. An asp.net core simple API to demo rewrites with.


