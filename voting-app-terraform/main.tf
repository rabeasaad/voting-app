resource "azurerm_resource_group" "rg" {
  name     = "rg-voting-app"
  location = "Sweden Central"
}

resource "azurerm_container_registry" "acr" {
  name                = "votingappacr${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-voting-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "votingapp"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size = "Standard_B2as_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}
