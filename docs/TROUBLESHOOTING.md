# 🔧 Guía de Troubleshooting - Backstage Lab

Soluciones rápidas y detalladas para los problemas más comunes en Backstage Lab.

## 📋 Índice de Problemas

- [🚨 Problemas Críticos](#-problemas-críticos)
- [🔐 Errores de Autenticación](#-errores-de-autenticación)
- [🗄️ Problemas de Base de Datos](#️-problemas-de-base-de-datos)
- [🐙 Errores de GitHub Integration](#-errores-de-github-integration)
- [🐳 Problemas de DevContainer](#-problemas-de-devcontainer)
- [🌐 Errores de Frontend/Backend](#-errores-de-frontendbackend)
- [⚡ Problemas de Performance](#-problemas-de-performance)
- [🛠️ Herramientas de Debugging](#️-herramientas-de-debugging)

---

## 🚨 Problemas Críticos

### ❌ **Backstage no inicia - Error general**

**Síntomas:**
- `yarn start` falla inmediatamente
- Múltiples errores en consola
- Servicios no responden

**Diagnóstico rápido:**
```bash
# 1. Verificar servicios básicos
docker ps | grep -E "(postgres|backstage)"

# 2. Verificar puertos
netstat -tlnp | grep -E "(3000|7007|5432)"

# 3. Verificar variables de entorno
cd backstage && cat .env
```

**Solución paso a paso:**
```bash
# 1. Reiniciar todos los servicios
docker-compose -f .devcontainer/docker-compose.yml restart

# 2. Limpiar caché de Node.js
cd backstage
rm -rf node_modules
yarn install

# 3. Verificar configuración
./setup-backstage.sh

# 4. Intentar inicio limpio
yarn start
```

---

## 🔐 Errores de Autenticación

### ❌ **"Failed to sign in as a guest using the auth backend"**

**Síntomas:**
- Popup preguntando por legacy guest token
- No puede acceder como invitado
- Backend retorna errores 401/403

**Causa común:** Backend secret no configurado o incorrecto

**Solución inmediata:**
```bash
# 1. Verificar secret existe
cd backstage && grep BACKEND_SECRET .env

# 2. Si falta, generar nuevo secret
node -e "console.log(require('crypto').randomBytes(32).toString('base64'))"

# 3. Agregar al .env
echo "BACKEND_SECRET=tu_secret_generado_aqui" >> .env

# 4. Reiniciar backend
yarn start
```

**Solución detallada:**
```bash
# 1. Verificar configuración auth en app-config.yaml
grep -A 10 "auth:" backstage/app-config.yaml

# Debe incluir:
# auth:
#   environment: development
#   providers:
#     guest:
#       dangerouslyAllowOutsideDevelopment: true

# 2. Verificar backend auth está habilitado
grep -n "auth-backend" backstage/packages/backend/src/index.ts

# 3. Test de endpoint auth
curl http://localhost:7007/api/auth/guest/refresh
```

### ❌ **"GitHub OAuth login fails"**

**Síntomas:**
- Redirige a GitHub pero falla al volver
- Error "callback URL mismatch"
- "Invalid client credentials"

**Diagnóstico:**
```bash
# 1. Verificar configuración OAuth
cd backstage && grep -E "AUTH_GITHUB" .env

# 2. Test de OAuth App configuración
curl "http://localhost:7007/api/auth/github/start"
```

**Solución:**
```bash
# 1. Verificar callback URL en GitHub OAuth App
# Debe ser: http://localhost:7007/api/auth/github/handler/frame

# 2. Verificar credenciales en .env
# AUTH_GITHUB_CLIENT_ID debe empezar con "Ov23li"
# AUTH_GITHUB_CLIENT_SECRET debe ser 40 caracteres

# 3. Regenerar client secret si es necesario
# Ve a: https://github.com/settings/applications
```

---

## 🗄️ Problemas de Base de Datos

### ❌ **"Could not fetch catalog entities"**

**Síntomas:**
- Catalog aparece vacío
- Error al cargar entidades
- Timeouts de conexión a BD

**Diagnóstico rápido:**
```bash
# 1. Verificar PostgreSQL está corriendo
docker ps | grep postgres

# 2. Test de conectividad
docker exec backstage-lab-1_devcontainer-postgres-1 pg_isready -U backstage

# 3. Verificar datos existen
docker exec backstage-lab-1_devcontainer-postgres-1 psql -U backstage -d backstage_plugin_catalog -c "SELECT COUNT(*) FROM final_entities;"
```

**Solución por pasos:**
```bash
# 1. Restart PostgreSQL
docker restart backstage-lab-1_devcontainer-postgres-1

# 2. Verificar configuración de conexión
cd backstage && grep -E "POSTGRES" .env

# 3. Test de conexión manual
docker exec -it backstage-lab-1_devcontainer-postgres-1 psql -U backstage -d backstage_plugin_catalog

# 4. Si BD está vacía, repoblar
./setup-backstage.sh

# 5. Restart Backstage
cd backstage && yarn start
```

### ❌ **"Database connection refused"**

**Síntomas:**
- Error "connection refused" en logs
- Backend no puede conectar a PostgreSQL
- Servicios no inician

**Solución:**
```bash
# 1. Verificar network Docker
docker network ls | grep backstage

# 2. Verificar containers en misma red
docker inspect backstage-lab-1_devcontainer-postgres-1 | grep NetworkMode

# 3. Recrear containers si es necesario
docker-compose -f .devcontainer/docker-compose.yml down
docker-compose -f .devcontainer/docker-compose.yml up -d

# 4. Verificar variables de entorno
cd backstage && cat .env | grep POSTGRES
```

---

## 🐙 Errores de GitHub Integration

### ❌ **"GitHub token invalid or expired"**

**Síntomas:**
- Error 401 al acceder repos GitHub
- "Bad credentials" en logs
- No puede importar repositorios

**Diagnóstico:**
```bash
# 1. Test token directamente
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# 2. Verificar permisos del token
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos
```

**Solución:**
```bash
# 1. Verificar token en .env
cd backstage && grep GITHUB_TOKEN .env

# 2. Verificar formato correcto (debe empezar con "ghp_")
# 3. Regenerar token en GitHub si es necesario:
#    - Ve a: https://github.com/settings/tokens
#    - Regenerar con permisos: repo, read:org, read:user, user:email

# 4. Actualizar .env con nuevo token
# 5. Reiniciar Backstage
yarn start
```

### ❌ **"GitHub rate limit exceeded"**

**Síntomas:**
- Error 403 con mensaje de rate limit
- Operaciones GitHub muy lentas
- Fallos intermitentes

**Solución:**
```bash
# 1. Verificar rate limit actual
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit

# 2. Esperar reset (se resetea cada hora)
# 3. Optimizar requests en app-config.yaml:

# catalog:
#   providers:
#     github:
#       schedule:
#         frequency: PT1H  # Reducir frecuencia a 1 hora
```

### ❌ **"Cannot import GitHub repository"**

**Síntomas:**
- Error al intentar importar repos
- "Repository not found" pero existe
- Permisos insuficientes

**Solución:**
```bash
# 1. Verificar repo es público o token tiene acceso
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/OWNER/REPO

# 2. Verificar formato de URL al importar
# Correcto: https://github.com/owner/repo/blob/main/catalog-info.yaml
# o: https://github.com/owner/repo

# 3. Para repos privados, verificar permisos del token incluyen "repo"
```

---

## 🐳 Problemas de DevContainer

### ❌ **"DevContainer build failed"**

**Síntomas:**
- VS Code no puede construir el container
- Errores durante docker build
- Container no inicia

**Diagnóstico:**
```bash
# 1. Verificar Docker Desktop está corriendo
docker version

# 2. Verificar espacio en disco
df -h

# 3. Verificar memoria Docker
docker system df
```

**Solución:**
```bash
# 1. Limpiar Docker cache
docker system prune -a
docker volume prune

# 2. Rebuild desde VS Code
# Ctrl+Shift+P → "Dev Containers: Rebuild Container"

# 3. Si falla, build manual
cd .devcontainer
docker-compose build --no-cache

# 4. Verificar logs de build
docker-compose logs backstage-dev
```

### ❌ **"DevContainer startup slow"**

**Síntomas:**
- Container tarda mucho en iniciar
- VS Code timeout al conectar
- Servicios lentos

**Optimización:**
```bash
# 1. Asignar más recursos a Docker
# Docker Desktop → Settings → Resources
# RAM: Mínimo 4GB, recomendado 8GB
# CPU: Mínimo 2 cores, recomendado 4

# 2. Optimizar imagen base
# En Dockerfile, agregar:
# ENV NODE_OPTIONS="--max-old-space-size=4096"

# 3. Usar cache de yarn
# RUN yarn config set cache-folder /tmp/yarn-cache
```

---

## 🌐 Errores de Frontend/Backend

### ❌ **"Frontend can't connect to backend"**

**Síntomas:**
- Frontend carga pero sin datos
- Error de CORS en browser console
- API calls fallan

**Diagnóstico:**
```bash
# 1. Verificar backend está corriendo
curl http://localhost:7007/healthcheck

# 2. Verificar frontend puede alcanzar backend
curl -I http://localhost:3000

# 3. Verificar configuración CORS
grep -A 5 "cors:" backstage/app-config.yaml
```

**Solución:**
```bash
# 1. Verificar configuración en app-config.yaml
# backend:
#   baseUrl: http://localhost:7007
#   cors:
#     origin: http://localhost:3000

# 2. Restart ambos servicios
cd backstage
yarn start

# 3. Si persiste, verificar proxy/firewall local
```

### ❌ **"Build errors during startup"**

**Síntomas:**
- TypeScript errors durante build
- Dependency conflicts
- Build process fails

**Solución:**
```bash
# 1. Limpiar dependencies
cd backstage
rm -rf node_modules yarn.lock
yarn install

# 2. Verificar versiones Node.js
node --version  # Debe ser 18.x
yarn --version  # Debe ser 4.x

# 3. Build incremental
yarn build:backend
yarn build:frontend

# 4. Si hay errores TypeScript, verificar configuración
cat tsconfig.json
```

---

## ⚡ Problemas de Performance

### ❌ **"Backstage runs slowly"**

**Síntomas:**
- Navegación lenta
- APIs responden lento
- High CPU/memory usage

**Optimización:**
```bash
# 1. Verificar recursos disponibles
htop
docker stats

# 2. Optimizar configuración Node.js
export NODE_OPTIONS="--max-old-space-size=4096"

# 3. Optimizar base de datos
docker exec backstage-lab-1_devcontainer-postgres-1 psql -U backstage -c "VACUUM ANALYZE;"

# 4. Reducir frecuencia de sincronización
# En app-config.yaml:
# catalog:
#   providers:
#     schedule:
#       frequency: PT1H  # 1 hora en lugar de 30 min
```

### ❌ **"High memory usage"**

**Síntomas:**
- Sistema lento general
- Docker usa mucha RAM
- OOM errors

**Solución:**
```bash
# 1. Monitorear uso por servicio
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# 2. Limitar memoria de containers
# En docker-compose.yml:
# services:
#   backstage-dev:
#     mem_limit: 2g

# 3. Optimizar PostgreSQL
docker exec backstage-lab-1_devcontainer-postgres-1 psql -U backstage -c "
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
SELECT pg_reload_conf();
"
```

---

## 🛠️ Herramientas de Debugging

### 🔍 **Scripts de Diagnóstico**

#### Script: Verificación General
```bash
#!/bin/bash
echo "🔍 Backstage Lab - Diagnóstico General"
echo "======================================"

# Verificar Docker
echo "🐳 Docker Status:"
docker --version
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Verificar servicios
echo -e "\n🌐 Servicios:"
curl -s -o /dev/null -w "Frontend (3000): %{http_code}\n" http://localhost:3000
curl -s -o /dev/null -w "Backend (7007): %{http_code}\n" http://localhost:7007/healthcheck

# Verificar BD
echo -e "\n🗄️ Base de Datos:"
docker exec backstage-lab-1_devcontainer-postgres-1 pg_isready -U backstage

# Verificar configuración
echo -e "\n⚙️ Configuración:"
cd backstage
echo "Variables importantes:"
grep -E "(GITHUB_TOKEN|BACKEND_SECRET|POSTGRES)" .env | sed 's/=.*/=***/'

echo -e "\n✅ Diagnóstico completado"
```

#### Script: Test de Conectividad
```bash
#!/bin/bash
echo "🔗 Test de Conectividad"
echo "====================="

# Test puertos locales
for port in 3000 7007 5432; do
    if nc -z localhost $port; then
        echo "✅ Puerto $port: ABIERTO"
    else
        echo "❌ Puerto $port: CERRADO"
    fi
done

# Test APIs
echo -e "\n📡 APIs:"
curl -s http://localhost:7007/healthcheck && echo " ✅ Backend Health" || echo " ❌ Backend Health"
curl -s http://localhost:7007/api/catalog/entities | jq length && echo " ✅ Catalog API" || echo " ❌ Catalog API"

# Test GitHub
if [ ! -z "$GITHUB_TOKEN" ]; then
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null && echo " ✅ GitHub Token" || echo " ❌ GitHub Token"
fi
```

### 📊 **Logs Útiles**

#### Backend Logs
```bash
# Logs en tiempo real
cd backstage
yarn start:backend | tee backend.log

# Grep errores específicos
grep -i error backend.log
grep -i "auth\|github\|database" backend.log
```

#### Database Logs
```bash
# PostgreSQL logs
docker logs backstage-lab-1_devcontainer-postgres-1 --tail 100 -f

# Query logs (si están habilitados)
docker exec backstage-lab-1_devcontainer-postgres-1 psql -U backstage -c "
SELECT query, state, query_start 
FROM pg_stat_activity 
WHERE state != 'idle' 
ORDER BY query_start DESC;
"
```

#### Network Debugging
```bash
# Verificar conectividad entre containers
docker exec backstage-lab-1_devcontainer-backstage-dev-1 ping postgres

# Verificar resolución DNS
docker exec backstage-lab-1_devcontainer-backstage-dev-1 nslookup postgres

# Verificar puertos dentro del container
docker exec backstage-lab-1_devcontainer-backstage-dev-1 netstat -tulnp
```

### 🧪 **Tests de Validación**

#### Test Completo del Sistema
```bash
#!/bin/bash
echo "🧪 Test Completo del Sistema"
echo "============================"

TESTS_PASSED=0
TESTS_TOTAL=0

test_service() {
    local name=$1
    local url=$2
    local expected=$3
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$response" = "$expected" ]; then
        echo "✅ $name: PASS ($response)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "❌ $name: FAIL (got $response, expected $expected)"
    fi
}

# Tests de servicios
test_service "Frontend" "http://localhost:3000" "200"
test_service "Backend Health" "http://localhost:7007/healthcheck" "200"
test_service "Catalog API" "http://localhost:7007/api/catalog/entities" "200"
test_service "Auth Guest" "http://localhost:7007/api/auth/guest/refresh" "200"

# Test de base de datos
TESTS_TOTAL=$((TESTS_TOTAL + 1))
if docker exec backstage-lab-1_devcontainer-postgres-1 pg_isready -U backstage > /dev/null; then
    echo "✅ PostgreSQL: PASS"
    TESTS_PASSED=$((TESTS_PASSED + 1))
else
    echo "❌ PostgreSQL: FAIL"
fi

echo -e "\n📊 Resultados: $TESTS_PASSED/$TESTS_TOTAL tests passed"

if [ $TESTS_PASSED -eq $TESTS_TOTAL ]; then
    echo "🎉 Todos los tests pasaron - Sistema operativo"
    exit 0
else
    echo "⚠️ Algunos tests fallaron - Revisar configuración"
    exit 1
fi
```

---

## 📞 **Soporte Adicional**

### 🆘 Cuándo Escalate
Si después de seguir esta guía aún tienes problemas:

1. **Documenta el problema:**
   - Pasos exactos para reproducir
   - Logs completos de error
   - Configuración actual (sin secretos)
   - Versiones de software

2. **Crea un Issue en GitHub:**
   - Usa template de bug report
   - Incluye toda la información anterior
   - Etiqueta apropiadamente

3. **Información del sistema útil:**
   ```bash
   # Recopila información del sistema
   echo "OS: $(uname -a)"
   echo "Docker: $(docker --version)"
   echo "Node: $(node --version)"
   echo "Yarn: $(yarn --version)"
   echo "VS Code: $(code --version | head -1)"
   ```

### 🔄 Escalación por Severidad

| Severidad | Tiempo Respuesta | Descripción |
|-----------|------------------|-------------|
| 🔴 Critical | 4 horas | Sistema completamente no funcional |
| 🟡 High | 24 horas | Funcionalidad principal afectada |
| 🟢 Medium | 2-3 días | Funcionalidad secundaria afectada |
| ⚪ Low | Mejor esfuerzo | Mejoras, documentación |

---

**🎯 Recuerda: La mayoría de problemas se resuelven con reiniciar servicios y verificar configuración básica.**