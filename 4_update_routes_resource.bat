@echo off
echo -------------------------------
echo Update Resource Routes in web.php (Fixed Final Version)
echo -------------------------------

:: Chọn cách xác định project path
echo Choose option:
echo 1. Enter Laravel project path manually
echo 2. Use current folder (batch file inside Laravel project)
set /p OPTION=Enter number (1 or 2): 

if "%OPTION%"=="1" (
    set /p PROJECT_PATH=Enter full path to your Laravel project: 
) else (
    set "PROJECT_PATH=%CD%"
)

:: Thiết lập các file
set "WEB_FILE=%PROJECT_PATH%\routes\web.php"

:: Kiểm tra web.php
if not exist "%WEB_FILE%" (
    echo ERROR: web.php not found at "%WEB_FILE%"
    pause
    exit /b
)

setlocal enabledelayedexpansion

:: Danh sách route cần thêm
:: --------- Admin Resource Routes ---------
set ROUTES[0]=Route::resource('posts', PostController::class);
set ROUTES[1]=Route::resource('categories', CategoryController::class);
set ROUTES[2]=Route::resource('comments', CommentController::class);
set ROUTES[3]=Route::resource('contacts', ContactController::class);
set ROUTES[4]=Route::resource('pages', PageController::class);
set ROUTES[5]=Route::resource('users', UserController::class);
set ROUTES[6]=Route::resource('roles', RoleController::class);
set ROUTES[7]=Route::resource('tags', TagController::class);
set ROUTES[8]=Route::resource('media', MediaController::class);
set ROUTES[9]=Route::resource('settings', SettingController::class);

:: --------- Home Routes ---------
set ROUTES[10]=Route::get('/', [HomeController::class,'index']);
set ROUTES[11]=Route::get('/about', [HomeController::class,'about']);
set ROUTES[12]=Route::get('/contact', [HomeController::class,'contact']);

:: Thêm từng route nếu chưa tồn tại
for /L %%i in (0,1,12) do (
    set "LINE=!ROUTES[%%i]!"
    findstr /c:"!LINE!" "%WEB_FILE%" >nul
    if !errorlevel! NEQ 0 (
        echo !LINE!>>"%WEB_FILE%"
        echo Added: !LINE!
    ) else (
        echo Route already exists: !LINE!
    )
)

echo Done.
pause
