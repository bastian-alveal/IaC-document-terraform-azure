# Terraform para Infraestructura como Código (IaC)

[![Terraform](https://img.shields.io/badge/terraform-20232a.svg?style=for-the-badge&logo=terraform&logoColor=6298ff)](https://terraform.io)
[![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)

## 📋 Índice
- [🚀 ¿Qué es esto?](#qué-es-esto)
- [🛠️ Tecnologías Utilizadas](#tecnologías-utilizadas)
- [📦 Repositorios Disponibles](#repositorios-disponibles)
- [📁 Archivos Necesarios](#archivos-necesarios)
- [📁 Estructura de Archivos](#estructura-de-archivos)
- [🎯 ¿Por qué usarlo?](#por-qué-usarlo)
- [☁️ Trabajo Colaborativo con Terraform](#trabajo-colaborativo-con-terraform)

## 🚀 ¿Qué es esto?
Este proyecto utiliza Infraestructura como Código (IaC) para gestionar y automatizar la configuración de infraestructura en Azure. La idea es mantener la infraestructura en archivos de configuración en lugar de configurar manualmente recursos.

## 🛠️ Tecnologías Utilizadas
- [Terraform](https://terraform.io) (Para definición de infraestructura)
- [Azure CLI](https://docs.microsoft.com/cli/azure) (Para interacción con Azure)
- [Git](https://git-scm.com) (Control de versiones)
- Shell Scripts (Automatización)

## 📦 Repositorios Disponibles
- [IaC-azure-appservice](https://github.com/bastian-alveal/IaC-azure-appservice) - Configuración de servicios web en Azure
- [IaC-azureBlob](https://github.com/bastian-alveal/IaC-azureBlob) - Configuración de almacenamiento Blob en Azure

## 📁 Archivos Necesarios
### 📝 Que deben crearse por el usuario:

1. **Variables de Entorno**
```bash
# .env
TF_VAR_subscription_id="your-subscription-id"
TF_VAR_tenant_id="your-tenant-id"
TF_VAR_client_id="your-client-id"
TF_VAR_client_secret="your-client-secret"
```

2. **Archivos de Configuración**
```.tfvars

ghcr_username = "nombre usuarios"
ghcr_pat      = "token-git"  # con permisos de lectura de registri de github

```
- este por si se requiere para servicios con uso de docker utilizar una imagen privada (usar solo local no subir a git)

## 📁 Estructura de Archivos
```
IaC/
├── DOCS/
│   └── README.md
├── IaC-azure-appservice/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│   └── ##aqui iria el .tfvars
├── IaC-azureBlob/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── config/
    ├── .env
    └── config.yaml
```

## 🎯 ¿Por qué usarlo?
1. **Consistencia**: La infraestructura se mantiene igual en todos los entornos
2. **Versionamiento**: Cambios en la infraestructura se pueden rastrear
3. **Automatización**: Reducción de errores humanos
4. **Escalabilidad**: Fácil replicación de infraestructura
5. **Seguridad**: Gestión centralizada de credenciales
6. **Colaboración**: Trabajo en equipo más eficiente con estado compartido

## ☁️ Trabajo Colaborativo con Terraform
Este proyecto utiliza Azure Blob Storage como backend para Terraform, lo que permite:

1. **Estado compartido**: Todos los miembros del equipo acceden al mismo estado de Terraform
2. **Concurrencia**: Prevención de conflictos al trabajar simultáneamente
3. **Seguridad**: Credenciales almacenadas de forma segura en cada equipo

### Configuración del Backend
El repositorio [IaC-azureBlob](https://github.com/bastian-alveal/IaC-azureBlob) se utiliza para crear el almacenamiento Blob donde se guardará el estado de Terraform. Luego, el repositorio [IaC-azure-appservice](https://github.com/bastian-alveal/IaC-azure-appservice) se conecta a este backend a través del archivo `backend.tf`.

### Configuración Local
Para configurar el backend en cada equipo, siga estos pasos:

1. Obtenga la clave de acceso al almacenamiento:
```bash
# Obtener la clave de acceso
az storage account keys list --resource-group "<nombre de recurso>" --account-name "<nombre declarado en archivo backend.tf>"
```
- eliminar las comillas ("") y los(<>)  y reemplazar con los valores respectivos para su uso particular

2. Configure la variable en su archivo de configuración local (`.zshrc` o `.bashrc`):
```bash
# Agregar a ~/.zshrc o ~/.bashrc
echo 'export ARM_ACCESS_KEY="tu-clave-de-acceso"' >> ~/.zshrc
source ~/.zshrc
```

3. Verifique la configuración:
```bash
echo $ARM_ACCESS_KEY
```

**Nota**: Nunca suba las credenciales al repositorio git. Manténgalas en su archivo de configuración local.

## 🚀 Próximos Repositorios (Por Agregar)
- IaC-azure-containerapps
- IaC-azure-postgresql

---
**Nota**: Este README es una guía básica y debe adaptarse según las necesidades específicas del proyecto.
