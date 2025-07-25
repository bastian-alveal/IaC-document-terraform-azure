# IaC-azureBlob - Backend para Terraform State

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 🚀 ¿Qué es esto?
Este repositorio contiene la configuración de Terraform para crear un almacenamiento Blob en Azure que servirá como backend compartido para el estado de Terraform.

## 🛠️ Prerrequisitos
- Azure CLI instalado y configurado
- Terraform >= 1.5.0
- Suscripción a Azure con permisos apropiados
- Credenciales de Azure configuradas

## 📁 Estructura de Archivos
```
IaC-azureBlob/
├── blob-backend.tf
├── README.md
└── .gitignore
```

## 🛠️ Configuración
El módulo utiliza la siguiente configuración del proveedor de Azure:
```hcl
provider "azurerm" {
  features {}
}
```

## 🏗️ Recursos Creados
1. **Resource Group**
   - Nombre: `tfstate-rg`
   - Ubicación: `eastus`

2. **Storage Account**
   - Nombre: `tfstatebastian01` (Nota: Este debe ser único en Azure)
   - Tier: Standard
   - Tipo de Replicación: LRS (Locally Redundant Storage)
   - Versión TLS Mínima: TLS 1.2

3. **Blob Container**
   - Nombre: `tfstate`
   - Tipo de Acceso: Privado

## 🔄 Uso

1. Inicializar Terraform:
```bash
terraform init
```

2. Planear la infraestructura:
```bash
terraform plan
```

3. Aplicar la infraestructura:
```bash
terraform apply
```

## 📊 Salidas

El módulo proporciona las siguientes salidas:
- `tfstate_resource_group`: Nombre del grupo de recursos
- `tfstate_storage_account`: Nombre de la cuenta de almacenamiento
- `tfstate_container`: Nombre del contenedor blob

## 🔐 Consideraciones de Seguridad

- El contenedor blob está configurado con acceso privado
- TLS 1.2 se enforcea para conexiones seguras
- El nombre de la cuenta de almacenamiento debe ser único globalmente
- Las credenciales se manejan a través de la autenticación de Azure
