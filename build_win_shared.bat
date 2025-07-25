@echo off
echo start....

:: 设置变量
set QT_VERSION=5.15.17
set QT_URL=https://qt.mirror.constant.com/archive/qt/5.15/%QT_VERSION%/single/qt-everywhere-opensource-src-%QT_VERSION%.zip
set QT_ZIP=qt-everywhere-opensource-src-%QT_VERSION%.zip
set QT_SRC_DIR=qt-everywhere-opensource-src-%QT_VERSION%/qt-everywhere-src-%QT_VERSION%

:: QT_ZIP存在直接跳转到:build_start
if exist "%QT_ZIP%" ( 
    goto build_start
)

:: 从https://qt.mirror.constant.com/archive/qt/5.15/5.15.17/single/qt-everywhere-opensource-src-5.15.17.zip下载并解压到qtsrc目录
echo Downloading Qt %QT_VERSION% source code...

:: 下载Qt源码
echo Downloading from %QT_URL%...
powershell -Command "Invoke-WebRequest -Uri '%QT_URL%' -OutFile '%QT_ZIP%'"
if not %errorlevel%==0 (
    echo "Download failed"
    exit /b %errorlevel%
)

:: 解压zip文件
echo Extracting Qt source code...
powershell -Command "Expand-Archive -Path '%QT_ZIP%' -Force"
if not %errorlevel%==0 (
    echo "Extract failed"
    exit /b %errorlevel%
)

:build_start

mkdir build
cd build

echo Run configure
echo y | "../%QT_SRC_DIR%/configure" -prefix ../out-shared -shared -release -nomake examples -nomake tests -skip qtwebengine ^
-opensource -platform win32-msvc -no-compile-examples -mp
:: -force-debug-info
if not %errorlevel%==0 (
    echo "configure failed"
    exit /b %errorlevel%
)

echo Run build
"../jom.exe"
if not %errorlevel%==0 (
    echo "build failed"
    exit /b %errorlevel%
)

echo Run install
"../jom.exe" install

