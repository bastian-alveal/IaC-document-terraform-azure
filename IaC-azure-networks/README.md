# IaC-azure-networks

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 🚀 ¿Qué es esto?
Repositorio para definir la infraestructura de red base en Azure usando Terraform, incluyendo VNets y subredes privadas para servicios.

## 🛠️ Prerrequisitos
- Azure CLI instalado y configurado
- Terraform >= 1.5.0
- Suscripción a Azure con permisos apropiados

## 📁 Estructura de Archivos
```
IaC-azure-networks/
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
```
   - Opcional si ya iniciaste sesión en Azure CLI.
```

2. **Variables de Terraform**
```
   - Definir en `terraform.tfvars` los valores para el grupo de recursos y región.
```

## 🔐 Configuración del Backend
Este repositorio utiliza Azure Blob Storage para almacenar el estado remoto de Terraform, configurado en `backend.tf`.

## 🎯 ¿Por qué usarlo?
1. **Centralización**: Define y mantiene la red base para todos los servicios de Azure.
2. **Automatización**: Facilita el despliegue y gestión de subredes para otros equipos/proyectos.
3. **Escalabilidad**: Permite crecer la infraestructura de red de manera controlada.
4. **Colaboración**: El state compartido sirve de base para otros repos y servicios.

---
