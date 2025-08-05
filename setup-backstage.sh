#!/bin/bash

# Script de configuración para Backstage Lab
echo "🚀 Configurando Backstage Lab..."

# Buscar el directorio de la aplicación Backstage
BACKSTAGE_DIR=""
for dir in backstage backstage-lab backstage-*; do
    if [ -d "$dir" ] && [ -f "$dir/package.json" ]; then
        BACKSTAGE_DIR="$dir"
        break
    fi
done

if [ -z "$BACKSTAGE_DIR" ]; then
    echo "❌ No se encontró el directorio de la aplicación Backstage"
    echo "Por favor ejecuta primero: npx @backstage/create-app@latest"
    echo "Directorios disponibles:"
    ls -la
    exit 1
fi

echo "📁 Encontrado directorio de Backstage: $BACKSTAGE_DIR"
cd "$BACKSTAGE_DIR"

echo "📦 Instalando dependencias de base de datos..."
# Instalar el cliente de PostgreSQL
yarn --cwd packages/backend add pg
yarn --cwd packages/backend add @types/pg --dev

echo "📝 Copiando configuración de base de datos..."
# Copiar la configuración local
cp ../app-config.local.yaml ./app-config.local.yaml

echo "🗄️ Verificando conexión a PostgreSQL..."
# Instalar netcat si no está disponible
if ! command -v nc &> /dev/null; then
    echo "📦 Instalando netcat..."
    apt-get update -qq && apt-get install -y -qq netcat-openbsd
fi

# Verificar que PostgreSQL está disponible
if ! nc -z postgres 5432; then
    echo "❌ PostgreSQL no está disponible en postgres:5432"
    echo "Verifica que el container de PostgreSQL esté corriendo"
    echo "Intentando con timeout más largo..."
    sleep 5
    if ! nc -z postgres 5432; then
        echo "❌ PostgreSQL sigue sin responder"
        echo "Puedes continuar manualmente - la configuración se aplicará"
    else
        echo "✅ PostgreSQL está corriendo (después de espera)"
    fi
else
    echo "✅ PostgreSQL está corriendo"
fi

# Crear directorio de ejemplos si no existe
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

echo "✅ Configuración completada!"
echo ""
echo "🎯 Próximos pasos:"
echo "1. cd $BACKSTAGE_DIR"
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