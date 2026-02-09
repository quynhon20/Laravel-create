@echo off
title Laravel ENV Setup

:menu
cls
echo ---------------------------------------
echo CHON CHUC NANG CAU HINH LARAVEL
echo ---------------------------------------
echo 1. Tao file .env tu .env.example (voi lua chon SESSION_DRIVER)
echo 2. Chuyen sang SQLite
echo 3. Chuyen sang MySQL
echo 4. Migrate
echo 5. Thoat
echo ---------------------------------------
set /p choice=Nhap lua chon (1, 2, 3, 4, 5): 

if "%choice%"=="1" goto create_env
if "%choice%"=="2" goto sqlite
if "%choice%"=="3" goto mysql
if "%choice%"=="4" goto migrate
if "%choice%"=="5" goto end
echo Lua chon khong hop le!
pause
goto menu

:: ==============================
:: 1. TAO .ENV + CHON SESSION_DRIVER
:: ==============================
:create_env
echo Dang tao file .env...

if not exist .env.example (
    echo LOI: Khong tim thay file .env.example
    pause
    exit /b
)

copy /Y .env.example .env >nul
echo Da tao file .env tu ban mau!
echo.

:choose_session
echo Chon SESSION_DRIVER:
echo 1. file
echo 2. database
set "ss="
set /p ss=Nhap lua chon (1 hoac 2): 

if "%ss%"=="1" set "driver=file" & goto update_session
if "%ss%"=="2" set "driver=database" & goto update_session

echo Ban chi duoc nhap 1 hoac 2 thoi nhe!
goto choose_session

:update_session
setlocal enabledelayedexpansion

(
    for /f "usebackq delims=" %%A in (".env") do (
        echo %%A | findstr /r "^SESSION_DRIVER=" >nul
        if !errorlevel! == 0 (
            :: Thay thế dòng SESSION_DRIVER bằng giá trị mới
            echo SESSION_DRIVER=%driver%
        ) else (
            :: Giữ nguyên dòng khác
            echo %%A
        )
    )
) > ".env.tmp"

move /Y ".env.tmp" ".env" >nul
endlocal
echo Da cap nhat SESSION_DRIVER thanh "%driver%" trong file .env
:: ==============================
:: Kiem tra APP_KEY
:: ==============================
set "appkey="
for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if "%%A"=="APP_KEY" set "appkey=%%B"
)

if "%appkey%"=="" (
    echo APP_KEY rong. Dang tao moi...
    php artisan key:generate
) else (
    echo APP_KEY da co gia tri: %appkey%
)

pause
goto menu
:: ================================
:: KIEM TRA .ENV TON TAI (CHO 2,3)
:: ================================
if not exist .env (
    echo Loi: Chua co file .env !
    echo Hay chon muc 1 de tao .env tu .env.example truoc.
    pause
    exit /b 1
)

:: ==============================
:: 2. CẬP NHẬT SQLITE
:: ==============================
:sqlite
echo Chuyen sang SQLite...
setlocal enabledelayedexpansion
(
    for /f "usebackq delims=" %%A in (".env") do (
        echo %%A | findstr /r "^DB_CONNECTION=" >nul
        if !errorlevel! == 0 (
            echo DB_CONNECTION=sqlite
        ) else (
            echo %%A | findstr /r "^#*[ ]*DB_HOST=" >nul
            if !errorlevel! == 0 (
                echo # DB_HOST=127.0.0.1
            ) else (
                echo %%A | findstr /r "^#*[ ]*DB_PORT=" >nul
                if !errorlevel! == 0 (
                    echo # DB_PORT=3306
                ) else (
                    echo %%A | findstr /r "^#*[ ]*DB_DATABASE=" >nul
                    if !errorlevel! == 0 (
                        echo # DB_DATABASE=laravel
                    ) else (
                        echo %%A | findstr /r "^#*[ ]*DB_USERNAME=" >nul
                        if !errorlevel! == 0 (
                            echo # DB_USERNAME=root
                        ) else (
                            echo %%A | findstr /r "^#*[ ]*DB_PASSWORD=" >nul
                            if !errorlevel! == 0 (
                                echo # DB_PASSWORD=
                            ) else (
                                echo %%A
                            )
                        )
                    )
                )
            )
        )
    )
) > ".env.tmp"
endlocal
move /Y ".env.tmp" ".env" >nul
echo Done. Da chuyen sang SQLite
goto clear_cache

