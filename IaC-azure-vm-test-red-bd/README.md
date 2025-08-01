# IaC-azure-vm-tailscale

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-20232a?style=for-the-badge&logo=terraform&logoColor=6298ff" alt="Terraform"/>
  <img src="https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>
  <img src="https://img.shields.io/badge/Tailscale-000000?style=for-the-badge&logo=tailscale&logoColor=white" alt="Tailscale"/>
</p>

## 🚀 ¿Qué es esto?
Este módulo Terraform implementa una máquina virtual en Azure en subred de bd

## 🛠️ Componentes

### 1. Máquina Virtual en Azure
- Implementación de una VM en Azure
- Configuración de red virtual y subred
- Implementación de NSG (Network Security Group) para seguridad

## 📋 Requisitos

- Terraform >= 1.5.0
- Azure CLI instalado y configurado
- Suscripción a Azure con permisos apropiados

## 📁 Estructura del Proyecto

```
IaC-azure-vm-tailscale/
├── backend.tf           # Configuración del backend de Terraform
├── cloud-init.yaml      # Script de provisionamiento de la VM
├── main.tf              # Configuración principal de Terraform
├── outputs.tf           # Definición de outputs
├── terraform.tfvars     # Variables de configuración
└── variables.tf         # Definición de variables
```

## 🔧 Variables de Configuración

Las variables principales se definen en `variables.tf` y pueden ser configuradas en `terraform.tfvars`:

- `vm_size`: Tamaño de la VM (ej: Standard_B1s)
- `admin_username`: Nombre de usuario administrador
- `tailscale_auth_key`: Clave de autenticación de Tailscale
- `resource_group`: Nombre del grupo de recursos
- `location`: Ubicación de Azure

## 🚀 Implementación

1. Configurar las variables en `terraform.tfvars`
2. Inicializar Terraform:
```bash
terraform init
```

3. Planear la implementación:
```bash
terraform plan
```

4. Aplicar la implementación:
```bash
terraform apply
```


### Motivo de uso y creación

- Esta maquina virtual solo se crea para motivos de prueba de comunicación


## 📝 Notas

- Este módulo está diseñado para implementarse en un entorno de Azure existente
---