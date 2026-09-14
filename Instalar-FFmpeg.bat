@echo off
title Instalar FFmpeg
color 0A
echo ============================================
echo   Instalador automatico de FFmpeg
echo ============================================
echo.

echo Verificando si FFmpeg ya esta instalado...
where ffmpeg >nul 2>&1
if %errorlevel%==0 (
    echo.
    echo [OK] FFmpeg ya esta instalado:
    ffmpeg -version 2>nul | findstr "ffmpeg version"
    echo.
    pause
    exit /b 0
)

echo [!] FFmpeg no encontrado. Instalando...
echo.

echo [1/3] Descargando FFmpeg...
powershell -Command "Invoke-WebRequest -Uri 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip' -OutFile '%TEMP%\ffmpeg.zip'" 2>nul
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] No se pudo descargar FFmpeg.
    echo Descargalo manualmente desde: https://www.gyan.dev/ffmpeg/builds/
    echo.
    pause
    exit /b 1
)

echo [2/3] Extrayendo archivos...
powershell -Command "Expand-Archive -Path '%TEMP%\ffmpeg.zip' -DestinationPath '%TEMP%\ffmpeg_extract' -Force" 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] No se pudo extraer el archivo.
    pause
    exit /b 1
)

echo [3/3] Instalando en C:\ffmpeg...
if exist "C:\ffmpeg" rmdir /s /q "C:\ffmpeg"

REM Buscar la carpeta bin dentro del zip extraido
for /d %%i in ("%TEMP%\ffmpeg_extract\ffmpeg-*") do (
    if exist "%%i\bin" (
        xcopy "%%i\bin" "C:\ffmpeg\bin\" /E /I /Y >nul 2>&1
        goto :installed
    )
)

echo [ERROR] No se encontro la carpeta bin de FFmpeg.
pause
exit /b 1

:installed
echo.
echo [OK] FFmpeg instalado en C:\ffmpeg\bin
echo.

echo Agregando al PATH del sistema...
setx PATH "%PATH%;C:\ffmpeg\bin" >nul 2>&1
if %errorlevel%==0 (
    echo [OK] PATH actualizado correctamente.
) else (
    echo [!] No se pudo actualizar el PATH automaticamente.
    echo Agrega manualmente: C:\ffmpeg\bin
    echo.
    echo Pasos manuales:
    echo 1. Click derecho en "Este equipo" - Propiedades
    echo 2. Variables de entorno
    echo 3. En "Variables del sistema", busca Path - Editar - Nuevo
    echo 4. Agrega: C:\ffmpeg\bin
    echo 5. Aceptar todo y reinicia
)

echo.
echo Limpiando archivos temporales...
del "%TEMP%\ffmpeg.zip" 2>nul
rmdir /s /q "%TEMP%\ffmpeg_extract" 2>nul

echo.
echo ============================================
echo   Instalacion completada!
echo   Reinicia la computadora para usar FFmpeg.
echo ============================================
echo.
pause
