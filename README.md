# tpx Post

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Deployed-00ff9d?style=flat-square&logo=github)](https://yourusername.github.io/blog)
[![Jekyll](https://img.shields.io/badge/Jekyll-4.3-CC0000?style=flat-square&logo=jekyll)](https://jekyllrb.com/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

> 🖥️ Post técnico con diseño hacker sobre desarrollo, ciberseguridad y tecnología.

![tpx Post Preview](assets/img/preview.png)

## ✨ Características

- 🎨 **Diseño Hacker** - Tema oscuro con colores neón y efectos de terminal
- 📱 **Responsive** - Optimizado para todos los dispositivos
- 🔍 **SEO Optimizado** - Meta tags, Open Graph, Twitter Cards, JSON-LD
- 📝 **Posts en Markdown** - Fácil escritura y formato
- 📂 **Categorías y Tags** - Organización del contenido
- 📑 **Tabla de Contenidos** - Navegación automática en posts
- 💬 **Compartir Social** - Botones de compartir integrados
- 📡 **RSS Feed** - Suscripción al contenido
- ⚡ **Rápido** - Sitio estático optimizado
- 🎯 **Syntax Highlighting** - Resaltado de código con tema personalizado

## 🚀 Inicio Rápido

### Requisitos

- Ruby >= 2.7
- Bundler
- Git

### Instalación Local

```bash
# Clonar el repositorio
git clone https://github.com/yourusername/blog.git
cd blog

# Instalar dependencias
bundle install

# Ejecutar servidor local
bundle exec jekyll serve --livereload

# Abrir en el navegador
open http://localhost:4000
```

### Con Docker

```bash
# Construir y ejecutar
docker-compose up

# O usando Docker directamente
docker run --rm -v "$PWD:/srv/jekyll" -p 4000:4000 jekyll/jekyll:4.3 jekyll serve
```

## 📁 Estructura del Proyecto

```
blog/
├── _config.yml          # Configuración principal
├── _data/               # Datos en YAML/JSON
├── _includes/           # Componentes reutilizables
│   ├── head.html        # Meta tags y SEO
│   ├── header.html      # Navegación
│   ├── footer.html      # Pie de página
│   └── scripts.html     # JavaScript
├── _layouts/            # Plantillas de página
│   ├── default.html     # Layout base
│   ├── home.html        # Página principal
│   ├── post.html        # Posts individuales
│   └── archive.html     # Archivo de posts
├── _posts/              # Posts en Markdown
├── _sass/               # Estilos SCSS
│   ├── _variables.scss  # Variables de diseño
│   ├── _base.scss       # Estilos base
│   ├── _components.scss # Componentes UI
│   └── _syntax.scss     # Syntax highlighting
├── assets/
│   ├── css/             # CSS compilado
│   ├── js/              # JavaScript
│   └── img/             # Imágenes
└── pages/               # Páginas estáticas
```

## ✍️ Crear Nuevo Post

1. Crea un archivo en `_posts/` con formato: `YYYY-MM-DD-titulo-del-post.md`

2. Agrega el front matter:

```yaml
---
title: "Título del Post"
date: 2024-01-15 10:00:00 -0500
categories: [Categoría, Subcategoría]
tags: [tag1, tag2, tag3]
description: "Descripción para SEO"
author: Tu Nombre
toc: true
---

Tu contenido en Markdown aquí...
```

3. Escribe tu contenido usando Markdown

### Elementos Especiales

```markdown
<!-- Bloques de información -->
<div class="info">Información útil</div>
<div class="tip">Un tip para el lector</div>
<div class="warning">Advertencia importante</div>
<div class="danger">Peligro o error común</div>

<!-- Código con resaltado -->
```python
def hello():
    print("Hello, World!")
```
```

## ⚙️ Configuración

Edita `_config.yml` para personalizar:

```yaml
# Información del sitio
title: "Tu Blog"
description: "Descripción de tu blog"
url: "https://tuusuario.github.io"
baseurl: "/blog"

# Autor
author:
  name: "Tu Nombre"
  email: "tu@email.com"
  social:
    github: "tuusuario"
    twitter: "tuusuario"

# SEO
twitter:
  username: tuusuario
  card: summary_large_image
```

## 🌐 Despliegue en GitHub Pages

1. Crea un repositorio en GitHub

2. Sube tu código:
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/tuusuario/blog.git
git push -u origin main
```

3. Ve a Settings > Pages

4. Selecciona la rama `main` y guarda

5. Tu sitio estará en: `https://tuusuario.github.io/blog`

### GitHub Actions (CI/CD)

Crea `.github/workflows/jekyll.yml`:

```yaml
name: Deploy Jekyll

on:
  push:
    branches: ["main"]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/configure-pages@v3
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.1'
          bundler-cache: true
      - run: bundle exec jekyll build
      - uses: actions/upload-pages-artifact@v1

  deploy:
    runs-on: ubuntu-latest
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v2
```

## 🎨 Personalización

### Colores

Edita `_sass/_variables.scss`:

```scss
// Colores principales
$color-primary: #00ff9d;      // Verde neón
$color-secondary: #00d4ff;    // Cyan
$color-accent: #ff00ff;       // Magenta

// Fondos
$color-bg-primary: #0a0a0a;   // Negro principal
$color-bg-secondary: #0d1117; // Gris oscuro
```

### Fuentes

Las fuentes usadas son:
- **JetBrains Mono** - Código y elementos técnicos
- **Space Grotesk** - Texto general

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

1. Fork el proyecto
2. Crea tu rama (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'feat: agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 📬 Contacto

- **Website**: [tpx.security](https://tpx.security)
- **Email**: hola@tpx.security
- **Twitter**: [@tpx](https://twitter.com/tpx)
- **GitHub**: [tpx](https://github.com/tpx)

---

<p align="center">
  Hecho con 💚 por <a href="https://github.com/tpx">tpx Team</a>
</p>
