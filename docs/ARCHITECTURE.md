# 🏗️ Arquitectura del Laboratorio Backstage

## 📋 Resumen

Este documento describe la arquitectura completa del laboratorio de Backstage configurado con DevContainers y PostgreSQL.

## 🎯 Componentes Principales

### 1. 🐳 DevContainer Environment
- **Base**: Node.js 18 sobre Debian Bullseye
- **Herramientas**: Yarn, Git, Vim, netcat, build-essential
- **Features**: GitHub CLI, Git avanzado
- **Propósito**: Entorno de desarrollo consistente y reproducible

### 2. 🌐 Aplicación Backstage
```
backstage/
├── packages/
│   ├── app/          # Frontend React (Puerto 3000)
│   └── backend/      # Backend Node.js (Puerto 7007)
├── examples/         # Entidades y plantillas de ejemplo
└── *.yaml           # Configuración
```

### 3. 🗄️ Base de Datos PostgreSQL
- **Versión**: PostgreSQL 15
- **Puerto**: 5432
- **Bases de datos**:
  - `backstage_plugin_catalog` (principal)
  - `backstage_plugin_auth`
  - `backstage_plugin_scaffolder`

## 🔄 Diagrama de Componentes Detallado

```
                    🖥️  DEVELOPMENT MACHINE
    ┌─────────────────────────────────────────────────────────────────┐
    │                                                                 │
    │  📝 VS Code                🌐 Browser               🔧 DB Tools │
    │  + DevContainers          localhost:3000           localhost:5432│
    │       │                        ▲                        ▲       │
    │       │ Attaches to            │ HTTP                   │ TCP    │
    └───────┼────────────────────────┼────────────────────────┼───────┘
            ▼                        │                        │
    ┌─────────────────────────────────────────────────────────────────┐
    │                    🐳 DOCKER ENVIRONMENT                       │
    │                                                                 │
    │ ┌─────────────────────────────────────────────────────────────┐ │
    │ │                📦 backstage-dev Container                   │ │
    │ │                                                             │ │
    │ │ ┌─────────────────────┐       ┌─────────────────────────┐   │ │
    │ │ │   🌐 FRONTEND       │◀─────▶│      ⚙️ BACKEND         │   │ │
    │ │ │                     │  HTTP │                         │   │ │
    │ │ │ • React + TS        │ :3000 │ • Node.js + Express    │   │ │
    │ │ │ • Material-UI       │       │ • GraphQL + REST       │   │ │
    │ │ │ • Webpack Dev       │       │ • Authentication       │   │ │
    │ │ │ • Hot Reload        │       │ • Plugin System        │   │ │
    │ │ └─────────────────────┘       └─────────────┬───────────┘   │ │
    │ │            ▲                                 │ :7007         │ │
    │ │            │                                 ▼               │ │
    │ │ ┌──────────────────────────────────────────────────────────┐ │ │
    │ │ │                📋 CONFIGURATION                          │ │ │
    │ │ │                                                          │ │ │
    │ │ │ • app-config.local.yaml  (Database connection)          │ │ │
    │ │ │ • .env                   (Environment variables)        │ │ │
    │ │ │ • examples/entities.yaml (Users: guest, admin)          │ │ │
    │ │ │ • examples/org.yaml      (Groups: guests, admins)       │ │ │
    │ │ │ • examples/template/     (Hello World template)         │ │ │
    │ │ └──────────────────────────────────────────────────────────┘ │ │
    │ │                                                             │ │
    │ │ ┌──────────────────────────────────────────────────────────┐ │ │
    │ │ │              🛠️ DEVELOPMENT TOOLS                        │ │ │
    │ │ │                                                          │ │ │
    │ │ │ Runtime:   🟢 Node.js 18.x                              │ │ │
    │ │ │ Package:   📦 Yarn 4.4.1                               │ │ │
    │ │ │ VCS:       📂 Git + 🐙 GitHub CLI                       │ │ │
    │ │ │ Editor:    ✏️  Vim                                       │ │ │
    │ │ │ Network:   🌐 netcat                                    │ │ │
    │ │ │ DB Client: 🗄️ PostgreSQL client                         │ │ │
    │ │ │ Build:     🔨 build-essential                           │ │ │
    │ │ └──────────────────────────────────────────────────────────┘ │ │
    │ └─────────────────────────────────────────────────────────────┘ │
    │                               │                                 │
    │                               │ SQL Queries                     │
    │                               ▼ TCP :5432                      │
    │ ┌─────────────────────────────────────────────────────────────┐ │
    │ │                   🗄️ postgres Container                     │ │
    │ │                                                             │ │
    │ │  ┌─────────────────────────┐  ┌─────────────────────────┐   │ │
    │ │  │    🐘 PostgreSQL 15     │  │   💾 Persistent Data   │   │ │
    │ │  │                         │  │                         │   │ │
    │ │  │ 🗃️ Databases:            │  │ 📊 Contains:            │   │ │
    │ │  │ • backstage_plugin_...  │─▶│ • Catalog entities     │   │ │
    │ │  │ • backstage_plugin_...  │  │ • User profiles        │   │ │
    │ │  │ • backstage_plugin_...  │  │ • Group memberships    │   │ │
    │ │  │                         │  │ • Templates & configs  │   │ │
    │ │  │ 🔐 Users:               │  │ • Authentication data  │   │ │
    │ │  │ • User: backstage       │  │ • Search indexes       │   │ │
    │ │  │ • Pass: backstage       │  │                         │   │ │
    │ │  │ • Port: 5432            │  │ Volume: postgres-data   │   │ │
    │ │  └─────────────────────────┘  └─────────────────────────┘   │ │
    │ └─────────────────────────────────────────────────────────────┘ │
    │                                                                 │
    │           🌐 backstage-network (Docker Bridge)                 │
    └─────────────────────────────────────────────────────────────────┘
                                │
                                │ Port Forwarding
                                ▼
    ┌─────────────────────────────────────────────────────────────────┐
    │                    🌍 EXTERNAL ACCESS                           │
    ├─────────────────────────────────────────────────────────────────┤
    │                                                                 │
    │  📱 Frontend Access        📡 API Access         🔍 DB Access   │
    │  http://localhost:3000     http://localhost:7007  :5432         │
    │                                                                 │
    │  🔐 Authentication: GUEST MODE ENABLED                         │
    │  👤 Users: guest, admin                                        │
    │  👥 Groups: guests, admins                                     │
    │                                                                 │
    └─────────────────────────────────────────────────────────────────┘
```

