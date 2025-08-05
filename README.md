# 🚀 Backstage Lab - Guía Completa

Un entorno de desarrollo completo para **Backstage** con integración GitHub, autenticación OAuth, base de datos PostgreSQL y DevContainer totalmente configurado.

## 📋 Tabla de Contenidos

- [🛠️ Prerrequisitos](#️-prerrequisitos)
- [🏗️ Configuración Inicial](#️-configuración-inicial)
- [🔐 Configuración de GitHub](#-configuración-de-github)
- [🚀 Inicio Rápido](#-inicio-rápido)
- [🌟 Características](#-características)
- [🔧 Troubleshooting](#-troubleshooting)
- [📚 Documentación Técnica](#-documentación-técnica)

---

## 🛠️ Prerrequisitos

- **Docker Desktop** ejecutándose
- **VS Code** con extensión Dev Containers
- **Cuenta de GitHub** (para integración y autenticación)

---

## 🏗️ Configuración Inicial

### 1️⃣ Abrir en DevContainer

```bash
# Clonar el repositorio
git clone <tu-repo-url>
cd backstage-lab-1

# Abrir en VS Code
code .

# VS Code te preguntará si quieres abrir en DevContainer - selecciona "Yes"
```

### 2️⃣ Ejecutar configuración inicial

```bash
# Dentro del DevContainer
./setup-backstage.sh
```

**Este script automatiza:**
- ✅ Instalación de dependencias PostgreSQL
- ✅ Configuración de base de datos
- ✅ Creación de entidades de ejemplo
- ✅ Configuración de variables de entorno
- ✅ Verificación de conectividad

---

## 🔐 Configuración de GitHub

### 🎯 **Paso 1: GitHub Personal Access Token**

#### 1.1 Crear el Token
1. **Ir a GitHub Settings**
   - 🔗 https://github.com/settings/tokens
   - Click **"Generate new token"** → **"Generate new token (classic)"**

2. **Configurar el token**
   - **Name**: `Backstage Lab Integration`
   - **Expiration**: `90 days` (o más según necesites)
   - **Permisos requeridos**:
     ```
     ✅ repo                 (Full control of private repositories)
     ✅ read:org             (Read org and team membership)
     ✅ read:user            (Read user profile data)
     ✅ user:email           (Access user email addresses)
     ✅ workflow             (Update GitHub Action workflows)
     ```

3. **Copiar el token** 
   - ⚠️ **IMPORTANTE**: Cópialo ahora, no podrás verlo después
   - Formato: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### 1.2 Configurar el Token
Edita `backstage/.env`:
```env
GITHUB_TOKEN=ghp_tu_token_personal_access_aqui
```

### 🎯 **Paso 2: GitHub OAuth App**

#### 2.1 Crear la OAuth App
1. **Crear nueva OAuth App**
   - 🔗 https://github.com/settings/applications/new
   - **Application name**: `Backstage Lab`
   - **Homepage URL**: `http://localhost:3000`
   - **Application description**: `Backstage development environment`
   - **Authorization callback URL**: `http://localhost:7007/api/auth/github/handler/frame`

2. **Obtener credenciales**
   - **Client ID**: Se muestra inmediatamente
   - **Client Secret**: Click "Generate a new client secret"

#### 2.2 Configurar OAuth App
Edita `backstage/.env`:
```env
AUTH_GITHUB_CLIENT_ID=Ov23li_tu_client_id_aqui
AUTH_GITHUB_CLIENT_SECRET=tu_client_secret_generado_aqui
```

### 🎯 **Paso 3: Script de Configuración Automática**

**Opción A: Script interactivo (recomendado)**
```bash
./setup-github.sh
```

**Opción B: Manual**
```bash
# Editar archivo .env directamente
nano backstage/.env
```

### 📋 **Verificación de Variables**
Tu archivo `backstage/.env` debe verse así:
```env
# Configuración de base de datos
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage
POSTGRES_DB=backstage_plugin_catalog

# URLs de la aplicación
BACKEND_URL=http://localhost:7007
FRONTEND_URL=http://localhost:3000

# Backend authentication secret
BACKEND_SECRET=/2WBksvq3W/2XbbrY5MWhsSBL4naJVkJc5XlX6zJDlk=

# GitHub integration - Personal Access Token
GITHUB_TOKEN=ghp_YOUR_GITHUB_PERSONAL_ACCESS_TOKEN_HERE

# GitHub OAuth App
AUTH_GITHUB_CLIENT_ID=Ov23lif91tKdQrBzGVJ2
AUTH_GITHUB_CLIENT_SECRET=7cb976cfbc30b9a2df67c50b3b3444abf4fcc580
```

---

## 🚀 Inicio Rápido

### 1️⃣ Configurar GitHub
```bash
# Ejecutar si no lo has hecho
./setup-github.sh
```

### 2️⃣ Iniciar Backstage
```bash
cd backstage
yarn start
```

### 3️⃣ Acceder a la aplicación
- **🌐 Frontend**: http://localhost:3000
- **📡 Backend API**: http://localhost:7007

### 4️⃣ Opciones de Autenticación

Al acceder verás dos botones:

#### 🔓 **Guest Access** 
- Acceso inmediato sin autenticación
- Ideal para explorar funcionalidades

#### 🐙 **Sign in with GitHub**
- Autenticación con tu cuenta GitHub
- Acceso completo a integraciones
- Usa la OAuth App que configuraste

---

## 🌟 Características

### ✅ **Catálogo de Servicios**
- 📦 Importación automática de repositorios GitHub
- 📋 Metadatos y documentación centralizada
- 🔗 Relaciones entre servicios y componentes
- 🏷️ Etiquetado y categorización

### ✅ **Scaffolding Templates**
- 🏗️ Creación rápida de nuevos proyectos
- 📝 Templates personalizables con variables
- 🐙 Integración directa con GitHub para crear repos
- 🔄 Workflow completo de desarrollo

### ✅ **Documentación Técnica (TechDocs)**
- 📚 Documentación como código
- 🎨 Renderizado automático de Markdown
- 🔄 Sincronización con repositorios
- 🔍 Búsqueda integrada en documentos

### ✅ **Autenticación Dual**
- 🔓 **Guest Access**: Para desarrollo rápido
- 🐙 **GitHub OAuth**: Para integración completa
- 👥 Gestión de usuarios y grupos
- 🔐 Permisos granulares

### ✅ **Integración GitHub Completa**
- 🔄 Sincronización automática de repositorios
- 📊 Información de commits, issues, y PRs
- 🏷️ Importación de topics y metadatos
- 🔔 Webhooks para actualizaciones en tiempo real

### ✅ **Base de Datos PostgreSQL**
- 💾 Persistencia completa de datos
- 📈 Escalabilidad para grandes volúmenes
- 🔒 Backups automáticos
- 🔍 Consultas SQL avanzadas

---

## 🔧 Troubleshooting

### ❌ **Error: "Failed to sign in as a guest"**

**Causa:** Backend no configurado correctamente

**Solución:**
```bash
# 1. Verificar que el backend esté corriendo
curl http://localhost:7007/api/auth/guest/refresh

# 2. Revisar variables de entorno
cd backstage && cat .env | grep BACKEND_SECRET

# 3. Reiniciar Backstage
# Ctrl+C para parar, luego:
yarn start
```

### ❌ **Error: "Could not fetch catalog entities"**

**Causa:** Problemas de conectividad con PostgreSQL

**Solución:**
```bash
# 1. Verificar PostgreSQL está corriendo
docker ps | grep postgres

# 2. Verificar conectividad desde el backend
docker exec backstage-lab-1_devcontainer-postgres-1 pg_isready -U backstage

# 3. Verificar configuración de base de datos
cd backstage && cat .env | grep POSTGRES

# 4. Reiniciar servicios si es necesario
docker-compose -f .devcontainer/docker-compose.yml restart
```

### ❌ **Error: "GitHub integration not working"**

**Causa:** Token o configuración OAuth incorrecta

**Solución:**
```bash
# 1. Verificar token GitHub
curl -H "Authorization: token YOUR_GITHUB_TOKEN" https://api.github.com/user

# 2. Verificar permisos del token
# Debe tener: repo, read:org, read:user, user:email

# 3. Verificar OAuth App callback URL
# Debe ser exactamente: http://localhost:7007/api/auth/github/handler/frame

# 4. Revisar variables en .env
cd backstage && cat .env | grep -E "(GITHUB|AUTH_GITHUB)"
```

### ❌ **Error: "DevContainer build failed"**

**Causa:** Problemas con Docker o construcción de imagen

**Solución:**
```bash
# 1. Verificar Docker Desktop está corriendo
docker version

# 2. Limpiar containers y imágenes
docker system prune -a

# 3. Reconstruir DevContainer
# En VS Code: Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# 4. Si persiste, revisar logs
# Ver logs de construcción en VS Code Output panel
```

### 🔍 **Logs y Debugging**

#### Backend Logs
```bash
cd backstage
yarn start:backend
# Logs aparecerán en la consola
```

#### Frontend Logs
```bash
cd backstage
yarn workspace app start
# Logs en consola del navegador (F12)
```

#### Database Logs
```bash
docker logs backstage-lab-1_devcontainer-postgres-1
```

#### Verificar Configuración
```bash
# Variables de entorno
env | grep -E "(GITHUB|POSTGRES|BACKEND|AUTH)"

# Estado de servicios
curl http://localhost:7007/healthcheck
curl http://localhost:3000

# Test de conectividad
nc -z postgres 5432  # PostgreSQL
nc -z localhost 7007 # Backend
nc -z localhost 3000 # Frontend
```

---

## 📚 Documentación Técnica

### 🏗️ **Arquitectura del Sistema**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            🖥️  HOST MACHINE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│  VS Code + Dev Containers Extension                                         │
│  ↓ Connects to                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        🐳 DEVCONTAINER ENVIRONMENT                         │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                    📦 backstage-dev Container                       │  │
│  │                                                                     │  │
│  │  ┌─────────────────────────┐    ┌─────────────────────────────────┐ │  │
│  │  │    🌐 FRONTEND          │    │        ⚙️  BACKEND             │ │  │
│  │  │   React + TypeScript    │◀──▶│      Node.js + Express         │ │  │
│  │  │   Port: 3000            │    │      Port: 7007                │ │  │
│  │  │   Material-UI Theme     │    │      GraphQL + REST           │ │  │
│  │  │   🔐 OAuth Login        │    │      🔐 Auth Backend           │ │  │
│  │  └─────────────────────────┘    └─────────────────────────────────┘ │  │
│  │                    ▲                           │                     │  │
│  │                    │                           ▼                     │  │
│  │  ┌─────────────────────────────────────────────────────────────────┐ │  │
│  │  │              📋 CONFIGURATION LAYER                             │ │  │
│  │  │  • app-config.yaml (main config)                               │ │  │
│  │  │  • .env (secrets & variables)                                  │ │  │
│  │  │  • examples/ (sample data)                                     │ │  │
│  │  │  • 🐙 GitHub Integration                                       │ │  │
│  │  └─────────────────────────────────────────────────────────────────┘ │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                       │
│                                    ▼ SQL Queries + Connection Pool         │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │                      🗄️  postgres Container                        │  │
│  │                                                                     │  │
│  │    ┌─────────────────────────┐    ┌─────────────────────────────┐   │  │
│  │    │     PostgreSQL 15       │    │    💾 Persistent Storage   │   │  │
│  │    │     Port: 5432          │───▶│    postgres-data volume    │   │  │
│  │    │     Multi-DB Support    │    │                            │   │  │
│  │    │                         │    │  📊 Stores:                │   │  │
│  │    │  🗃️  Databases:          │    │  • Catalog entities        │   │  │
│  │    │  • backstage_plugin_... │    │  • User sessions           │   │  │
│  │    │  • auth & permissions   │    │  • GitHub integration     │   │  │
│  │    │  • search indexes       │    │  • Templates & workflows   │   │  │
│  │    └─────────────────────────┘    └─────────────────────────────┘   │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼ External Integrations
┌─────────────────────────────────────────────────────────────────────────────┐
│                          🌐 EXTERNAL SERVICES                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  🐙 GitHub.com          📊 Monitoring           🔐 External Auth            │
│  ├─ OAuth App           ├─ Health checks        ├─ GitHub OAuth             │
│  ├─ Personal Token      ├─ Metrics              ├─ User sessions            │
│  ├─ Webhook events      └─ Logging              └─ Permission sync          │
│  └─ Repository sync                                                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 🔌 **Puertos y Servicios**

| Puerto | Servicio | Descripción | URL de Acceso |
|--------|----------|-------------|---------------|
| 3000   | Frontend | Interfaz React de Backstage | http://localhost:3000 |
| 7007   | Backend  | API Node.js + GraphQL | http://localhost:7007 |
| 5432   | PostgreSQL | Base de datos principal | localhost:5432 |

### 📁 **Estructura del Proyecto**

```
backstage-lab-1/                           # 🏠 Directorio raíz
│
├── 📋 Documentación y Configuración
│   ├── README.md                          # 📖 Esta guía completa
│   ├── setup-backstage.sh                # 🔧 Script configuración inicial
│   ├── setup-github.sh                   # 🐙 Script configuración GitHub
│   └── fix-frontend.sh                   # 🛠️ Herramientas de debugging
│
├── 🐳 DevContainer (Entorno de Desarrollo)
│   └── .devcontainer/
│       ├── devcontainer.json              # ⚙️ Configuración VS Code
│       ├── docker-compose.yml             # 🐋 Orquestación de servicios
│       ├── Dockerfile                     # 📦 Imagen Node.js 18 + herramientas
│       └── init.sql                       # 🗄️ Script inicialización PostgreSQL
│
└── 🚀 Aplicación Backstage Principal
    └── backstage/
        │
        ├── 📦 Arquitectura Monorepo
        │   ├── packages/app/               # 🌐 Frontend (React + TypeScript)
        │   │   ├── src/                   # Componentes y páginas
        │   │   ├── public/                # Assets estáticos
        │   │   └── package.json           # Dependencias frontend
        │   │
        │   └── packages/backend/          # ⚙️ Backend (Node.js + Express)
        │       ├── src/index.ts           # 🚪 Punto de entrada principal
        │       ├── src/plugins/           # 🧩 Configuración de plugins
        │       └── package.json           # Dependencias backend
        │
        ├── 📚 Datos de Ejemplo y Templates
        │   └── examples/
        │       ├── entities.yaml          # 👥 Usuarios, grupos, componentes
        │       ├── org.yaml              # 🏢 Estructura organizacional
        │       └── template/             # 🏗️ "Hello World" template
        │           ├── template.yaml      # Definición del template
        │           └── content/           # Archivos del template
        │
        ├── 🔧 Configuración de la Aplicación
        │   ├── app-config.yaml           # 📋 Configuración principal
        │   ├── app-config.production.yaml # 🚀 Config para producción
        │   ├── .env                       # 🔐 Variables de entorno y secretos
        │   ├── backstage.json             # 🎭 Metadatos de Backstage
        │   └── catalog-info.yaml          # 📖 Autodescripción del proyecto
        │
        └── 📦 Gestión y Herramientas
            ├── package.json               # 🏷️ Scripts y dependencias raíz
            ├── yarn.lock                  # 🔒 Lockfile exacto de dependencias
            ├── tsconfig.json             # 📘 Configuración TypeScript
            └── playwright.config.ts       # 🎭 Tests end-to-end
```

### 🌐 **URLs y Endpoints Importantes**

#### Frontend URLs
- **🏠 Homepage**: http://localhost:3000
- **📊 Catalog**: http://localhost:3000/catalog
- **🏗️ Templates**: http://localhost:3000/create
- **👥 Users**: http://localhost:3000/catalog?filters%5Bkind%5D=user
- **📚 Docs**: http://localhost:3000/docs

#### Backend API Endpoints
- **🔍 Health Check**: http://localhost:7007/healthcheck
- **📋 Catalog API**: http://localhost:7007/api/catalog/entities
- **🔐 Auth Endpoints**: 
  - Guest: http://localhost:7007/api/auth/guest/refresh
  - GitHub: http://localhost:7007/api/auth/github/start
- **📊 GraphQL**: http://localhost:7007/graphql

### 🔄 **Flujo de Autenticación**

```mermaid
sequenceDiagram
    participant U as User
    participant F as Frontend (3000)
    participant B as Backend (7007)
    participant G as GitHub
    
    U->>F: Accede a localhost:3000
    F->>U: Muestra opciones de login
    
    alt Guest Access
        U->>F: Click "Guest Access"
        F->>B: POST /api/auth/guest/refresh
        B->>F: Returns guest token
        F->>U: Logged in as Guest
    else GitHub OAuth
        U->>F: Click "Sign in with GitHub"
        F->>B: GET /api/auth/github/start
        B->>G: Redirect to GitHub OAuth
        G->>U: GitHub login page
        U->>G: Enter credentials
        G->>B: Callback with auth code
        B->>G: Exchange code for token
        G->>B: Returns access token
        B->>F: Returns Backstage session
        F->>U: Logged in with GitHub account
    end
```

### 📊 **Estado del Laboratorio**

#### ✅ **Componentes Funcionando**

| Componente | Estado | Versión | Descripción |
|------------|--------|---------|-------------|
| 🐳 DevContainer | ✅ Operativo | Latest | Node.js 18 + herramientas |
| 🗄️ PostgreSQL | ✅ Operativo | 15.0 | Base de datos con datos iniciales |
| ⚙️ Backend | ✅ Operativo | Latest | API completa + auth + GitHub |
| 🌐 Frontend | ✅ Operativo | Latest | React app + Material-UI |
| 🔐 Guest Auth | ✅ Configurado | - | Acceso inmediato para desarrollo |
| 🐙 GitHub OAuth | ✅ Configurado | - | Autenticación con GitHub |
| 📦 Catalog | ✅ Poblado | - | Entidades de ejemplo cargadas |
| 🏗️ Templates | ✅ Disponibles | - | Hello World template funcional |

#### 🎯 **Funcionalidades Verificadas**

- ✅ **Login Guest**: Acceso inmediato sin configuración
- ✅ **Login GitHub**: OAuth completo funcionando  
- ✅ **Catalog browsing**: Navegación de entidades
- ✅ **GitHub integration**: Importación de repos
- ✅ **Template creation**: Scaffolding de proyectos
- ✅ **TechDocs**: Documentación integrada
- ✅ **Search**: Búsqueda global
- ✅ **User management**: Gestión de usuarios y grupos

#### 📈 **Métricas del Laboratorio**

- **🚀 Tiempo de setup**: ~5-10 minutos
- **💾 Espacio en disco**: ~2GB (incluyendo images)
- **🧠 Memoria RAM**: ~1GB en uso
- **⚡ Tiempo de inicio**: ~30-60 segundos
- **🔧 Dependencias**: ~3000 paquetes npm
- **📊 Entidades de ejemplo**: 8 entidades cargadas

---

## 🎯 **Próximos Pasos Sugeridos**

### 🔰 **Para Principiantes**
1. **Explorar el Catalog** - Navega las entidades precargadas
2. **Crear tu primer Component** - Usa el template Hello World
3. **Importar un repo GitHub** - Conecta tu repositorio personal
4. **Personalizar tu perfil** - Edita información de usuario

### 🚀 **Para Desarrollo Avanzado**
1. **Crear plugins custom** - Desarrolla funcionalidad específica
2. **Integrar servicios externos** - APIs, monitoring, CI/CD
3. **Configurar webhooks** - Actualizaciones en tiempo real
4. **Setup producción** - Deployment con Docker/Kubernetes

### 🏢 **Para Uso Empresarial**
1. **SSO Integration** - LDAP, SAML, Azure AD
2. **Multi-environment** - Dev, staging, production configs
3. **Custom templates** - Templates específicos de la empresa
4. **Metrics & monitoring** - Observabilidad completa

---

## 🤝 **Contribución**

### 🔧 **Reportar Issues**
1. Busca en [issues existentes](../../issues)
2. Crea un nuevo issue con:
   - Descripción clara del problema
   - Pasos para reproducir
   - Logs relevantes
   - Información del entorno

### 💡 **Sugerir Mejoras**
1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### 📝 **Mejorar Documentación**
- Actualiza README.md con nuevos hallazgos
- Agrega ejemplos de uso
- Documenta configuraciones avanzadas
- Mejora troubleshooting guide

---

## 📄 **Licencia**

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

---

## 🆘 **Soporte**

### 📞 **Canales de Soporte**
- **🐛 Issues**: [GitHub Issues](../../issues)
- **💬 Discussions**: [GitHub Discussions](../../discussions)
- **📧 Email**: [tu-email@ejemplo.com]

### 🕐 **Tiempos de Respuesta**
- **🔴 Critical**: 24 horas
- **🟡 Normal**: 2-3 días hábiles
- **🟢 Enhancement**: Mejor esfuerzo

---

**🎉 ¡Tu laboratorio Backstage está completamente configurado y listo para producir valor!**

*Última actualización: $(date)*