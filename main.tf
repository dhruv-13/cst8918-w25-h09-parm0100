resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group-parm0100"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name                  = "default"
    node_count            = 1
    vm_size               = "Standard_B2s"
    min_count             = 1
    max_count             = 3
    auto_scaling_enabled  = true
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.31.5" 

  tags = {
    environment = "dev"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

provider "azurerm" {
  features {}
  subscription_id = "aa8bf277-fdd4-4ec4-bcd4-3458ddb8af6c"
}