## 🔐 Flujo de Autenticación

```
👤 Usuario          🌐 Frontend         ⚙️ Backend          🗄️ PostgreSQL
   │                    │                   │                     │
   │ 1. Access           │                   │                     │
   │ localhost:3000      │                   │                     │
   ├────────────────────▶│                   │                     │
   │                    │ 2. Load React App │                     │
   │                    │                   │                     │
   │                    │ 3. Request        │                     │
   │                    │ auth config       │                     │
   │                    ├──────────────────▶│                     │
   │                    │                   │ 4. Read config      │
   │                    │                   │ app-config.local    │
   │                    │                   │                     │
   │                    │ 5. Return config  │                     │
   │                    │ (guest enabled)   │                     │
   │                    │◀──────────────────┤                     │
   │                    │ 6. Show           │                     │
   │                    │ "Sign In as Guest"│                     │
   │                    │                   │                     │
   │ 7. Click           │                   │                     │
   │ "Sign In as Guest" │                   │                     │
   ├────────────────────▶│                   │                     │
   │                    │ 8. POST           │                     │
   │                    │ /api/auth/guest   │                     │
   │                    ├──────────────────▶│                     │
   │                    │                   │ 9. Find/Create      │
   │                    │                   │ guest user          │
   │                    │                   ├────────────────────▶│
   │                    │                   │                     │
   │                    │                   │ 10. User data       │
   │                    │                   │◀────────────────────┤
   │                    │ 11. JWT token +   │                     │
   │                    │ user data         │                     │
   │                    │◀──────────────────┤                     │
   │                    │ 12. Store token   │                     │
   │                    │ & update UI       │                     │
   │                    │                   │                     │
   │ 13. Authenticated  │                   │                     │
   │ as "Guest User"    │                   │                     │
   │◀────────────────────                   │                     │
   │                    │                   │                     │
   
💡 Configuración de Autenticación:
   • Modo: development (guest auth enabled)
   • Usuario por defecto: guest
   • Permisos: acceso completo al catálogo
   • Sesión: almacenada en localStorage del browser
```

## 📊 Flujo de Datos del Catálogo

