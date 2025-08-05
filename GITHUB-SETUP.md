# 🐙 Guía Completa: Configuración GitHub para Backstage

Esta guía te llevará paso a paso para configurar la integración completa de GitHub con Backstage, incluyendo autenticación OAuth y acceso a repositorios.

## 📋 Resumen de lo que necesitas

Para una integración completa con GitHub necesitas **2 componentes**:

1. **🔑 Personal Access Token** - Para acceso a repositorios y datos
2. **🔐 OAuth App** - Para autenticación de usuarios

---

## 🔑 Parte 1: GitHub Personal Access Token

### ¿Para qué sirve?
- Permite a Backstage acceder a tus repositorios
- Importa metadatos automáticamente 
- Sincroniza información de commits, issues, PRs
- Habilita la creación de repositorios desde templates

### 📝 Paso 1.1: Crear el Token

1. **Ve a GitHub Settings**
   ```
   🔗 https://github.com/settings/tokens
   ```

2. **Iniciar creación**
   - Click en **"Generate new token"**
   - Selecciona **"Generate new token (classic)"**

3. **Configurar básicos del token**
   - **Note**: `Backstage Lab Integration`
   - **Expiration**: `90 days` (recomendado para desarrollo)

### 📝 Paso 1.2: Seleccionar Permisos

**⚠️ IMPORTANTE**: Selecciona exactamente estos permisos:

#### ✅ **repo** (Full control of private repositories)
```
☑️ repo:status     - Access commit status
☑️ repo_deployment - Access deployment status  
☑️ public_repo     - Access public repositories
☑️ repo:invite     - Access repository invitations
☑️ security_events - Read and write security events
```

#### ✅ **read:org** (Read org and team membership, read org projects)
```
☑️ read:org - Read org and team membership
```

#### ✅ **read:user** (Read user profile data)
```
☑️ read:user - Read user profile data
```

#### ✅ **user:email** (Access user email addresses)
```
☑️ user:email - Access user email addresses (read-only)
```

#### ✅ **workflow** (Update GitHub Action workflows)
```
☑️ workflow - Update GitHub Action workflows
```

### 📝 Paso 1.3: Generar y Copiar

1. **Generar token**
   - Scroll hacia abajo y click **"Generate token"**

2. **Copiar inmediatamente**
   - ⚠️ **CRÍTICO**: Copia el token AHORA
   - Formato: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - No podrás verlo después

3. **Guardar de forma segura**
   - Pégalo en un lugar temporal seguro
   - Lo necesitarás en el paso 1.4

### 📝 Paso 1.4: Configurar en Backstage

1. **Abrir archivo de configuración**
   ```bash
   # Dentro del devcontainer
   cd backstage
   nano .env
   ```

2. **Actualizar la línea del token**
   ```env
   # Busca esta línea:
   GITHUB_TOKEN=your_github_personal_access_token_here
   
   # Reemplázala con:
   GITHUB_TOKEN=ghp_tu_token_real_aqui
   ```

3. **Verificar el formato**
   ```env
   GITHUB_TOKEN=ghp_YOUR_GITHUB_PERSONAL_ACCESS_TOKEN_HERE
   ```

---

## 🔐 Parte 2: GitHub OAuth App

### ¿Para qué sirve?
- Permite que los usuarios se autentiquen con GitHub
- Acceso a información del perfil del usuario
- Integración con permisos de GitHub
- Experiencia de login unificada

### 📝 Paso 2.1: Crear OAuth App

1. **Ve a GitHub OAuth Apps**
   ```
   🔗 https://github.com/settings/applications/new
   ```

2. **Completar el formulario**
   
   | Campo | Valor Exacto |
   |-------|--------------|
   | **Application name** | `Backstage Lab` |
   | **Homepage URL** | `http://localhost:3000` |
   | **Application description** | `Backstage development environment` |
   | **Authorization callback URL** | `http://localhost:7007/api/auth/github/handler/frame` |

   ⚠️ **CRÍTICO**: La callback URL debe ser **exactamente** como se muestra arriba.

3. **Crear la aplicación**
   - Click **"Register application"**

### 📝 Paso 2.2: Obtener Credenciales

1. **Copiar Client ID**
   - Se muestra inmediatamente después de crear la app
   - Formato: `Ov23li_xxxxxxxxxxxxxxxxx`

2. **Generar Client Secret**
   - Click **"Generate a new client secret"**
   - Confirma tu contraseña si se solicita
   - Copia el secret inmediatamente
   - Formato: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

### 📝 Paso 2.3: Configurar en Backstage

1. **Abrir archivo de configuración**
   ```bash
   # Dentro del devcontainer
   cd backstage
   nano .env
   ```

2. **Actualizar las líneas OAuth**
   ```env
   # Busca estas líneas:
   AUTH_GITHUB_CLIENT_ID=your_github_oauth_client_id_here
   AUTH_GITHUB_CLIENT_SECRET=your_github_oauth_client_secret_here
   
   # Reemplázalas con:
   AUTH_GITHUB_CLIENT_ID=Ov23lif91tKdQrBzGVJ2
   AUTH_GITHUB_CLIENT_SECRET=7cb976cfbc30b9a2df67c50b3b3444abf4fcc580
   ```

---

## ✅ Verificación de Configuración

### 📋 Checklist Final

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

# ✅ GitHub integration - Personal Access Token
GITHUB_TOKEN=ghp_YOUR_GITHUB_PERSONAL_ACCESS_TOKEN_HERE

