@echo off
REM ==============================================
REM tpx BLOG - Setup para GitHub Pages (Windows)
REM ==============================================
REM Este script configura el entorno para ser
REM compatible con GitHub Pages (Ruby 3.1.7)
REM ==============================================

setlocal EnableDelayedExpansion

set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

echo.
echo %BLUE%╔════════════════════════════════════════╗%NC%
echo %BLUE%║   tpx BLOG - Setup GitHub Pages        ║%NC%
echo %BLUE%╚════════════════════════════════════════╝%NC%
echo.

REM Verificar directorio
if not exist "_config.yml" (
    echo %RED%[ERROR]%NC% Ejecuta este script desde la raíz del blog.
    pause
    exit /b 1
)

REM Bundler version compatible con GitHub Actions
set BUNDLER_VERSION=2.5.0

echo %YELLOW%[1/4]%NC% Instalando Bundler %BUNDLER_VERSION%...
call gem install bundler -v %BUNDLER_VERSION% --no-document

echo %YELLOW%[2/4]%NC% Eliminando Gemfile.lock antiguo...
if exist Gemfile.lock del Gemfile.lock

echo %YELLOW%[3/4]%NC% Generando nuevo Gemfile.lock...
call bundle _%BUNDLER_VERSION%_ lock

echo %YELLOW%[4/4]%NC% Agregando plataforma x86_64-linux para GitHub Actions...
call bundle _%BUNDLER_VERSION%_ lock --add-platform x86_64-linux

echo.
echo %GREEN%╔════════════════════════════════════════╗%NC%
echo %GREEN%║         Setup Completado!              ║%NC%
echo %GREEN%╚════════════════════════════════════════╝%NC%
echo.
echo Gemfile.lock regenerado con:
echo   - Bundler: %BUNDLER_VERSION%
echo   - Plataformas: x86_64-linux (GitHub Actions)
echo.
echo Gems pinneados para Ruby 3.1.7 compatibilidad:
echo   - connection_pool ~^> 2.4
echo   - minitest ~^> 5.0
echo   - activesupport ~^> 7.0
echo   - nokogiri ~^> 1.16.0
echo   - public_suffix ~^> 5.0
echo.
echo %YELLOW%Siguiente paso:%NC% git add Gemfile.lock ^&^& git commit -m "Regenerate lockfile" ^&^& git push
echo.

pause
endlocal