```
📁 FUENTES DE DATOS              🔄 PROCESAMIENTO                🗄️ ALMACENAMIENTO
                                                                              
┌─────────────────────────┐                                   ┌──────────────────┐
│  👥 entities.yaml       │      ┌─────────────────────────┐   │  🗃️ catalog_      │
│  • Users: guest, admin  │────▶ │   📖 Catalog Processor │──▶│   entities       │
│  • Groups: guests, ...  │      │                         │   │  (Main table)    │
└─────────────────────────┘      │   Reads YAML files     │   └──────────────────┘
                                 │   Parses entity defs    │                      
┌─────────────────────────┐      │                         │   ┌──────────────────┐
│  🏢 org.yaml            │────▶ │                         │──▶│  👥 catalog_users │
│  • Organization         │      └─────────────────────────┘   │  (User profiles) │
│  • Team structure       │                 │                 └──────────────────┘
└─────────────────────────┘                 ▼                                    
                                 ┌─────────────────────────┐   ┌──────────────────┐
┌─────────────────────────┐      │   ✅ Validation        │──▶│  👥 catalog_     │
│  🏗️ template/           │      │                         │   │   groups         │
│  • Hello World template │────▶ │   Schema validation     │   │  (Group data)    │
│  • Scaffolder config    │      │   Reference checks     │   └──────────────────┘
└─────────────────────────┘      └─────────────────────────┘                      
                                                │                                  
                                                ▼                                  
                                 ┌─────────────────────────┐   ┌──────────────────┐
                                 │   🔗 Resolution         │──▶│  🏗️ catalog_     │
                                 │                         │   │   locations      │
                                 │   Resolves references   │   │  (Templates)     │
                                 │   Links entities        │   └──────────────────┘
                                 └─────────────────────────┘                      
                                                │                                  
                                                ▼                                  
🌐 API & FRONTEND                ┌─────────────────────────┐                      
                                 │                         │                      
┌─────────────────────────┐      │    🔌 GraphQL API      │                      
│  🎨 Catalog UI          │◀─────│    /api/catalog/       │                      
│  • Components List      │ HTTP │                        │                      
│  • Service Overview     │      │    • entities          │                      
└─────────────────────────┘      │    • users             │                      
                                 │    • groups            │                      
┌─────────────────────────┐      │    • search            │                      
│  👥 User Management     │◀─────│                        │                      
│  • User Profiles        │      └─────────────────────────┘                      
│  • Group Memberships    │                 ▲                                    
│  • Permissions          │                 │                                    
└─────────────────────────┘                 │                                    
                                            │                                    
┌─────────────────────────┐                 │                                    
│  🔍 Search Interface    │◀────────────────┘                                    
│  • Entity Search        │                                                      
│  • Full-text Search     │                                                      
│  • Faceted Filters      │                                                      
└─────────────────────────┘                                                      

🔄 PROCESO DE ACTUALIZACIÓN:
1. 📂 File Watcher detecta cambios en examples/
2. 🔄 Catalog Processor relee archivos modificados  
3. ✅ Validación de nuevas entidades
4. 🔗 Resolución de referencias actualizadas
5. 💾 Actualización incremental en PostgreSQL
6. 🌐 Cache invalidation en API
7. 🔄 Frontend actualiza automáticamente via WebSocket
```

## 🚀 Scripts y Comandos

### Scripts de Yarn Disponibles
```bash
yarn start              # 🚀 Inicia frontend + backend
yarn start-backend      # ⚙️ Solo backend
yarn build:all          # 🏗️ Build completo
yarn test               # 🧪 Ejecuta tests
yarn lint               # 🔍 Code linting
yarn clean              # 🧹 Limpia cache
```

### Scripts de Configuración
```bash
./setup-backstage.sh    # 🔧 Configuración completa
./setup-simple.sh       # ⚡ Configuración simplificada
```

## 🌐 Puertos y Servicios

| Servicio | Puerto | Protocolo | Descripción |
|----------|--------|-----------|-------------|
| Frontend | 3000 | HTTP | React app principal |
| Backend | 7007 | HTTP | API GraphQL/REST |
| PostgreSQL | 5432 | TCP | Base de datos |

## 📁 Archivos de Configuración Clave

### `app-config.local.yaml`
```yaml
app:
  title: Backstage Lab
  baseUrl: http://localhost:3000

backend:
  baseUrl: http://localhost:7007
  database:
    client: pg
    connection:
      host: postgres
      port: 5432
      user: backstage
      password: backstage
      database: backstage_plugin_catalog

auth:
  environment: development
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true
```

### `.env`
```bash
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage
POSTGRES_DB=backstage_plugin_catalog
BACKEND_URL=http://localhost:7007
FRONTEND_URL=http://localhost:3000
```

## 🔧 Troubleshooting

### Puertos en Uso
```bash
# Verificar qué usa cada puerto
lsof -i :3000
lsof -i :7007
lsof -i :5432
```

### Conectividad PostgreSQL
```bash
# Desde el container
nc -z postgres 5432
psql -h postgres -U backstage -d backstage_plugin_catalog
```

### Logs de Containers
```bash
# Ver logs de PostgreSQL
docker logs devcontainer_postgres_1

# Ver logs de la aplicación
# (se muestran directamente en la terminal cuando ejecutas yarn start)
```

## 📈 Escalabilidad y Extensiones

### Agregar Nuevos Plugins
1. **Backend**: `yarn --cwd packages/backend add @backstage/plugin-[name]`
2. **Frontend**: `yarn --cwd packages/app add @backstage/plugin-[name]`
3. **Configurar** en `app-config.local.yaml`
4. **Reiniciar** con `yarn start`

### Integración con GitHub
```yaml
# En app-config.local.yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}

catalog:
  providers:
    github:
      myOrg:
        organization: 'your-org'
        catalogPath: '/catalog-info.yaml'
```

### TechDocs
```yaml
# En app-config.local.yaml  
techdocs:
  builder: 'local'
  generator:
    runIn: 'local'
  publisher:
    type: 'local'
```

Este laboratorio proporciona una base sólida para experimentar con Backstage y desarrollar un portal de desarrollador completo.