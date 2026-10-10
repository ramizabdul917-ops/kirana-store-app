@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   Kirana Store Android App - Cloud Build ^& Delivery
echo   (Builds APK in GitHub Cloud - No local SDK required)
echo ========================================================
echo.

:: Ensure Git and GitHub CLI are in PATH
set "PATH=C:\Program Files\Git\cmd;C:\Program Files\GitHub CLI;%PATH%"

where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Git is not found in PATH.
    pause
    exit /b 1
)

where gh >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] GitHub CLI (gh) is not found in PATH.
    pause
    exit /b 1
)

echo [1/4] Checking GitHub CLI Authentication...
gh auth status >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo [ACTION REQUIRED] You need to log in to your GitHub account once.
    echo A browser window will open or a one-time code will appear.
    echo.
    gh auth login -w -p https
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] GitHub login was cancelled or failed.
        pause
        exit /b 1
    )
)
echo [OK] Authenticated with GitHub.
echo.

echo [2/4] Verifying GitHub Remote Repository...
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo No GitHub remote found. Creating repository on your GitHub account...
    gh repo create kirana-store-app --source=. --remote=origin --push --private
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Could not create repository automatically.
        echo If the repository already exists, link it with:
        echo   git remote add origin https://github.com/^<your-username^>/^<your-repo^>.git
        pause
        exit /b 1
    )
    echo [OK] Repository created and synced!
) else (
    echo Remote repository found. Syncing latest commits...
    git push -u origin main
)
echo.

echo [3/4] Triggering Cloud Build Workflow...
gh workflow run "Build Flutter Release APK" --ref main
if %ERRORLEVEL% neq 0 (
    echo [NOTICE] Workflow dispatch triggered via push.
)
echo.

echo [4/4] Watching Live Cloud Build (takes ~3-4 minutes)...
echo You can also view live logs in your browser.
gh run watch

echo.
echo ========================================================
echo   Cloud build finished!
echo ========================================================
echo.
echo Fetching latest run and opening download page...
for /f "tokens=*" %%i in ('gh run list --workflow="build_apk.yml" --limit 1 --json databaseId --jq ".[0].databaseId"') do set RUN_ID=%%i

if not "%RUN_ID%"=="" (
    echo Run ID: %RUN_ID%
    echo Downloading release APK to local folder...
    gh run download %RUN_ID% -n app-release -D .
    if exist "app-release.apk" (
        echo.
        echo [SUCCESS] APK downloaded directly to:
        echo   %~dp0app-release.apk
        explorer /select,"%~dp0app-release.apk"
    ) else (
        echo Opening run page in your browser to download artifact...
        gh run view %RUN_ID% --web
    )
) else (
    gh repo view --web
)

pause
