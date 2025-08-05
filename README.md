# 🚀 Backstage Lab - Guía Completa

Un entorno de desarrollo completo para **Backstage** con integración GitHub, autenticación OAuth, base de datos PostgreSQL y DevContainer totalmente configurado.

## 📋 Tabla de Contenidos

- [🛠️ Prerrequisitos](#️-prerrequisitos)
- [🏗️ Configuración Inicial](#️-configuración-inicial)
- [🔐 Configuración de GitHub](#-configuración-de-github)
- [🚀 Inicio Rápido](#-inicio-rápido)
- [🌟 Características](#-características)
- [📚 Documentación del Proyecto](#-documentación-del-proyecto)
- [⚙️ Scripts de Configuración](#️-scripts-de-configuración)
- [🏗️ Arquitectura y Estructura del Proyecto](#️-arquitectura-y-estructura-del-proyecto)
- [🎯 Próximos Pasos Sugeridos](#-próximos-pasos-sugeridos)
- [🤝 Contribución](#-contribución)
- [📄 Licencia](#-licencia)
- [🆘 Soporte](#-soporte)

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

## 📚 Documentación del Proyecto

Aquí encontrarás la documentación detallada sobre la arquitectura, configuración y resolución de problemas del proyecto:

- [**Arquitectura del Sistema**](docs/ARCHITECTURE.md)
- [**Guía de Submódulos Git**](docs/git-submodules-guide.md)
- [**Configuración de GitHub**](docs/GITHUB-SETUP.md)
- [**Plan de Resumen**](docs/resume-plan.md)
- [**Guía de Resolución de Problemas (Troubleshooting)**](docs/TROUBLESHOOTING.md)

---

## ⚙️ Scripts de Configuración

Estos scripts te ayudarán a configurar y gestionar tu entorno de desarrollo:

- [**`setup-backstage.sh`**](setup-backstage.sh): Configura la aplicación Backstage, incluyendo dependencias, base de datos y archivos de configuración.
- [**`setup-github.sh`**](setup-github.sh): Asiste en la configuración de la integración de GitHub (tokens y OAuth App).
- [**`setup-simple.sh`**](setup-simple.sh): Un script de configuración simplificado (si aplica).

---

## 🏗️ Arquitectura y Estructura del Proyecto

### 🔄 Diagrama de Componentes Detallado

```mermaid
flowchart TD
    subgraph "🖥️ DEVELOPMENT MACHINE"
        A[📝 VS Code + DevContainers] --> B(🌐 Browser)
        A --> C(🔧 DB Tools)
        B -- HTTP --> D[🐳 DOCKER ENVIRONMENT]
        C -- TCP --> D
    end

    subgraph "🐳 DOCKER ENVIRONMENT"
        D --> E[📦 backstage-dev Container]
        D --> F[🗄️ postgres Container]

        subgraph "📦 backstage-dev Container"
            G[🌐 FRONTEND] <--> H[⚙️ BACKEND]
            H --> I[📋 CONFIGURATION]
            H --> J[🛠️ DEVELOPMENT TOOLS]
            I --> K(app-config.local.yaml)
            I --> L(.env)
            I --> M(examples/)
            J --> N(Runtime: Node.js 18.x)
            J --> O(Package: Yarn 4.4.1)
            J --> P(VCS: Git + GitHub CLI)
            J --> Q(Editor: Vim)
            J --> R(Network: netcat)
            J --> S(DB Client: PostgreSQL client)
            J --> T(Build: build-essential)
        end

        H -- SQL Queries --> F
        F -- TCP :5432 --> D
    end

    subgraph "🗄️ postgres Container"
        U[🐘 PostgreSQL 15] --> V[💾 Persistent Data]
        U --> W(Databases: backstage_plugin_...) 
        U --> X(Users: backstage)
        V --> Y(Catalog entities)
        V --> Z(User profiles)
        V --> AA(Group memberships)
        V --> BB(Templates & configs)
        V --> CC(Authentication data)
        V --> DD(Search indexes)
    end

    subgraph "🌍 EXTERNAL ACCESS"
        EE[📱 Frontend Access] --> FF(http://localhost:3000)
        GG[📡 API Access] --> HH(http://localhost:7007)
        II[🔍 DB Access] --> JJ(:5432)
        KK[🔐 Authentication: GUEST MODE ENABLED]
        LL[👤 Users: guest, admin]
        MM[👥 Groups: guests, admins]
    end

    D -- Port Forwarding --> EE
    D -- Port Forwarding --> GG
    D -- Port Forwarding --> II
```

### 📊 Flujo de Datos del Catálogo

```mermaid
flowchart TD
    subgraph "FUENTES DE DATOS"
        A[📁 entities.yaml] --> B(👥 entities.yaml)
        C[🏢 org.yaml] --> D(🏢 org.yaml)
        E[🏗️ template/] --> F(🏗️ template/)
    end

    subgraph "PROCESAMIENTO"
        B --> G[📖 Catalog Processor]
        D --> G
        F --> G
        G --> H[✅ Validation]
        H --> I[🔗 Resolution]
    end

    subgraph "ALMACENAMIENTO"
        I --> J[🗄️ catalog_entities]
        I --> K[👥 catalog_users]
        I --> L[👥 catalog_groups]
        I --> M[🏗️ catalog_locations]
    end

    subgraph "API & FRONTEND"
        N[🎨 Catalog UI] <-- HTTP --> O[🔌 GraphQL API]
        P[👥 User Management] <-- O
        Q[🔍 Search Interface] <-- O
    end

    I --> O

    subgraph "PROCESO DE ACTUALIZACIÓN"
        R[📂 File Watcher] --> S(🔄 Catalog Processor)
        S --> T(✅ Validación de nuevas entidades)
        T --> U(🔗 Resolución de referencias actualizadas)
        U --> V(💾 Actualización incremental en PostgreSQL)
        V --> W(🌐 Cache invalidation en API)
        W --> X(🔄 Frontend actualiza automáticamente via WebSocket)
    end
```

### 📁 Estructura del Proyecto

```
backstage-lab-1/                           # 🏠 Directorio raíz
│
├── 📋 Documentación y Configuración
│   ├── README.md                          # 📖 Esta guía completa
│   ├── setup-backstage.sh                # 🔧 Script configuración inicial
│   ├── setup-github.sh                   # 🐙 Script configuración GitHub
│   ├── setup-simple.sh                   # 🛠️ Herramientas de debugging
│   └── docs/                              # 📚 Documentación detallada
│       ├── ARCHITECTURE.md                # 🏗️ Arquitectura del Sistema
│       ├── git-submodules-guide.md        # 🌳 Guía de Submódulos Git
│       ├── GITHUB-SETUP.md                # 🐙 Configuración de GitHub
│       ├── resume-plan.md                 # 📝 Plan de Resumen
│       └── TROUBLESHOOTING.md             # 🔧 Guía de Resolución de Problemas
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

---

## 🎯 Próximos Pasos Sugeridos

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