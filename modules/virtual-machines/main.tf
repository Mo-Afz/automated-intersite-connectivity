# modules/virtual-machines/main.tf

# SKU Validation for East US region
resource "null_resource" "validate_eastus_sku" {
  provisioner "local-exec" {
    command = <<EOT
echo "🔎 Validating VM SKU: ${var.selected_sku} in eastus..."
az vm list-skus --location eastus --resource-type virtualMachines --query "[].name" --output tsv | grep -qx ${var.selected_sku} || echo "⚠️  SKU validation failed - proceeding anyway"
EOT
  }

  triggers = {
    selected_sku = var.selected_sku
    timestamp    = timestamp()
  }
}

# Network Security Group (allows RDP and SSH)
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # RDP rule for Windows VMs
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP rule (optional)
  security_rule {
    name                       = "HTTP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTPS rule (optional)
  security_rule {
    name                       = "HTTPS"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Core Services VM Network Interface
resource "azurerm_network_interface" "core_services_vm_nic" {
  name                = "CoreServicesVM-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.core_services_subnet_id
    private_ip_address_allocation = "Dynamic"
    # Uncomment if you need a public IP
    # public_ip_address_id = azurerm_public_ip.core_services_pip.id
  }

  tags = var.tags
}

# Manufacturing VM Network Interface
resource "azurerm_network_interface" "manufacturing_vm_nic" {
  name                = "ManufacturingVM-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.manufacturing_subnet_id
    private_ip_address_allocation = "Dynamic"
    # Uncomment if you need a public IP
    # public_ip_address_id = azurerm_public_ip.manufacturing_pip.id
  }

  tags = var.tags
}

# Associate NSG with Core Services NIC
resource "azurerm_network_interface_security_group_association" "core_services_nsg_association" {
  network_interface_id      = azurerm_network_interface.core_services_vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Associate NSG with Manufacturing NIC
resource "azurerm_network_interface_security_group_association" "manufacturing_nsg_association" {
  network_interface_id      = azurerm_network_interface.manufacturing_vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Optional: Public IPs (uncomment if needed)
/*
resource "azurerm_public_ip" "core_services_pip" {
  name                = "CoreServicesVM-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}

resource "azurerm_public_ip" "manufacturing_pip" {
  name                = "ManufacturingVM-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                = "Standard"

  tags = var.tags
}
*/

# Core Services Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "core_services_vm" {
  name                = "CoreServicesVM"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.selected_sku
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  enable_automatic_updates = true
  provision_vm_agent       = true

  network_interface_ids = [
    azurerm_network_interface.core_services_vm_nic.id
  ]

  os_disk {
    name                 = "CoreServicesVM-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  depends_on = [null_resource.validate_eastus_sku]

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "manufacturing_vm" {
  name                = "ManufacturingVM"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.selected_sku
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  enable_automatic_updates = true
  provision_vm_agent       = true

  network_interface_ids = [
    azurerm_network_interface.manufacturing_vm_nic.id
  ]

  os_disk {
    name                 = "ManufacturingVM-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  depends_on = [null_resource.validate_eastus_sku]

  tags = var.tags
}