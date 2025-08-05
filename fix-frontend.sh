#!/bin/bash

echo "🔧 Configurando frontend para devcontainer..."

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
    exit 1
fi

cd "$BACKSTAGE_DIR"

# Crear archivo de configuración personalizada para webpack
mkdir -p packages/app/config

cat > packages/app/config/webpack.config.js << 'EOF'
module.exports = (config, { env }) => {
  if (env === 'development') {
    // Configurar webpack dev server para escuchar en todas las interfaces
    config.devServer = {
      ...config.devServer,
      host: '0.0.0.0',
      port: 3000,
      allowedHosts: 'all',
      client: {
        webSocketURL: 'auto://0.0.0.0:0/ws'
      }
    };
  }
  return config;
};
EOF

echo "✅ Configuración de frontend actualizada"
echo "🚀 Reinicia yarn start para aplicar los cambios"