@echo off
cd /d "%~dp0"
echo =====================================================
echo    APK Oluşturma ve İndirme Scripti
echo =====================================================
echo Working directory: %CD%
echo.

echo [1/5] Android projesini temizleme...
call npx cap clean android
if %errorlevel% neq 0 (
    echo ERROR: Clean işlemi başarısız!
    pause
    exit /b 1
)

echo [2/5] Web uygulamasını build etme...
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Build işlemi başarısız!
    pause
    exit /b 1
)

echo [3/5] Android projesini senkronize etme...
call npx cap sync android
if %errorlevel% neq 0 (
    echo ERROR: Sync işlemi başarısız!
    pause
    exit /b 1
)

echo [4/5] APK oluşturma...
cd android
call gradlew.bat assembleDebug
if %errorlevel% neq 0 (
    echo ERROR: APK build başarısız!
    cd ..
    pause
    exit /b 1
)
cd ..

echo [5/5] APK dosyasını bulma ve kopyalama...
set "apk_found=false"
for /r android\app\build\outputs\apk %%i in (*.apk) do (
    echo APK bulundu: %%i
    copy "%%i" "TurkiyeSiyasiOyunu.apk"
    set "apk_found=true"
    echo.
    echo =====================================================
    echo SUCCESS! APK dosyası hazır: TurkiyeSiyasiOyunu.apk
    echo Dosya boyutu: %%~zi bytes
    echo =====================================================
    goto :success
)

if "%apk_found%"=="false" (
    echo ERROR: APK dosyası bulunamadı!
    echo Build klasörlerini kontrol ediliyor...
    dir android\app\build\outputs\apk /s
    pause
    exit /b 1
)

:success
echo APK dosyası masaüstünüze kopyalanıyor...
if exist "%USERPROFILE%\Desktop" (
    copy "TurkiyeSiyasiOyunu.apk" "%USERPROFILE%\Desktop\TurkiyeSiyasiOyunu.apk"
    echo APK masaüstüne kopyalandı: %USERPROFILE%\Desktop\TurkiyeSiyasiOyunu.apk
)

echo.
echo =====================================================
echo TAMAMLANDI! APK dosyası hazır.
echo Ana klasör: TurkiyeSiyasiOyunu.apk
echo Masaüstü: %USERPROFILE%\Desktop\TurkiyeSiyasiOyunu.apk
echo =====================================================
pause
