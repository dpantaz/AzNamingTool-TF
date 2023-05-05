# AzNamingTool-TF

This repo can help you quickly deploy the Azure Naming Tool on an Azure Web App running on a linux Docker container using Terraform.

## Instructions

Download the repo files, create a new `terraform.tfvars` file under the root directory of the repo and paste the following lines

```text
app_service_name      = ""
app_service_plan_name = ""
location              = ""
resource_group_name   = ""
storage_account_name  = ""
acr_name              = ""
managed_identity_name = ""
```

The above variables are used for the dpeloyment of the Azure resources that will host the Azure Naming tool web application. Make sure that you provide your own values to these variables.

Deploy the Azure infrastructure using the typical Terraform flow `init/plan/apply`.

Download/clone the [CloudAdoptionFramework](https://github.com/microsoft/CloudAdoptionFramework) repo on your machine.

CD to the following path under the repo folder:

`.\CloudAdoptionFramework-master\CloudAdoptionFramework-master\ready\AzNamingTool`

Run the following command to build the docker image:

`docker build -t azurenamingtool .`

Login to the Azure Container Registry (provide the name of the Azure Container Registry as specified in the terraform.tfvars file):

`az acr login -n <the_name_of_your_acr>`

Publish the docker image to the Azure Container Registry that was created by Terraform using the following command (provide the name of the Azure Container Registry as specified in the terraform.tfvars file):

```bash
docker tag azurenamingtool:latest <the_name_of_your_acr>.azurecr.io/tools/azurenamingtool
docker push <the_name_of_your_acr>.azurecr.io/tools/azurenamingtool
```
