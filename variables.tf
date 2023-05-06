variable "location" {
  description = "The Azure region for the deployment"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the Azure Storage Account"
  type        = string
}

variable "managed_identity_name" {
  description = "The name of the User Assigned Managed Identity"
  type        = string
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "app_service_name" {
  description = "The name of the Web App"
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string

}



