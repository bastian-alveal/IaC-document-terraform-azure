# IaC-azure-vm-tailscale

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-20232a?style=for-the-badge&logo=terraform&logoColor=6298ff" alt="Terraform"/>
  <img src="https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>
  <img src="https://img.shields.io/badge/Tailscale-000000?style=for-the-badge&logo=tailscale&logoColor=white" alt="Tailscale"/>
</p>

## 🚀 ¿Qué es esto?
Este módulo Terraform implementa una máquina virtual en Azure con integración de Tailscale para acceso seguro y cifrado.

## 🛠️ Componentes

### 1. Máquina Virtual en Azure
- Implementación de una VM en Azure
- Configuración de red virtual y subred
- Implementación de NSG (Network Security Group) para seguridad

### 2. Integración Tailscale
- Instalación automática de Tailscale durante el provisionamiento
- Configuración de autenticación con Tailscale
- Configuración de red privada segura

## 📋 Requisitos

- Terraform >= 1.5.0
- Azure CLI instalado y configurado
- Cuenta en Tailscale
- Token de auth Tailscale (generado en página de administración de Tailscale) (asignarle uso de 1 sola oportunidad)
- El token de auth Tailscale debe ser pasado a través de una variable de entorno
- Suscripción a Azure con permisos apropiados

## 📁 Estructura del Proyecto

```
IaC-azure-vm-tailscale/
├── backend.tf           # Configuración del backend de Terraform
├── cloud-init.yaml.tpl  # Script de provisionamiento de la VM
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

## 🔐 Seguridad

- La VM se configura con Tailscale para acceso seguro
- El tráfico se cifra a través de la red Tailscale
- Las credenciales se manejan a través de variables de entorno
- El acceso a la VM se controla a través de Tailscale
- El token de autenticación de Tailscale se maneja a través de variables de entorno

### Configuración del Token de Tailscale

1. Generar el token de auth en la página de administración de Tailscale
2. Crear un archivo `terraform.tfvars` en el directorio del proyecto:
```bash
# .env
rg_name  = "demo-terraform"
location = "centralus"
tailscale_authkey = "tskey-auth-xxxxx-xxxxx"
```

3. El token se inyectará automáticamente en el archivo `cloud-init.yaml.tpl` durante la implementación de Terraform

## 📝 Notas

- Este módulo está diseñado para implementarse en un entorno de Azure existente
- Se recomienda tener una cuenta Tailscale configurada antes de la implementación
- Las credenciales de Tailscale deben mantenerse seguras y no subirse al repositorio

---
