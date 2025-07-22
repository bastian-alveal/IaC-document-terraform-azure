# Terraform para Infraestructura como Código (IaC)

## Índice
- [¿Qué es esto?](#qué-es-esto)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Repositorios Disponibles](#repositorios-disponibles)
- [Archivos Necesarios](#archivos-necesarios)
- [Estructura de Archivos](#estructura-de-archivos)

## ¿Qué es esto?
Este proyecto utiliza Infraestructura como Código (IaC) para gestionar y automatizar la configuración de infraestructura en Azure. La idea es mantener la infraestructura en archivos de configuración en lugar de configurar manualmente recursos.

## Tecnologías Utilizadas
- Terraform (Para definición de infraestructura)
- Azure CLI (Para interacción con Azure)
- Git (Control de versiones)
- Shell Scripts (Automatización)

## Repositorios Disponibles
- [IaC-azure-appservice](../IaC-azure-appservice) - Configuración de servicios web en Azure
- [IaC-azureBlob](../IaC-azureBlob) - Configuración de almacenamiento Blob en Azure

## Archivos Necesarios
### Que deben crearse por el usuario:

1. **Variables de Entorno**
```bash
# .env
TF_VAR_subscription_id="your-subscription-id"
TF_VAR_tenant_id="your-tenant-id"
TF_VAR_client_id="your-client-id"
TF_VAR_client_secret="your-client-secret"
```
- el punto 1 se puede omitir si actualmete se encuentra logeado en AZ desde la terminal 

2. **Archivos de Configuración**
```.tfvars

ghcr_username = "nombre usuarios"
ghcr_pat      = "token-git"  # con permisos de lectura de registri de github

```
- este por si se requiere para servicios con uso de docker utilizar una imagen privada (usar solo local no subir a git)

## Estructura de Archivos
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

## ¿Por qué usarlo?
1. **Consistencia**: La infraestructura se mantiene igual en todos los entornos
2. **Versionamiento**: Cambios en la infraestructura se pueden rastrear
3. **Automatización**: Reducción de errores humanos
4. **Escalabilidad**: Fácil replicación de infraestructura
5. **Seguridad**: Gestión centralizada de credenciales

## Próximos Repositorios (Por Agregar)
- IaC-azure-containerapps
- IaC-azure-postgresql

---
**Nota**: Este README es una guía básica y debe adaptarse según las necesidades específicas del proyecto.
