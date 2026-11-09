@echo off
set ADB=C:\Users\Godchaser\AppData\Local\Android\Sdk\platform-tools\adb.exe
%ADB% devices > C:\Users\Godchaser\forge_moments\adb_out.txt 2>&1
%ADB% shell screencap /sdcard/fresh2.png >> C:\Users\Godchaser\forge_moments\adb_out.txt 2>&1
%ADB% pull /sdcard/fresh2.png C:\Users\Godchaser\forge_moments\fresh2.png >> C:\Users\Godchaser\forge_moments\adb_out.txt 2>&1
echo DONE >> C:\Users\Godchaser\forge_moments\adb_out.txt
