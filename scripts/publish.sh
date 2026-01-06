#!/bin/bash
# ==============================================
# TPX BLOG - Script de Publicación (Linux/macOS)
# ==============================================
# Este script automatiza el proceso de publicar
# un nuevo post sin conflictos en el repositorio.
# ==============================================

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Configuración
MAIN_BRANCH="main"
BUILD_BRANCH="gh-pages"

# Funciones de utilidad
print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║       TPX BLOG - Publicación           ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${YELLOW}[PASO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Verificar que estamos en el directorio correcto
check_directory() {
    if [ ! -f "_config.yml" ]; then
        print_error "No se encontró _config.yml. Ejecuta este script desde la raíz del blog."
    fi
}

# Verificar que Git está instalado
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git no está instalado. Por favor instálalo primero."
    fi
}

# Verificar que Bundle está instalado
check_bundle() {
    if ! command -v bundle &> /dev/null; then
        print_error "Bundler no está instalado. Ejecuta: gem install bundler"
    fi
}

# Obtener el nombre del autor desde git config
get_author_name() {
    git config user.name || echo "autor"
}

# Generar nombre de rama único
generate_branch_name() {
    local author=$(get_author_name | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
    local timestamp=$(date +%Y%m%d-%H%M%S)
    echo "post/${author}/${timestamp}"
}

# Main script
main() {
    print_header
    
    # Verificaciones iniciales
    print_step "Verificando requisitos..."
    check_directory
    check_git
    check_bundle
    print_success "Requisitos verificados"
    
    # Guardar rama actual
    CURRENT_BRANCH=$(git branch --show-current)
    
    # Verificar si hay cambios sin commitear
    if [[ -n $(git status -s) ]]; then
        print_step "Detectados cambios sin guardar..."
        
        # Mostrar archivos modificados
        echo -e "${BLUE}Archivos modificados:${NC}"
        git status -s
        echo ""
        
        # Preguntar si continuar
        read -p "¿Deseas continuar y crear un commit con estos cambios? (s/n): " response
        if [[ ! "$response" =~ ^[Ss]$ ]]; then
            echo "Operación cancelada."
            exit 0
        fi
    else
        echo -e "${YELLOW}No hay cambios nuevos para publicar.${NC}"
        read -p "¿Deseas continuar de todas formas? (s/n): " response
        if [[ ! "$response" =~ ^[Ss]$ ]]; then
            exit 0
        fi
    fi
    
    # Actualizar main
    print_step "Actualizando rama principal..."
    git fetch origin $MAIN_BRANCH 2>/dev/null || true
    print_success "Repositorio actualizado"
    
    # Crear rama de trabajo
    WORK_BRANCH=$(generate_branch_name)
    print_step "Creando rama de trabajo: $WORK_BRANCH"
    
    # Guardar cambios temporalmente si los hay
    if [[ -n $(git status -s) ]]; then
        git stash push -m "temp-changes-for-publish"
        STASHED=true
    else
        STASHED=false
    fi
    
    # Cambiar a main y actualizar
    git checkout $MAIN_BRANCH
    git pull origin $MAIN_BRANCH 2>/dev/null || true
    
    # Crear nueva rama
    git checkout -b $WORK_BRANCH
    
    # Recuperar cambios
    if [ "$STASHED" = true ]; then
        git stash pop
    fi
    
    print_success "Rama creada: $WORK_BRANCH"
    
    # Agregar cambios
    print_step "Agregando cambios..."
    git add -A
    
    # Pedir mensaje de commit
    echo ""
    echo -e "${BLUE}Escribe el mensaje del commit (ej: 'Nuevo post: Mi artículo'):${NC}"
    read -p "> " commit_message
    
    if [ -z "$commit_message" ]; then
        commit_message="Nuevo post - $(date +%Y-%m-%d)"
    fi
    
    git commit -m "$commit_message"
    print_success "Commit creado"
    
    # Compilar el sitio
    print_step "Compilando el sitio con Jekyll..."
    bundle install --quiet
    JEKYLL_ENV=production bundle exec jekyll build
    print_success "Sitio compilado correctamente"
    
    # Push de la rama de trabajo
    print_step "Subiendo rama de trabajo..."
    git push -u origin $WORK_BRANCH
    print_success "Rama subida a origin"
    
    # Preguntar si hacer merge a main
    echo ""
    read -p "¿Deseas hacer merge a $MAIN_BRANCH ahora? (s/n): " do_merge
    
    if [[ "$do_merge" =~ ^[Ss]$ ]]; then
        print_step "Haciendo merge a $MAIN_BRANCH..."
        git checkout $MAIN_BRANCH
        git merge $WORK_BRANCH --no-ff -m "Merge: $commit_message"
        git push origin $MAIN_BRANCH
        print_success "Merge completado y subido a $MAIN_BRANCH"
        
        # Limpiar rama de trabajo
        read -p "¿Eliminar la rama de trabajo $WORK_BRANCH? (s/n): " delete_branch
        if [[ "$delete_branch" =~ ^[Ss]$ ]]; then
            git branch -d $WORK_BRANCH
            git push origin --delete $WORK_BRANCH 2>/dev/null || true
            print_success "Rama de trabajo eliminada"
        fi
    else
        echo ""
        echo -e "${YELLOW}Para hacer merge manualmente:${NC}"
        echo "  git checkout $MAIN_BRANCH"
        echo "  git merge $WORK_BRANCH"
        echo "  git push origin $MAIN_BRANCH"
    fi
    
    # Resumen final
    echo ""
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║       ¡Publicación Exitosa!            ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "Rama de trabajo: $WORK_BRANCH"
    echo "Commit: $commit_message"
    echo ""
}

# Ejecutar
main "$@"
