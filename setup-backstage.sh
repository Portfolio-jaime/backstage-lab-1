#!/bin/bash

# Script de configuración para Backstage Lab
echo "🚀 Configurando Backstage Lab..."

# Define el nombre del directorio de la aplicación Backstage
BACKSTAGE_APP_NAME="backstage"

# 1. Crear la aplicación Backstage si no existe
if [ ! -d "$BACKSTAGE_APP_NAME" ]; then
    echo "✨ Creando nueva aplicación Backstage con npx @backstage/create-app@latest..."
    npx @backstage/create-app@latest --skip-install "$BACKSTAGE_APP_NAME" # --skip-install to install dependencies later
    if [ $? -ne 0 ]; then
        echo "❌ Falló la creación de la aplicación Backstage."
        exit 1
    fi
else
    echo "✅ Directorio de Backstage '$BACKSTAGE_APP_NAME' ya existe. Saltando la creación."
fi

echo "📁 Entrando al directorio de Backstage: $BACKSTAGE_APP_NAME"
cd "$BACKSTAGE_APP_NAME" || { echo "❌ No se pudo cambiar al directorio $BACKSTAGE_APP_NAME"; exit 1; }

# 2. Instalar dependencias de base de datos (pg)
echo "📦 Instalando dependencias de base de datos..."
yarn --cwd packages/backend add pg
yarn --cwd packages/backend add @types/pg --dev

# 3. Generar o copiar app-config.local.yaml
echo "📝 Verificando y copiando/generando app-config.local.yaml..."
APP_CONFIG_LOCAL_PATH="../app-config.local.yaml"
if [ -f "$APP_CONFIG_LOCAL_PATH" ]; then
    cp "$APP_CONFIG_LOCAL_PATH" ./app-config.local.yaml
    echo "✅ app-config.local.yaml copiado desde el directorio raíz."
else
    echo "⚠️ app-config.local.yaml no encontrado en el directorio raíz. Generando uno por defecto."
    cat > app-config.local.yaml << 'EOF'
app:
  baseUrl: http://localhost:3000

backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  database:
    client: pg
    connection:
      host: ${POSTGRES_HOST}
      port: ${POSTGRES_PORT}
      user: ${POSTGRES_USER}
      password: ${POSTGRES_PASSWORD}
      database: ${POSTGRES_DB}
  # ... other backend configurations
EOF
    echo "✅ app-config.local.yaml generado con configuración de PostgreSQL por defecto."
fi

# 4. Verificar conexión a PostgreSQL (dentro del devcontainer, 'postgres' es el hostname)
echo "🗄️ Verificando conexión a PostgreSQL..."
if command -v pg_isready &> /dev/null; then
    if ! pg_isready -h postgres -p 5432 -U backstage -d backstage_plugin_catalog -t 5; then
        echo "❌ PostgreSQL no está disponible en postgres:5432"
        echo "Verifica que el container de PostgreSQL esté corriendo y sea accesible."
        echo "Intentando con timeout más largo (espera de 10 segundos)..."
        sleep 10
        if ! pg_isready -h postgres -p 5432 -U backstage -d backstage_plugin_catalog -t 5; then
            echo "❌ PostgreSQL sigue sin responder después de la espera."
            echo "Puedes continuar manualmente - la configuración se aplicará, pero el backend podría fallar al iniciar."
        else
            echo "✅ PostgreSQL está corriendo (después de espera)"
        fi
    else
        echo "✅ PostgreSQL está corriendo"
    fi
else
    echo "⚠️ pg_isready no encontrado. No se puede verificar la conexión a PostgreSQL automáticamente."
    echo "Asegúrate de que PostgreSQL esté corriendo y sea accesible en 'postgres:5432'."
fi


# 5. Crear directorio de ejemplos si no existe
mkdir -p examples

echo "👥 Creando entidades de ejemplo..."
# Crear archivo de entidades de ejemplo
cat > examples/entities.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: guest
  description: Usuario de ejemplo para el laboratorio
spec:
  profile:
    displayName: Usuario Invitado
    email: guest@example.com
    picture: https://via.placeholder.com/150
  memberOf: [guests]
---
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: guests
  description: Grupo de usuarios invitados
spec:
  type: team
  profile:
    displayName: Invitados
  children: []
EOF

echo "🏗️ Creando template de ejemplo..."
# Crear directorio para template
mkdir -p examples/template

cat > examples/template/template.yaml << 'EOF'
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: hello-world-template
  title: Hello World
  description: Plantilla de ejemplo para el laboratorio
  tags:
    - recommended
    - react
spec:
  owner: backstage/techdocs-core
  type: service
  parameters:
    - title: Configuración básica
      required:
        - name
      properties:
        name:
          title: Nombre
          type: string
          description: Nombre único para el componente
        description:
          title: Descripción
          type: string
          description: Descripción del componente
  steps:
    - id: log
      name: Log message
      action: debug:log
      input:
        message: 'Hello, ${{ parameters.name }}!'
  output:
    text:
      - title: Mensaje
        content: |
          ## Hola ${{ parameters.name }}

          Tu componente ha sido creado exitosamente!
EOF

echo "🏢 Creando estructura organizacional..."
cat > examples/org.yaml << 'EOF'
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: admin
spec:
  profile:
    displayName: Administrador
    email: admin@lab.local
  memberOf: [admins]
---
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: admins
spec:
  type: team
  profile:
    displayName: Administradores
  children: []
EOF

echo "🔧 Configurando variables de entorno..."
# Crear archivo de variables de entorno
# These are already set by docker-compose.yml for the devcontainer, but good for local dev.
cat > .env << 'EOF'
# Configuración de base de datos
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage
POSTGRES_DB=backstage_plugin_catalog

# URLs de la aplicación
BACKEND_URL=http://localhost:7007
FRONTEND_URL=http://localhost:3000
EOF

# 6. Instalar todas las dependencias de la aplicación Backstage
echo "⚙️ Instalando todas las dependencias de la aplicación Backstage..."
yarn install

# 7. Construir la aplicación Backstage
echo "🏗️ Construyendo la aplicación Backstage..."
yarn build:all

echo "✅ Configuración completada!"
echo ""
echo "🎯 Próximos pasos:"
echo "1. cd $BACKSTAGE_APP_NAME"
echo "2. yarn start"
echo ""
echo "🌐 URLs disponibles:"
echo "- Frontend: http://localhost:3000"
echo "- Backend API: http://localhost:7007"
echo "- PostgreSQL: localhost:5432"
echo ""
echo "📚 Credenciales de PostgreSQL:"
echo "- Usuario: backstage"
echo "- Contraseña: backstage"
echo "- Base de datos: backstage_plugin_catalog"
