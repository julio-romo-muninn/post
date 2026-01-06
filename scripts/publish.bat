@echo off
REM ==============================================
REM TPX BLOG - Script de Publicación (Windows)
REM ==============================================
REM Este script automatiza el proceso de publicar
REM un nuevo post sin conflictos en el repositorio.
REM ==============================================

setlocal EnableDelayedExpansion

REM Configuración
set MAIN_BRANCH=main
set BUILD_BRANCH=gh-pages

REM Colores (usando códigos ANSI en Windows 10+)
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

echo.
echo %BLUE%╔════════════════════════════════════════╗%NC%
echo %BLUE%║       TPX BLOG - Publicación           ║%NC%
echo %BLUE%╚════════════════════════════════════════╝%NC%
echo.

REM Verificar que estamos en el directorio correcto
if not exist "_config.yml" (
    echo %RED%[ERROR]%NC% No se encontró _config.yml. Ejecuta este script desde la raíz del blog.
    pause
    exit /b 1
)

REM Verificar Git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%NC% Git no está instalado. Por favor instálalo primero.
    pause
    exit /b 1
)

REM Verificar Bundle
where bundle >nul 2>nul
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%NC% Bundler no está instalado. Ejecuta: gem install bundler
    pause
    exit /b 1
)

echo %YELLOW%[PASO]%NC% Verificando requisitos...
echo %GREEN%[OK]%NC% Requisitos verificados

REM Obtener rama actual
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

REM Verificar cambios
git status -s > temp_status.txt
set /p CHANGES=<temp_status.txt
del temp_status.txt

if defined CHANGES (
    echo %YELLOW%[PASO]%NC% Detectados cambios sin guardar...
    echo.
    echo %BLUE%Archivos modificados:%NC%
    git status -s
    echo.
    set /p CONTINUE="¿Deseas continuar y crear un commit con estos cambios? (s/n): "
    if /i not "!CONTINUE!"=="s" (
        echo Operación cancelada.
        pause
        exit /b 0
    )
) else (
    echo %YELLOW%No hay cambios nuevos para publicar.%NC%
    set /p CONTINUE="¿Deseas continuar de todas formas? (s/n): "
    if /i not "!CONTINUE!"=="s" (
        exit /b 0
    )
)

REM Generar nombre de rama único
for /f "tokens=*" %%a in ('git config user.name') do set AUTHOR=%%a
set AUTHOR=%AUTHOR: =-%
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set TIMESTAMP=%dt:~0,8%-%dt:~8,6%
set WORK_BRANCH=post/%AUTHOR%/%TIMESTAMP%

echo %YELLOW%[PASO]%NC% Actualizando rama principal...
git fetch origin %MAIN_BRANCH% 2>nul
echo %GREEN%[OK]%NC% Repositorio actualizado

echo %YELLOW%[PASO]%NC% Creando rama de trabajo: %WORK_BRANCH%

REM Guardar cambios temporalmente
git diff --quiet --exit-code
if %errorlevel% neq 0 (
    git stash push -m "temp-changes-for-publish"
    set STASHED=1
) else (
    set STASHED=0
)

REM Cambiar a main y actualizar
git checkout %MAIN_BRANCH%
git pull origin %MAIN_BRANCH% 2>nul

REM Crear nueva rama
git checkout -b %WORK_BRANCH%

REM Recuperar cambios
if %STASHED%==1 (
    git stash pop
)

echo %GREEN%[OK]%NC% Rama creada: %WORK_BRANCH%

REM Agregar cambios
echo %YELLOW%[PASO]%NC% Agregando cambios...
git add -A

REM Pedir mensaje de commit
echo.
echo %BLUE%Escribe el mensaje del commit (ej: 'Nuevo post: Mi articulo'):%NC%
set /p COMMIT_MSG="> "

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=Nuevo post - %date%
)

git commit -m "%COMMIT_MSG%"
echo %GREEN%[OK]%NC% Commit creado

REM Compilar el sitio
echo %YELLOW%[PASO]%NC% Compilando el sitio con Jekyll...
call bundle install --quiet
set JEKYLL_ENV=production
call bundle exec jekyll build
echo %GREEN%[OK]%NC% Sitio compilado correctamente

REM Push de la rama de trabajo
echo %YELLOW%[PASO]%NC% Subiendo rama de trabajo...
git push -u origin %WORK_BRANCH%
echo %GREEN%[OK]%NC% Rama subida a origin

REM Preguntar si hacer merge
echo.
set /p DO_MERGE="¿Deseas hacer merge a %MAIN_BRANCH% ahora? (s/n): "

if /i "%DO_MERGE%"=="s" (
    echo %YELLOW%[PASO]%NC% Haciendo merge a %MAIN_BRANCH%...
    git checkout %MAIN_BRANCH%
    git merge %WORK_BRANCH% --no-ff -m "Merge: %COMMIT_MSG%"
    git push origin %MAIN_BRANCH%
    echo %GREEN%[OK]%NC% Merge completado y subido a %MAIN_BRANCH%
    
    set /p DELETE_BRANCH="¿Eliminar la rama de trabajo %WORK_BRANCH%? (s/n): "
    if /i "!DELETE_BRANCH!"=="s" (
        git branch -d %WORK_BRANCH%
        git push origin --delete %WORK_BRANCH% 2>nul
        echo %GREEN%[OK]%NC% Rama de trabajo eliminada
    )
) else (
    echo.
    echo %YELLOW%Para hacer merge manualmente:%NC%
    echo   git checkout %MAIN_BRANCH%
    echo   git merge %WORK_BRANCH%
    echo   git push origin %MAIN_BRANCH%
)

REM Resumen final
echo.
echo %GREEN%╔════════════════════════════════════════╗%NC%
echo %GREEN%║       ¡Publicación Exitosa!            ║%NC%
echo %GREEN%╚════════════════════════════════════════╝%NC%
echo.
echo Rama de trabajo: %WORK_BRANCH%
echo Commit: %COMMIT_MSG%
echo.

pause
endlocal
