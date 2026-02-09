@echo off
echo ==========================================
echo         LARAVEL MIGRATION TOOL
echo ==========================================
echo.
echo 1. php artisan migrate (chay migration moi)
echo 2. php artisan migrate:fresh (xoa tat ca bang va chay lai migration)
echo 3. php artisan migrate:rollback (hoan tac lan migrate gan nhat)
echo 4. php artisan migrate:reset (xoa tat ca bang va hoan tac tat ca migration)
echo 5. php artisan migrate:status (kiem tra trang thai migration)

echo 0. Thoat
echo.

set /p choice=Chon so (0-6): 

if "%choice%"=="1" goto MIGRATE
if "%choice%"=="2" goto FRESH
if "%choice%"=="3" goto ROLLBACK
if "%choice%"=="4" goto RESET
if "%choice%"=="5" goto STATUS
if "%choice%"=="0" goto EXIT

echo Lua chon khong hop le!
pause
exit

:: ========================
:: 1. MIGRATE
:: ========================
:MIGRATE
echo ------------------------------------------
echo Running: php artisan migrate
echo ------------------------------------------
php artisan migrate
echo.
echo Hoan thanh!
pause
exit

:: ========================
:: 2. MIGRATE:FRESH
:: ========================
:FRESH
echo ------------------------------------------
echo Running: php artisan migrate:fresh
echo ------------------------------------------
php artisan migrate:fresh
echo.
echo Hoan thanh!
pause
exit

:: ========================
:: 3. MIGRATE:ROLLBACK
:: ========================
:ROLLBACK
echo ------------------------------------------
echo Running: php artisan migrate:rollback
echo ------------------------------------------
php artisan migrate:rollback
echo.
echo Hoan thanh!
pause
exit

:: ========================
:: 4. MIGRATE:RESET
:: ========================
:RESET
echo ------------------------------------------
echo Running: php artisan migrate:reset
echo ------------------------------------------
php artisan migrate:reset
echo.
echo Hoan thanh!
pause
exit

:: ========================
:: 5. MIGRATE:STATUS
:: ========================
:STATUS
echo ------------------------------------------
echo Running: php artisan migrate:status
echo ------------------------------------------
php artisan migrate:status
echo.
echo Hoan thanh!
pause
exit


:EXIT
echo Thoat cong cu!
exit
