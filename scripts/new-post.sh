#!/bin/bash
# ==============================================
# TPX BLOG - Crear Nuevo Post (Linux/macOS)
# ==============================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Directorio de posts
POSTS_DIR="_posts"

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║       TPX BLOG - Nuevo Post            ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar directorio
if [ ! -d "$POSTS_DIR" ]; then
    echo "Error: No se encontró el directorio _posts"
    exit 1
fi

# Solicitar información
echo -e "${YELLOW}Título del post:${NC}"
read -p "> " TITLE

echo -e "${YELLOW}Categoría (ej: Tutorial, Seguridad, DevOps):${NC}"
read -p "> " CATEGORY

echo -e "${YELLOW}Tags separados por coma (ej: docker, devops, linux):${NC}"
read -p "> " TAGS

echo -e "${YELLOW}Descripción breve:${NC}"
read -p "> " DESCRIPTION

echo -e "${YELLOW}Autor (key del authors.yml, ej: tpx-team):${NC}"
read -p "> " AUTHOR

# Generar slug del título
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

# Fecha actual
DATE=$(date +%Y-%m-%d)
DATETIME=$(date +"%Y-%m-%d %H:%M:%S %z")

# Nombre del archivo
FILENAME="${POSTS_DIR}/${DATE}-${SLUG}.md"

# Formatear tags
TAGS_FORMATTED=$(echo "$TAGS" | sed 's/,/\n  - /g' | sed 's/^/  - /')

# Crear el archivo
cat > "$FILENAME" << EOF
---
title: "${TITLE}"
date: ${DATETIME}
categories: [${CATEGORY}]
tags:
${TAGS_FORMATTED}
description: "${DESCRIPTION}"
author: ${AUTHOR}
image: /assets/img/posts/${SLUG}.svg
toc: true
---

## Introducción

Escribe aquí la introducción de tu post...

## Contenido Principal

### Subtítulo 1

Tu contenido aquí...

\`\`\`bash
# Ejemplo de código
echo "Hola TPX Blog"
\`\`\`

### Subtítulo 2

Más contenido...

## Conclusión

Resumen y conclusiones del post...

## Referencias

- [Enlace 1](https://ejemplo.com)
- [Enlace 2](https://ejemplo.com)
EOF

echo ""
echo -e "${GREEN}✓ Post creado exitosamente!${NC}"
echo -e "Archivo: ${BLUE}${FILENAME}${NC}"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "1. Edita el archivo con tu contenido"
echo "2. Crea una imagen en: assets/img/posts/${SLUG}.svg"
echo "3. Ejecuta ./scripts/publish.sh para publicar"
echo ""