# ✅ GitHub OAuth App
AUTH_GITHUB_CLIENT_ID=Ov23lif91tKdQrBzGVJ2
AUTH_GITHUB_CLIENT_SECRET=7cb976cfbc30b9a2df67c50b3b3444abf4fcc580
```

### 🧪 Tests de Verificación

#### Test 1: Verificar Token GitHub
```bash
# Probar el token
curl -H "Authorization: token ghp_tu_token_aqui" https://api.github.com/user

# Respuesta esperada: Tu información de perfil JSON
```

#### Test 2: Verificar OAuth App
```bash
# Iniciar Backstage
cd backstage
yarn start

# En el navegador ir a: http://localhost:3000
# Deberías ver dos botones:
# - "Guest Access" 
# - "Sign in with GitHub"
```

#### Test 3: Verificar Endpoints
```bash
# Backend health
curl http://localhost:7007/healthcheck

# Auth endpoints
curl http://localhost:7007/api/auth/guest/refresh
curl http://localhost:7007/api/auth/github/start
```

---

## 🚀 Uso de la Configuración

### 🔓 Modo Guest
- Click **"Guest Access"**
- Acceso inmediato sin autenticación
- Ideal para explorar funcionalidades
- Limitaciones: No acceso a repos privados

### 🐙 Modo GitHub
- Click **"Sign in with GitHub"**
- Redirige a GitHub OAuth
- Autoriza la aplicación Backstage
- Acceso completo a integraciones

### 📦 Importar Repositorios
1. Una vez autenticado, ve al **Catalog**
2. Click **"Create Component"**
3. Selecciona **"Register existing component"**
4. Introduce la URL de tu repositorio GitHub
5. Backstage importará automáticamente metadatos

### 🏗️ Crear desde Templates
1. Ve a **"Create"** en el menú principal
2. Selecciona un template (ej: "Hello World")
3. Completa los parámetros
4. Backstage creará un nuevo repositorio en GitHub

---

## 🔧 Troubleshooting

### ❌ Error: "Invalid GitHub token"

**Síntomas:**
- Backstage no puede acceder a repositorios
- Error 401 Unauthorized en logs

**Solución:**
```bash
# 1. Verificar token
curl -H "Authorization: token TU_TOKEN" https://api.github.com/user

# 2. Verificar permisos del token en GitHub
# Ve a: https://github.com/settings/tokens
# El token debe tener: repo, read:org, read:user, user:email

# 3. Regenerar token si es necesario
```

### ❌ Error: "OAuth callback mismatch"

**Síntomas:**
- Error al intentar login con GitHub
- "Application callback URL mismatch" 

**Solución:**
```bash
# 1. Verificar URL de callback en GitHub OAuth App
# Debe ser exactamente: http://localhost:7007/api/auth/github/handler/frame

# 2. Verificar configuración en app-config.yaml
grep -n "baseUrl" backstage/app-config.yaml
# Debe mostrar: baseUrl: http://localhost:7007
```

### ❌ Error: "Cannot connect to GitHub"

**Síntomas:**
- Timeouts al conectar con GitHub API
- Errores de red

**Solución:**
```bash
# 1. Verificar conectividad
curl https://api.github.com/

# 2. Verificar proxy/firewall corporativo
# 3. Verificar configuración DNS
```

### ❌ Error: "Rate limit exceeded"

**Síntomas:**
- Errores 403 con mensaje de rate limit
- Operaciones lentas con GitHub

**Solución:**
```bash
# 1. Verificar rate limit actual
curl -H "Authorization: token TU_TOKEN" https://api.github.com/rate_limit

# 2. Usar token con mayor rate limit
# Personal tokens tienen límite más alto que requests anónimos

# 3. Esperar que se resetee el límite (cada hora)
```

---

## 📊 Configuraciones Avanzadas

### 🏢 GitHub Enterprise

Si usas GitHub Enterprise, modifica la configuración:

```yaml
# app-config.yaml
integrations:
  github:
    - host: github.tu-empresa.com
      token: ${GITHUB_TOKEN}
      apiBaseUrl: https://github.tu-empresa.com/api/v3
```

### 🔐 Permisos Granulares

Para mayor seguridad, puedes usar un token con permisos más restrictivos:

```yaml
# Solo repositorios públicos
integrations:
  github:
    - host: github.com
      token: ${GITHUB_PUBLIC_TOKEN}  # Token solo con public_repo
```

### 🔄 Webhooks Automáticos

Para actualizaciones en tiempo real:

```yaml
# app-config.yaml
catalog:
  providers:
    github:
      providerId:
        organization: 'tu-org'
        catalogPath: '/catalog-info.yaml'
        filters:
          branch: 'main'
        schedule:
          frequency: PT30M  # Cada 30 minutos
          timeout: PT3M
```

---

## 📚 Recursos Adicionales

### 🔗 Enlaces Útiles
- [GitHub OAuth Apps Docs](https://docs.github.com/en/developers/apps/building-oauth-apps)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Backstage GitHub Integration](https://backstage.io/docs/integrations/github/locations)

### 🎯 Siguiente Nivel
- **GitHub Apps vs OAuth Apps**: Para mayor control
- **Fine-grained tokens**: Permisos por repositorio
- **Webhook configuration**: Actualizaciones instantáneas
- **Enterprise integration**: SSO y permisos avanzados

---

**🎉 ¡Configuración GitHub completada! Tu Backstage ahora tiene integración completa con GitHub.**