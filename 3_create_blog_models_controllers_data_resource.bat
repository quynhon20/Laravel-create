@echo off
setlocal

echo -------------------------------
echo Laravel Blog Setup Script
echo -------------------------------

echo Choose action:
echo 1. Create models, controllers, migrations
echo 2. Undo (delete Admin models, controllers, migrations)
set /p ACTION=Enter number (1 or 2): 

if "%ACTION%"=="1" goto CREATE
if "%ACTION%"=="2" goto UNDO
echo Invalid choice
goto END

:: -------------------------------
:CREATE
echo -------------------------------
echo Creating Laravel Blog Models and Controllers...
echo -------------------------------

:: Tạo folder Admin và Home nếu chưa có
if not exist "app\Http\Controllers\Admin" mkdir app\Http\Controllers\Admin
if not exist "app\Http\Controllers\Home" mkdir app\Http\Controllers\Home
:: Post,Category,Comment,Role,User,Tag,PostTag,Media,Setting,Page,Contact
:: --------- Admin ---------
php artisan make:model Post -m
php artisan make:controller Admin/PostController --resource --model=Post

php artisan make:model Category -m
php artisan make:controller Admin/CategoryController --resource --model=Category

php artisan make:model Comment -m
php artisan make:controller Admin/CommentController --resource --model=Comment

php artisan make:model Role -m
php artisan make:migration create_role_user_table --create=role_user

php artisan make:model User
php artisan make:controller Admin/UserController --resource --model=User

php artisan make:model Tag -m
php artisan make:controller Admin/TagController --resource --model=Tag

php artisan make:model PostTag -m

php artisan make:model Media -m
php artisan make:controller Admin/MediaController --resource --model=Media

php artisan make:model Setting -m
php artisan make:controller Admin/SettingController --resource --model=Setting

php artisan make:model Page -m
php artisan make:controller Admin/PageController --resource --model=Page

php artisan make:model Contact -m
php artisan make:controller Admin/ContactController --resource --model=Contact

:: --------- Home (frontend controller only) ---------
php artisan make:controller Home/HomeController

echo -------------------------------
echo All models, migrations, and controllers created!
echo -------------------------------
echo -------------------------------
echo Hay chuyen den 4_migrate_data.bat de chay migrate!
echo -------------------------------
goto END

:: -------------------------------
:UNDO
echo -------------------------------
echo Undo: Deleting Admin models, controllers, migrations...
echo -------------------------------
:: Rollback migrations
echo Rolling back migrations...
php artisan migrate:rollback
:: --------- Admin Controllers ---------
del /q "app\Http\Controllers\Admin\PostController.php"
del /q "app\Http\Controllers\Admin\CategoryController.php"
del /q "app\Http\Controllers\Admin\CommentController.php"
del /q "app\Http\Controllers\Admin\UserController.php"
del /q "app\Http\Controllers\Admin\TagController.php"
del /q "app\Http\Controllers\Admin\MediaController.php"
del /q "app\Http\Controllers\Admin\SettingController.php"
del /q "app\Http\Controllers\Admin\PageController.php"
del /q "app\Http\Controllers\Admin\ContactController.php"

:: --------- Admin Models ---------
del /q "app\Models\Post.php"
del /q "app\Models\Category.php"
del /q "app\Models\Comment.php"
del /q "app\Models\User.php"
del /q "app\Models\Role.php"
del /q "app\Models\Tag.php"
del /q "app\Models\PostTag.php"
del /q "app\Models\Media.php"
del /q "app\Models\Setting.php"
del /q "app\Models\Page.php"
del /q "app\Models\Contact.php"

:: --------- Migrations ---------
::for %%f in (database\migrations\*_create_*.php) do del /q "%%f"
:: --------- Migrations (chỉ blog, không xóa mặc định) ---------
echo Deleting blog-related migrations...
for %%f in (database\migrations\*_create_*.php) do (
    :: Lấy tên file
    set "fname=%%~nxf"
    :: Bỏ qua migration mặc định Laravel
    if /i not "%%~nxf"=="2014_10_12_000000_create_users_table.php" (
    if /i not "%%~nxf"=="2014_10_12_100000_create_password_reset_tokens_table.php" (
    if /i not "%%~nxf"=="2019_08_19_000000_create_failed_jobs_table.php" (
    if /i not "%%~nxf"=="2019_12_14_000001_create_personal_access_tokens_table.php" (
        del /f /q "%%f"
    ))))
)

echo -------------------------------
echo Undo completed!
echo -------------------------------
goto END

:END
pause
