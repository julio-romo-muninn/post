---
title: "Docker para Desarrolladores: De Cero a Producción"
date: 2026-01-03 11:00:00 -0500
categories: [Tutorial, DevOps]
tags: [docker, containers, devops, deployment, tutorial]
description: "Aprende Docker desde los fundamentos hasta despliegues en producción. Incluye ejemplos prácticos con Docker Compose y buenas prácticas."
author: tpx Team
image: /assets/img/posts/docker.svg
toc: true
---

## ¿Por qué Docker?

Docker revolucionó la forma en que desarrollamos y desplegamos aplicaciones. Con contenedores, puedes:

- 🚀 Garantizar consistencia entre entornos
- 📦 Empaquetar dependencias junto con tu app
- 🔄 Escalar horizontalmente con facilidad
- ⚡ Acelerar el ciclo de desarrollo

## Conceptos Fundamentales

### Imágenes vs Contenedores

```
+----------------+     docker run     +----------------+
|    IMAGEN      | ----------------> |   CONTENEDOR   |
| (Blueprint)    |                   | (Instancia)    |
+----------------+                   +----------------+
```

- **Imagen**: Template inmutable con el SO y tu aplicación
- **Contenedor**: Instancia ejecutable de una imagen

### Arquitectura Docker

```
┌─────────────────────────────────────┐
│           Docker Client             │
│         (docker CLI)                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│          Docker Daemon              │
│         (dockerd)                   │
├─────────────────────────────────────┤
│  Images  │  Containers  │  Networks │
└─────────────────────────────────────┘
```

## Comandos Esenciales

### Gestión de Imágenes

```bash
# Descargar imagen
docker pull nginx:latest

# Listar imágenes
docker images

# Eliminar imagen
docker rmi nginx:latest

# Construir imagen desde Dockerfile
docker build -t mi-app:v1 .
```

### Gestión de Contenedores

```bash
# Ejecutar contenedor
docker run -d -p 8080:80 --name web nginx

# Listar contenedores
docker ps        # En ejecución
docker ps -a     # Todos

# Detener/Iniciar
docker stop web
docker start web

# Ver logs
docker logs -f web

# Ejecutar comando dentro del contenedor
docker exec -it web bash

# Eliminar contenedor
docker rm web
```

## Dockerfile

El `Dockerfile` define cómo construir tu imagen:

```dockerfile
# Imagen base
FROM node:18-alpine

# Metadata
LABEL maintainer="tpx@example.com"

# Directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias primero (cache optimization)
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production

# Copiar código fuente
COPY . .

# Variable de entorno
ENV NODE_ENV=production

# Exponer puerto
EXPOSE 3000

# Usuario no-root (seguridad)
USER node

# Comando por defecto
CMD ["node", "server.js"]
```

### Multi-stage Builds

Reduce el tamaño de tu imagen final:

```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

## Docker Compose

Para aplicaciones multi-contenedor, usa `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # Aplicación web
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
      - redis
    restart: unless-stopped
    networks:
      - app-network

  # Base de datos
  db:
    image: postgres:15-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=mydb
    networks:
      - app-network

  # Cache
  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    networks:
      - app-network

  # Reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    networks:
      - app-network

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

### Comandos Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Escalar servicios
docker-compose up -d --scale app=3

# Detener
docker-compose down

# Eliminar todo (incluyendo volúmenes)
docker-compose down -v
```

## Networking

Docker ofrece varios drivers de red:

```bash
# Crear red personalizada
docker network create --driver bridge mi-red

# Conectar contenedor a red
docker network connect mi-red mi-contenedor

# Inspeccionar red
docker network inspect mi-red
```

### Tipos de Red

| Driver | Uso |
|--------|-----|
| bridge | Red aislada (default) |
| host | Comparte red del host |
| none | Sin networking |
| overlay | Multi-host (Swarm) |

## Volúmenes

Persiste datos fuera del contenedor:

```bash
# Crear volumen
docker volume create mi-data

# Montar volumen
docker run -v mi-data:/app/data nginx

# Bind mount (directorio local)
docker run -v $(pwd)/config:/app/config nginx

# Inspeccionar
docker volume inspect mi-data
```

## Buenas Prácticas

### 1. Usa imágenes base pequeñas

```dockerfile
# ❌ Evitar
FROM ubuntu:latest

# ✅ Preferir
FROM alpine:3.18
FROM node:18-alpine
FROM python:3.11-slim
```

### 2. Minimiza capas

```dockerfile
# ❌ Múltiples RUN
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get clean

# ✅ Un solo RUN
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### 3. No ejecutes como root

```dockerfile
# Crear usuario
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

### 4. Usa .dockerignore

```
# .dockerignore
node_modules
.git
.env
*.md
Dockerfile
docker-compose.yml
```

### 5. Health checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

## Seguridad

<div class="danger">
Prácticas de seguridad críticas:
</div>

```bash
# Escanear vulnerabilidades
docker scan mi-imagen:latest

# Ejecutar con capacidades limitadas
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx

# Filesystem de solo lectura
docker run --read-only nginx

# Limitar recursos
docker run --memory=512m --cpus=1 nginx
```

## Ejemplo Práctico: Stack MERN

```yaml
# docker-compose.yml para MERN Stack
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:5000
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "5000:5000"
    environment:
      - MONGODB_URI=mongodb://mongo:27017/myapp
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mongo

  mongo:
    image: mongo:6
    volumes:
      - mongo_data:/data/db
    ports:
      - "27017:27017"

volumes:
  mongo_data:
```

## Debugging

```bash
# Ver procesos en contenedor
docker top mi-contenedor

# Estadísticas en tiempo real
docker stats

# Inspeccionar contenedor
docker inspect mi-contenedor

# Copiar archivos desde/hacia contenedor
docker cp mi-contenedor:/app/logs ./logs
docker cp ./config.json mi-contenedor:/app/
```

## Conclusión

Docker es una herramienta fundamental en el desarrollo moderno. Con estos conocimientos puedes:

- ✅ Crear entornos reproducibles
- ✅ Simplificar despliegues
- ✅ Mejorar la colaboración en equipo
- ✅ Escalar aplicaciones eficientemente

```bash
$ docker run -it --rm alpine echo "¡Docker es genial! 🐳"
¡Docker es genial! 🐳
```

---
