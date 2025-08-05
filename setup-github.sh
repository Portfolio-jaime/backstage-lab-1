#!/bin/bash

echo "🚀 Configurando integración completa con GitHub..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Para configurar GitHub necesitas:${NC}"
echo ""
echo -e "${YELLOW}1. Personal Access Token (para integración de catálogo):${NC}"
echo "   - Ve a: https://github.com/settings/tokens"
echo "   - Crea un nuevo token con estos permisos:"
echo "     • repo (acceso completo a repositorios privados)"
echo "     • read:org (leer información de la organización)"
echo "     • read:user (leer información del usuario)"
echo ""
echo -e "${YELLOW}2. GitHub OAuth App (para autenticación):${NC}"
echo "   - Ve a: https://github.com/settings/applications/new"
echo "   - Configura:"
echo "     • Application name: Backstage Lab"
echo "     • Homepage URL: http://localhost:3000"
echo "     • Authorization callback URL: http://localhost:7007/api/auth/github/handler/frame"
echo ""

read -p "¿Tienes el Personal Access Token? (y/n): " has_token
if [ "$has_token" = "y" ]; then
    read -p "Introduce tu GitHub Personal Access Token: " github_token
    sed -i "s/GITHUB_TOKEN=.*/GITHUB_TOKEN=$github_token/" /workspace/backstage/.env
    echo -e "${GREEN}✅ Token configurado${NC}"
else
    echo -e "${RED}❌ Necesitas crear el token primero${NC}"
fi

read -p "¿Tienes la OAuth App configurada? (y/n): " has_oauth
if [ "$has_oauth" = "y" ]; then
    read -p "Introduce tu GitHub OAuth Client ID: " client_id
    read -p "Introduce tu GitHub OAuth Client Secret: " client_secret
    sed -i "s/AUTH_GITHUB_CLIENT_ID=.*/AUTH_GITHUB_CLIENT_ID=$client_id/" /workspace/backstage/.env
    sed -i "s/AUTH_GITHUB_CLIENT_SECRET=.*/AUTH_GITHUB_CLIENT_SECRET=$client_secret/" /workspace/backstage/.env
    echo -e "${GREEN}✅ OAuth App configurada${NC}"
else
    echo -e "${RED}❌ Necesitas crear la OAuth App primero${NC}"
fi

echo ""
echo -e "${GREEN}🎯 Configuración completada!${NC}"
echo ""
echo -e "${BLUE}📝 Próximos pasos:${NC}"
echo "1. cd backstage"
echo "2. yarn start"
echo ""
echo -e "${BLUE}🔐 Opciones de autenticación disponibles:${NC}"
echo "- Guest (modo invitado)"
echo "- GitHub OAuth (si configuraste la OAuth App)"
echo ""
echo -e "${BLUE}📚 Funcionalidades disponibles:${NC}"
echo "- Catálogo de servicios"
echo "- Integración con repositorios GitHub"
echo "- Documentación técnica"
echo "- Templates de scaffolding"
echo ""