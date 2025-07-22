"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

:: 设置变量
set QT_VERSION=5.15.17
set QT_URL=https://qt.mirror.constant.com/archive/qt/5.15/%QT_VERSION%/single/qt-everywhere-opensource-src-%QT_VERSION%.zip
set QT_ZIP=qt-everywhere-opensource-src-%QT_VERSION%.zip
set QT_SRC_DIR=qtsrc

:: 从https://qt.mirror.constant.com/archive/qt/5.15/5.15.17/single/qt-everywhere-opensource-src-5.15.17.zip下载并解压到qtsrc目录
echo Downloading Qt %QT_VERSION% source code...

:: 检查qtsrc目录是否存在，如果存在则跳过下载
if exist "%QT_SRC_DIR%" (
    echo Qt source directory already exists, skipping download...
    goto build_start
)

:: 下载Qt源码
echo Downloading from %QT_URL%...
powershell -Command "Invoke-WebRequest -Uri '%QT_URL%' -OutFile '%QT_ZIP%'"
if not %errorlevel%==0 (
    echo "Download failed"
    exit /b %errorlevel%
)

:: 创建qtsrc目录
mkdir "%QT_SRC_DIR%"

:: 解压zip文件到qtsrc目录
echo Extracting Qt source code...
powershell -Command "Expand-Archive -Path '%QT_ZIP%' -DestinationPath '%QT_SRC_DIR%' -Force"
if not %errorlevel%==0 (
    echo "Extract failed"
    exit /b %errorlevel%
)

:build_start

mkdir build
cd build

echo y | %QT_SRC_DIR%/configure -prefix ../out -shared -release -nomake examples -nomake tests -skip qtwebengine ^
-opensource -platform win64-msvc -no-compile-examples -mp
:: -force-debug-info
if not %errorlevel%==0 (
    echo "configure failed"
    exit /b %errorlevel%
)

../jom.exe
if not %errorlevel%==0 (
    echo "build failed"
    exit /b %errorlevel%
)

../jom.exe install