:: ==============================
:: 3. CẬP NHẬT MYSQL
:: ==============================
:mysql2
echo Chuyen sang MySQL...
setlocal enabledelayedexpansion
(
    for /f "usebackq delims=" %%A in (".env") do (
        echo %%A | findstr /r "^DB_CONNECTION=" >nul
        if !errorlevel! == 0 (
            echo DB_CONNECTION=mysql
        ) else (
            echo %%A | findstr /r "^#*[ ]*DB_HOST=" >nul
            if !errorlevel! == 0 (
                echo DB_HOST=127.0.0.1
            ) else (
                echo %%A | findstr /r "^#*[ ]*DB_PORT=" >nul
                if !errorlevel! == 0 (
                    echo DB_PORT=3306
                ) else (
                    echo %%A | findstr /r "^#*[ ]*DB_DATABASE=" >nul
                    if !errorlevel! == 0 (
                        echo DB_DATABASE=laravel
                    ) else (
                        echo %%A | findstr /r "^#*[ ]*DB_USERNAME=" >nul
                        if !errorlevel! == 0 (
                            echo DB_USERNAME=root
                        ) else (
                            echo %%A | findstr /r "^#*[ ]*DB_PASSWORD=" >nul
                            if !errorlevel! == 0 (
                                echo DB_PASSWORD=
                            ) else (
                                echo %%A
                            )
                        )
                    )
                )
            )
        )
    )
) > ".env.tmp"
endlocal
move /Y ".env.tmp" ".env" >nul
echo Done. Da chuyen sang MySQL

goto clear_cache

:: -----------------------------
:: new sql
:mysql

REM -------------------------------
REM Chuyen sang MySQL va tao database
REM -------------------------------

REM Cấu hình MySQL
set MYSQL_USER=root
set MYSQL_PASS=
set MYSQL_HOST=127.0.0.1
set MYSQL_PORT=3306

REM Nhập tên database từ người dùng
set /p DB_NAME=Enter database name to create: 

if "%DB_NAME%"=="" (
    echo Database name cannot be empty!
    pause
    exit /b
)

REM Tạo database MySQL nếu chưa tồn tại

set FOUND=
for /f %%i in ('mysql -h %MYSQL_HOST% -u %MYSQL_USER% %MYSQL_PASS_ARG% -e "SHOW DATABASES LIKE ''%DB_NAME%'';" 2^>nul') do set FOUND=%%i

if "%FOUND%"=="%DB_NAME%" (
    echo Database "%DB_NAME%" already exists.
) else (
    REM Tạo database an toàn với backtick
    echo Creating database "%DB_NAME%"...
    if "%MYSQL_PASS%"=="" (
        mysql -h %MYSQL_HOST% -u %MYSQL_USER% -e "CREATE DATABASE `%DB_NAME%` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    ) else (
        mysql -h %MYSQL_HOST% -u %MYSQL_USER% -p%MYSQL_PASS% -e "CREATE DATABASE `%DB_NAME%` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    )
    echo Database "%DB_NAME%" created successfully.
)

REM Cập nhật .env
if not exist ".env" (
    echo ERROR: .env file not found!
    pause
    exit /b
)

echo Updating .env with new database name...
setlocal enabledelayedexpansion
(
    for /f "usebackq delims=" %%A in (".env") do (
        echo %%A | findstr /r "^DB_CONNECTION=" >nul
        if !errorlevel! == 0 (
            echo DB_CONNECTION=mysql
        ) else (
            echo %%A | findstr /r "^#*[ ]*DB_HOST=" >nul
            if !errorlevel! == 0 (
                echo DB_HOST=%MYSQL_HOST%
            ) else (
                echo %%A | findstr /r "^#*[ ]*DB_PORT=" >nul
                if !errorlevel! == 0 (
                    echo DB_PORT=%MYSQL_PORT%
                ) else (
                    echo %%A | findstr /r "^#*[ ]*DB_DATABASE=" >nul
                    if !errorlevel! == 0 (
                        echo DB_DATABASE=%DB_NAME%
                    ) else (
                        echo %%A | findstr /r "^#*[ ]*DB_USERNAME=" >nul
                        if !errorlevel! == 0 (
                            echo DB_USERNAME=%MYSQL_USER%
                        ) else (
                            echo %%A | findstr /r "^#*[ ]*DB_PASSWORD=" >nul
                            if !errorlevel! == 0 (
                                echo DB_PASSWORD=%MYSQL_PASS%
                            ) else (
                                echo %%A
                            )
                        )
                    )
                )
            )
        )
    )
) > ".env.tmp"
endlocal
move /Y ".env.tmp" ".env" >nul

echo Done! Database "%DB_NAME%" created and .env updated.
goto clear_cache
:: ==============================
:: CLEAR CACHE LARAVEL
:: ==============================
:clear_cache
echo Xoa cache Laravel...
php artisan config:clear >nul 2>&1
php artisan cache:clear >nul 2>&1
echo Da xoa cache thanh cong!
pause
goto menu

:: ==============================
:: Migrate
:: ==============================
:migrate
echo Chay lenh migrate...
php artisan migrate
echo Migrate thanh cong
pause
goto menu

:end
echo Thoat khoi chuong trinh...
pause
exit /b

echo ---------------------------------------
echo HOAN TAT!
echo ---------------------------------------
pause
exit /b