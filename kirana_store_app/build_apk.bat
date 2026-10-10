@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   Kirana Store Android App - Release APK Build Engine
echo ========================================================
echo.

where flutter >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Flutter SDK not detected in your PATH.
    echo.
    echo To build the APK, please ensure Flutter SDK and Java/Android SDK
    echo are installed and added to your system environment variables.
    echo.
    echo Download Flutter: https://docs.flutter.dev/get-started/install/windows/mobile
    echo.
    pause
    exit /b 1
)

echo [1/3] Fetching project dependencies (flutter pub get)...
call flutter pub get
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to fetch dependencies.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/3] Building production release APK (flutter build apk --release)...
call flutter build apk --release
if %ERRORLEVEL% neq 0 (
    echo [ERROR] APK build failed. Check the error log above.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [3/3] Build complete!
set "OUTPUT_APK=%~dp0build\app\outputs\flutter-apk\app-release.apk"

if exist "%OUTPUT_APK%" (
    echo.
    echo ========================================================
    echo   SUCCESS! Release APK generated at:
    echo   %OUTPUT_APK%
    echo ========================================================
    echo.
    echo Opening output folder in File Explorer...
    explorer /select,"%OUTPUT_APK%"
) else (
    echo [NOTICE] Expected APK at: %OUTPUT_APK%
)

echo.
pause
