# AzNamingTool-TF

This repo can help you quickly deploy the Azure Naming Tool on an Azure Web App running on a linux Docker container.

## Instructions

Install Terraform on your machine
CD to the directory where you saved the terraform tool

Download/clone this repository to your machine and cd to the root folder

Run the following commands
```
terraform init
terraform plan
terraform apply
```

Type `yes`

[Install docker](https://docs.docker.com/engine/install/) on your machine if it is not already installed.
Download/clone the [CloudAdoptionFramework](https://github.com/microsoft/CloudAdoptionFramework) repo on your machine.
CD to the following path under the repo folder

`.\CloudAdoptionFramework-master\CloudAdoptionFramework-master\ready\AzNamingTool`

Run the following command to build the docker image

`docker build -t azurenamingtool .`

Login to the Azure Container Registry

`az acr login -n <the_name_of_your_acr>`

Publish the docker image to the Azure Container Registry that was created by Terraform using the following command
```
docker tag azurenamingtool:latest <the_name_of_your_acr>.azurecr.io/tools/azurenamingtool
docker push <the_name_of_your_acr>.azurecr.io/tools/azurenamingtool
```
