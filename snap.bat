@echo off
set ADB=C:\Users\Godchaser\AppData\Local\Android\Sdk\platform-tools\adb.exe
%ADB% kill-server
%ADB% start-server
%ADB% shell am force-stop com.example.forge_moments
timeout /t 2 /nobreak >nul
%ADB% shell am start -n com.example.forge_moments/.MainActivity
timeout /t 5 /nobreak >nul
%ADB% shell screencap /sdcard/fresh.png
%ADB% pull /sdcard/fresh.png C:\Users\Godchaser\forge_moments\fresh.png
echo DONE
