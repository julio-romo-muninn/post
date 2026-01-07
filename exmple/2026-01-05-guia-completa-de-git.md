---
title: "Guía Completa de Git para Desarrolladores"
date: 2026-01-05 14:30:00 -0500
categories: [Tutorial, DevOps]
tags: [git, versionamiento, desarrollo, tutorial]
description: "Aprende a usar Git como un profesional. Desde los comandos básicos hasta workflows avanzados con branching y merge strategies."
author: tpx Team
image: /assets/img/posts/git.svg
toc: true
---

## Introducción a Git

Git es el sistema de control de versiones más utilizado en el mundo. En este tutorial aprenderás desde los conceptos básicos hasta técnicas avanzadas.

## Configuración Inicial

Antes de comenzar, configura tu identidad:

```bash
# Configurar nombre y email
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Configurar editor por defecto
git config --global core.editor "code --wait"

# Ver configuración actual
git config --list
```

## Comandos Básicos

### Inicializar un Repositorio

```bash
# Crear nuevo repositorio
git init mi-proyecto
cd mi-proyecto

# O clonar uno existente
git clone https://github.com/user/repo.git
```

### El Flujo de Trabajo

El flujo básico de Git consiste en tres áreas:

1. **Working Directory** - Donde editas tus archivos
2. **Staging Area** - Donde preparas los cambios
3. **Repository** - Donde se guardan los commits

```bash
# Ver estado actual
git status

# Agregar archivos al staging
git add archivo.js
git add .  # Todos los archivos

# Crear un commit
git commit -m "feat: agregar nueva funcionalidad"

# Ver historial
git log --oneline --graph
```

## Branching

Las ramas son una de las características más poderosas de Git:

```bash
# Crear nueva rama
git branch feature/nueva-funcionalidad

# Cambiar de rama
git checkout feature/nueva-funcionalidad

# Crear y cambiar en un solo comando
git checkout -b feature/otra-funcionalidad

# Listar ramas
git branch -a
```

### Estrategias de Merge

```bash
# Merge básico
git checkout main
git merge feature/nueva-funcionalidad

# Merge con squash (combina commits)
git merge --squash feature/branch

# Rebase (reescribe historial)
git checkout feature/branch
git rebase main
```

<div class="warning">
Nunca hagas rebase en ramas públicas que otros estén usando. Puede causar conflictos graves.
</div>

## Trabajando con Remotos

```bash
# Ver remotos configurados
git remote -v

# Agregar remoto
git remote add origin https://github.com/user/repo.git

# Subir cambios
git push origin main

# Traer cambios
git pull origin main

# Fetch sin merge
git fetch origin
```

## Comandos Avanzados

### Stash - Guardar cambios temporalmente

```bash
# Guardar cambios
git stash

# Listar stashes
git stash list

# Aplicar último stash
git stash pop

# Aplicar stash específico
git stash apply stash@{2}
```

### Cherry-pick - Traer commits específicos

```bash
# Traer un commit específico a la rama actual
git cherry-pick abc123
```

### Reset vs Revert

```bash
# Reset - Elimina commits (peligroso en ramas públicas)
git reset --soft HEAD~1   # Mantiene cambios en staging
git reset --hard HEAD~1   # Elimina todo

# Revert - Crea nuevo commit que deshace cambios (seguro)
git revert abc123
```

## Alias Útiles

Agrega estos alias a tu `.gitconfig`:

```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --all
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
```

## Git Hooks

Automatiza tareas con hooks:

```bash
# .git/hooks/pre-commit
#!/bin/sh
npm run lint
npm test
```

## Buenas Prácticas

### Conventional Commits

Usa un formato consistente para tus mensajes:

```
<tipo>[scope opcional]: <descripción>

[cuerpo opcional]

[footer opcional]
```

Tipos comunes:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Documentación
- `style`: Formato
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

### Ejemplo

```bash
git commit -m "feat(auth): agregar autenticación con OAuth2

- Implementar flujo de OAuth2
- Agregar refresh token
- Crear middleware de autenticación

Closes #123"
```

## Conclusión

Git es una herramienta fundamental para cualquier desarrollador. Dominar estos comandos te hará más productivo y te permitirá colaborar efectivamente en equipos.

<div class="tip">
Practica estos comandos en un repositorio de prueba antes de usarlos en proyectos reales.
</div>

---
