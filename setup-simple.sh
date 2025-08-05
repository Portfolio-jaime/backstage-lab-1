#!/bin/bash

# Script de configuración simplificado para Backstage Lab
echo "🚀 Configuración simplificada de Backstage Lab..."

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
    exit 1
fi

echo "📁 Encontrado directorio de Backstage: $BACKSTAGE_DIR"
cd "$BACKSTAGE_DIR"

echo "📝 Copiando configuración de base de datos..."
cp ../app-config.local.yaml ./app-config.local.yaml

echo "📦 Instalando dependencias básicas..."
npm install pg @types/pg

echo "🔧 Configurando variables de entorno..."
cat > .env << 'EOF'
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=backstage
POSTGRES_PASSWORD=backstage
POSTGRES_DB=backstage_plugin_catalog
BACKEND_URL=http://localhost:7007
FRONTEND_URL=http://localhost:3000
EOF

echo "👥 Creando directorio de ejemplos..."
mkdir -p examples

echo "✅ Configuración básica completada!"
echo ""
echo "🎯 Para iniciar:"
echo "1. cd $BACKSTAGE_DIR"
echo "2. yarn install"
echo "3. yarn start"
echo ""
echo "📚 URLs:"
echo "- Frontend: http://localhost:3000"
echo "- Backend: http://localhost:7007"