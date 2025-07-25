# IaC-azure-containerapp

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 🚀 ¿Qué es esto?
Repositorio que define la infraestructura de Azure Container App y su entorno seguro en red privada, usando Terraform.

## 🛠️ Prerrequisitos
- Azure CLI instalado y configurado
- Terraform >= 1.5.0
- Suscripción a Azure con permisos apropiados

## 📁 Estructura de Archivos
```
IaC-azure-containerapp/
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
```
   - Definir la imagen del backend y tag en `terraform.tfvars`.
```

## 🔐 Configuración del Backend
Utiliza Azure Blob Storage para almacenar el estado remoto, permitiendo la colaboración y dependencia desde otros proyectos (ej: appservice).

## 🎯 ¿Por qué usarlo?
1. **Seguridad**: El backend solo es accesible por red privada.
2. **Escalabilidad**: Define parámetros de réplicas y recursos fácilmente.
3. **Trazabilidad**: Incluye outputs clave para consumo por otros repos.
4. **Colaboración**: Permite a otros servicios conectarse de forma controlada.

---
