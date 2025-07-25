# IaC-azure-bd

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 🚀 ¿Qué es esto?
Repositorio que define la base de datos Azure PostgreSQL Flexible Server y su configuración de acceso privado usando Terraform.

## 🛠️ Prerrequisitos
- Azure CLI instalado y configurado
- Terraform >= 1.5.0
- Suscripción a Azure con permisos apropiados

## 📁 Estructura de Archivos
```
IaC-azure-bd/
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── terraform.tfvars
├── README.md
└── .gitignore
```

## 🛠️ Configuración
1. **Variables de entorno**
   - Opcional si ya iniciaste sesión en Azure CLI.

2. **Variables de Terraform**
```bash
# Este archivo se crea localmente y no se sube a git
# Definir usuario, password y tu IP administrativa en  archivo .tfvars
{terraform}.tfvars
```


## 🔐 Configuración del Backend
El estado de Terraform se almacena en Azure Blob Storage, compartido con otros módulos de infraestructura.

## 🎯 ¿Por qué usarlo?
1. **Seguridad**: Solo accesible por subnet privada y/o tu IP.
2. **Automatización**: Creación de BD y endpoints de red 100% declarativos.
3. **Consistencia**: Outputs para integración fácil con otros módulos (ej: containerapp).
4. **Colaboración**: Se integra fácilmente a un flujo DevOps completo.

---