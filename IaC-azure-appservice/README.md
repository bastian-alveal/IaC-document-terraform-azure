# IaC-azure-appservice

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 🚀 ¿Qué es esto?
Este repositorio contiene la configuración de Terraform para crear y gestionar servicios web en Azure App Service.

## 🛠️ Prerrequisitos
- Azure CLI instalado y configurado
- Terraform >= 1.5.0
- Suscripción a Azure con permisos apropiados
- Credenciales de Azure configuradas

## 📁 Estructura de Archivos
```
IaC-azure-appservice/
├── main.tf
├── backend.tf
├── README.md
└── .gitignore
```

## 🛠️ Configuración
1. **Variables de Entorno**
```bash
# Estas variables se obtienen del archivo .env del proyecto principal
TF_VAR_subscription_id
TF_VAR_tenant_id
TF_VAR_client_id
TF_VAR_client_secret
```
- este punto (1) se puede ignorar si la cuenta que va a ejecutar estos .tf se encuentra logeada en az desde la terminal 

2. **Archivos de Configuración**
```bash
# Este archivo se crea localmente y no se sube a git
{terraform}.tfvars
```

## 🔐 Configuración del Backend
Este repositorio se conecta al backend de Azure Blob Storage configurado en el repositorio principal. El archivo `backend.tf` se utiliza para conectar con el estado compartido.

## 🎯 ¿Por qué usarlo?
1. **Consistencia**: Configuración uniforme de servicios web en Azure
2. **Automatización**: Creación y gestión de recursos sin intervención manual
3. **Seguridad**: Uso de variables de entorno para credenciales
4. **Colaboración**: Estado compartido con otros equipos a través del backend

---
**Nota**: Este README es una guía básica y debe adaptarse según las necesidades específicas del proyecto.
