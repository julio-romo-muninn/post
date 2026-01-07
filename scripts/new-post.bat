@echo off
REM ==============================================
REM tpx BLOG - Crear Nuevo Post (Windows)
REM ==============================================

setlocal EnableDelayedExpansion

set POSTS_DIR=_posts

echo.
echo [94m╔════════════════════════════════════════╗[0m
echo [94m║       tpx BLOG - Nuevo Post            ║[0m
echo [94m╚════════════════════════════════════════╝[0m
echo.

REM Verificar directorio
if not exist "%POSTS_DIR%" (
    echo Error: No se encontró el directorio _posts
    pause
    exit /b 1
)

REM Solicitar información
echo [93mTítulo del post:[0m
set /p TITLE="> "

echo [93mCategoría (ej: Tutorial, Seguridad, DevOps):[0m
set /p CATEGORY="> "

echo [93mTags separados por coma (ej: docker, devops, linux):[0m
set /p TAGS="> "

echo [93mDescripción breve:[0m
set /p DESCRIPTION="> "

echo [93mAutor (key del authors.yml, ej: tpx-team):[0m
set /p AUTHOR="> "

REM Generar slug (simplificado para Windows)
set "SLUG=%TITLE%"
set "SLUG=!SLUG: =-!"
set "SLUG=!SLUG::=!"
set "SLUG=!SLUG:?=!"
set "SLUG=!SLUG:¿=!"
set "SLUG=!SLUG:!=!"
set "SLUG=!SLUG:¡=!"

REM Convertir a minúsculas (PowerShell helper)
for /f "delims=" %%a in ('powershell -command "('%SLUG%').ToLower()"') do set "SLUG=%%a"

REM Fecha actual
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "DATE=%dt:~0,4%-%dt:~4,2%-%dt:~6,2%"
set "DATETIME=%dt:~0,4%-%dt:~4,2%-%dt:~6,2% %dt:~8,2%:%dt:~10,2%:%dt:~12,2% -0500"

REM Nombre del archivo
set "FILENAME=%POSTS_DIR%\%DATE%-%SLUG%.md"

REM Crear el archivo
(
echo ---
echo title: "%TITLE%"
echo date: %DATETIME%
echo categories: [%CATEGORY%]
echo tags: [%TAGS%]
echo description: "%DESCRIPTION%"
echo author: %AUTHOR%
echo image: /assets/img/posts/%SLUG%.svg
echo toc: true
echo ---
echo.
echo ## Introducción
echo.
echo Escribe aquí la introducción de tu post...
echo.
echo ## Contenido Principal
echo.
echo ### Subtítulo 1
echo.
echo Tu contenido aquí...
echo.
echo ```bash
echo # Ejemplo de código
echo echo "Hola tpx Blog"
echo ```
echo.
echo ### Subtítulo 2
echo.
echo Más contenido...
echo.
echo ## Conclusión
echo.
echo Resumen y conclusiones del post...
echo.
echo ## Referencias
echo.
echo - [Enlace 1](https://ejemplo.com^)
echo - [Enlace 2](https://ejemplo.com^)
) > "%FILENAME%"

echo.
echo [92m✓ Post creado exitosamente![0m
echo Archivo: [94m%FILENAME%[0m
echo.
echo [93mPróximos pasos:[0m
echo 1. Edita el archivo con tu contenido
echo 2. Crea una imagen en: assets/img/posts/%SLUG%.svg
echo 3. Ejecuta scripts\publish.bat para publicar
echo.

pause
endlocal
