@echo off
SetLocal EnableExtensions
SetLocal EnableDelayedExpansion
ver=14:57 2026/8/14
del /f hosts hosts.txt
call :del
call :lyq
call :winhosts
ping -n 3 127.0.0.1
call :del
exit

:del
del /f Version.txt rule.sed data.txt
goto :eof

:lyq
::合并data目录下数据
copy %cd%\data\*.txt data.txt
::删除#注释行
sed -i "/^#/d" data.txt
::删除@注释行
sed -i "/^@/d" data.txt
::删除最后一行
sed -i "$d" data.txt
::删除白名单已存在内容
sed "s/[][\.*^$/]/\\&/g; s/.*/\\@&@d/" white.txt > rule.sed
sed -i -f rule.sed data.txt
::写入注释
echo.>Version.txt
echo #version=%date:~0,4%%date:~5,2%%date:~8,2%%TIME:~0,2%%TIME:~3,2%>>Version.txt
echo #https://github.com/vokins/yhosts>>Version.txt
echo #https://raw.githubusercontent.com/vokins/yhosts/refs/heads/master/hosts>>Version.txt
set files=Version.txt data.txt
for %%a in (%files%) do (type "%%a">>hosts)
goto :eof

:winhosts
TAKEOWN /F %windir%\System32\drivers\etc >nul 2>nul
echo y|CACLS %windir%\system32\drivers\etc/t /C /p everyone:f >nul 2>nul
rem icacls "%windir%\System32\drivers\etc" /grant "NT AUTHORITY\NetworkService":RX
copy /y "hosts.txt" "%windir%\system32\drivers\etc\hosts"
ipconfig /flushdns
goto :eof
