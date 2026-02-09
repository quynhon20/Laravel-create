@echo off
echo -------------------------------
echo Laravel Project Creator
echo -------------------------------

:: Nhập tên project
set /p PROJECT_NAME=Enter your project name: 

:: Chọn phiên bản Laravel
echo Select Laravel version:
echo 1. Laravel 10
echo 2. Laravel 11
echo 3. Laravel 12
set /p VERSION_CHOICE=Enter number (1-3): 

:: Xác định version string
if "%VERSION_CHOICE%"=="1" set VERSION_STRING=^10.0
if "%VERSION_CHOICE%"=="2" set VERSION_STRING=^11.0
if "%VERSION_CHOICE%"=="3" set VERSION_STRING=^12.0

:: Kiểm tra nếu người dùng nhập sai
if "%VERSION_STRING%"=="" (
    echo Invalid choice! Exiting...
    pause
    exit /b
)

:: Chạy composer create-project
echo Creating Laravel %VERSION_STRING% project named %PROJECT_NAME%...
composer create-project "laravel/laravel:%VERSION_STRING%" %PROJECT_NAME%

echo -------------------------------
echo Laravel project created!
echo -------------------------------

pause
