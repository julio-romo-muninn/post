#!/bin/bash
# ==============================================
# TPX BLOG - Setup para GitHub Pages (Linux/macOS)
# ==============================================
# Este script configura el entorno para ser
# compatible con GitHub Pages (Ruby 3.1.7)
# ==============================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║   TPX BLOG - Setup GitHub Pages        ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar directorio
if [ ! -f "_config.yml" ]; then
    echo -e "${RED}[ERROR]${NC} Ejecuta este script desde la raíz del blog."
    exit 1
fi

# Bundler version compatible con GitHub Actions
BUNDLER_VERSION="2.5.0"

echo -e "${YELLOW}[1/4]${NC} Instalando Bundler $BUNDLER_VERSION..."
gem install bundler -v "$BUNDLER_VERSION" --no-document

echo -e "${YELLOW}[2/4]${NC} Eliminando Gemfile.lock antiguo..."
rm -f Gemfile.lock

echo -e "${YELLOW}[3/4]${NC} Generando nuevo Gemfile.lock..."
bundle _${BUNDLER_VERSION}_ lock

echo -e "${YELLOW}[4/4]${NC} Agregando plataforma x86_64-linux para GitHub Actions..."
bundle _${BUNDLER_VERSION}_ lock --add-platform x86_64-linux

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         ¡Setup Completado!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Gemfile.lock regenerado con:"
echo "  - Bundler: $BUNDLER_VERSION"
echo "  - Plataformas: x86_64-linux (GitHub Actions)"
echo ""
echo "Gems pinneados para Ruby 3.1.7 compatibilidad:"
echo "  - connection_pool ~> 2.4"
echo "  - minitest ~> 5.0"
echo "  - activesupport ~> 7.0"
echo "  - nokogiri ~> 1.16.0"
echo "  - public_suffix ~> 5.0"
echo ""
echo -e "${YELLOW}Siguiente paso:${NC} git add Gemfile.lock && git commit -m 'Regenerate lockfile' && git push"
