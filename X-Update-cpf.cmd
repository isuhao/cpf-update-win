@echo off
set VERSION=3.17
set MD5SUM=FDD76DA87031B9BF07F0404DE20B986B
rem .
rem .	Chromium and Pepper Flash update script for winPenPack
rem .	(c) 2015 JustOff <Off.Just.Off@gmail.com>, licensed under MIT
rem .
rem .	Credits and Thanks:
rem .		Chromium Projects - http://www.chromium.org/
rem .		winPenPack Project - http://www.winpenpack.com/
rem . 		Google Chrome - https://www.google.com/chrome/
rem .		Adobe Flash Player - http://get.adobe.com/flashplayer/
rem .		Jerry "Woolyss" - http://chromium.woolyss.com/
rem .		Horst Schaeffer - http://www.horstmuc.de/
rem .		Igor Pavlov - http://www.7-zip.org/
rem .		Stephen Dolan - http://stedolan.github.io/jq/
rem .		Bart Puype - http://users.ugent.be/~bpuype/wget/
rem .		Dreamlikes - https://code.google.com/p/gnu-on-windows/
rem .		John Walker - https://www.fourmilab.ch/md5/
rem .
rem .	Installation:
rem .		1. Download and extract winPenPack X-Chromium package from
rem .		http://www.winpenpack.com/en/download.php?view.1082
rem .		2. Place this script next to X-Chromium.exe and X-Chromium.ini
rem .		3. Run script and follow the wizard to get all required
rem .		utilities from corresponding sites or download prepered archive
rem .		cpf-update-win-utils.zip from release page on GitHub at
rem .		https://github.com/JustOff/cpf-update-win/releases/latest
rem .		4. Save the executables from step 3 into "Update" folder
rem .
set TITLE=Chromium and Pepper Flash update for winPenPack
cd /d %~dp0 & title %TITLE%
if "%1"=="fork" goto fork
start %~nx0 fork
exit
:fork
if exist Update goto iswprompt
md Update
echo .
echo . Update utilities were not found :-(
echo .
echo . Visit https://github.com/JustOff/cpf-update-win/releases/latest
echo .
echo . Download cpf-update-win-utils.zip and extract to "Update" folder
echo .
pause
start https://github.com/JustOff/cpf-update-win/releases/latest
exit
:iswprompt
if exist Update\wprompt.exe goto iswbusy
echo .
echo . Wprompt.exe not found :-(
echo .
echo . Download it from http://www.horstmuc.de/w32dial.htm#wprompt
echo .
echo . and place it to "Update" folder alongside
echo .
pause
start http://www.horstmuc.de/w32dial.htm#wprompt
exit
:iswbusy
if exist Update\wbusy.exe goto iswget
Update\wprompt.exe "Wbusy.exe not found!" "Please download Wbusy.exe from^^http://www.horstmuc.de/w32dial.htm#wbusy^^and place it to Update folder alongside" Ok 1
start http://www.horstmuc.de/w32dial.htm#wbusy
exit
:iswget
if exist Update\wget.exe goto is7za
Update\wprompt.exe "wget.exe not found!" "Please download wget.exe from^^http://users.ugent.be/~bpuype/wget/^^and place it to Update folder alongside" Ok 1
start http://users.ugent.be/~bpuype/wget/
exit
:is7za
if exist Update\7za.exe goto isjq
Update\wprompt.exe "7za.exe not found!" "Please download 7-Zip Command Line Version from^^http://www.7-zip.org/download.html^^and place 7za.exe to Update folder alongside" Ok 1
start http://www.7-zip.org/download.html
exit
:isjq
if exist Update\jq.exe goto issed
Update\wprompt.exe "jq.exe not found!" "Please download jq.exe from^^http://stedolan.github.io/jq/download/^^and place it to Update folder alongside" Ok 1
start http://stedolan.github.io/jq/download/
exit
:issed
if exist Update\sed.exe goto ismd5
Update\wprompt.exe "sed.exe not found!" "Please download sed.exe from^^https://code.google.com/p/gnu-on-windows/downloads/list^^and place it to Update folder alongside" Ok 1
start https://code.google.com/p/gnu-on-windows/downloads/list
exit
:ismd5
if exist Update\md5.exe goto is32
Update\wprompt.exe "md5.exe not found!" "Please download md5.exe from^^https://www.fourmilab.ch/md5/^^and place it to Update folder alongside" Ok 1
start https://www.fourmilab.ch/md5/
exit
:is32
if not exist X-Chromium.ini goto is64
if not exist X-Chromium.exe goto noxch
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set SPFDIR=SysWOW64) else (set SPFDIR=system32)
set NSPFDIR=%SPFDIR%
set INI=X-Chromium
set WDIR=Win
set BIT=32
set ARCH=x86
set JSARCH=ia32
set CAP=
set SAP=
goto begin
:is64
if not exist X-Chromium-x64.ini goto noxch
if not exist X-Chromium-x64.exe goto noxch
set SPFDIR=system32
set NSPFDIR=sys
set NSPFDIR=%NSPFDIR%native
set INI=X-Chromium-x64
set WDIR=Win_x64
set BIT=64
set ARCH=x64
set JSARCH=x64
set CAP=ap=x64-canary
set SAP=x64-stable
goto begin
:noxch
Update\wprompt.exe "X-Chromium not found!" "The winPenPack X-Chromium package not found or broken!^^Reinstall it from http://www.winpenpack.com/en/download.php?view.1082" Ok 1
start http://www.winpenpack.com/en/download.php?view.1082
exit
:begin
set CPFUPD=https://raw.githubusercontent.com/JustOff/cpf-update-win/master/X-Update-cpf.cmd
set WOOLYSS="http://chromium.woolyss.com/api/?os=windows&bit=%BIT%"
set CHRURL=https://storage.googleapis.com/chromium-browser-snapshots/%WDIR%
set INSTALLER=mini_installer.exe
set AFLASH=http://www.adobe.com/software/flash/about/
cd Update
start wbusy.exe "Self Update" "Searching for script updates ..." /marquee
if exist "..\Temp" rmdir /S /Q ..\Temp
md ..\Temp
wget.exe -q --no-check-certificate %CPFUPD%?%RANDOM%^&%RANDOM% -O ..\Temp\UPDATE & title %TITLE%
if errorlevel 1 goto upderror
if not exist "..\Temp\UPDATE" goto upderror
for /F "delims=" %%i in ('sed.exe "/^set MD5SUM/!d;s/set MD5SUM=//" ..\Temp\UPDATE') do set MD5UPDATE=%%i
for /F "delims=" %%j in ('sed.exe "3d" ..\Temp\UPDATE ^| md5.exe -n') do set MD5CHECK=%%j
if "%MD5UPDATE%" NEQ "%MD5CHECK%" goto upderror
for /F "delims=" %%i in ('sed.exe "/^set VERSION/!d;s/set VERSION=//" ..\Temp\UPDATE') do set UPDATE=%%i
wbusy.exe "Self Update" /stop
if %UPDATE% LEQ %VERSION% goto checkchromium
wprompt.exe "Self Update" "New version of %~nx0 found!^ ^Current:  %VERSION%^Recent:   %UPDATE%^ ^Do you want to update?" OkCancel 1
if errorlevel 2 goto checkchromium
echo @echo off > ..\Temp\X-Self-cpf.cmd
echo wprompt.exe "Self Update" "%~nx0 ready to update from %VERSION% to %UPDATE%" Ok 1:2 >> ..\Temp\X-Self-cpf.cmd
echo copy /y ..\Temp\UPDATE ..\%~nx0 >> ..\Temp\X-Self-cpf.cmd
echo wprompt.exe "Self Update" "%~nx0 update complete!" Ok 1:3 >> ..\Temp\X-Self-cpf.cmd
echo start ..\X-Update-cpf.cmd ..\%~nx0 fork >> ..\Temp\X-Self-cpf.cmd
echo exit >> ..\Temp\X-Self-cpf.cmd
start ..\Temp\X-Self-cpf.cmd
exit
:upderror
wbusy.exe "Self Update" /stop
wprompt.exe "Self Update" "Script self update error^^Try to check again later ..." Ok 1:3
:checkchromium
start wbusy.exe "Chromium Update" "Searching for Chromium updates ..." /marquee
wget.exe -q --no-check-certificate --header="User-Agent: cpf-update-win %VERSION%"  %WOOLYSS% -O ..\Temp\LASTCHR & title %TITLE%
if errorlevel 1 goto serverror
if not exist "..\Temp\LASTCHR" goto serverror
for /F "tokens=1,2" %%i in ('jq.exe -r "[.chromium.windows.version, .chromium.windows.revision|tostring]|join(\" \")" ..\Temp\LASTCHR') do set CHRVER=%%i& set CHRREV=%%j
if not exist "..\Bin\VERSION" goto nolocal
for /F "tokens=1,2" %%i in ('jq.exe -r "[.chromium.windows.version, .chromium.windows.revision|tostring]|join(\" \")" ..\Bin\VERSION') do set LCHVER=%%i& set LCHREV=%%j
goto compare
:nolocal
for /F "delims=" %%i in ('sed.exe "/^Soft.Version/!d;s/Soft.Version=//" ..\%INI%.ini') do set LCHVER=%%i
if not exist "..\Bin\Chrome\chrome.exe" set LCHVER=undefined
set LCHREV=unknown
:compare
if "%CHRREV%"=="%LCHREV%" goto noupdate
wbusy.exe "Chromium Update" /stop
wprompt.exe "Chromium Update" "New Chromium build available!^ ^Current:  %LCHVER% (#%LCHREV%)^Recent:   %CHRVER% (#%CHRREV%)^ ^Do you want to update?" OkCancel 1
if errorlevel 2 goto checkflash
:download
start wbusy.exe "Chromium Update" "Downloading Chromium %CHRVER% (#%CHRREV%) ..." /marquee
wget.exe --no-check-certificate %CHRURL%/%CHRREV%/%INSTALLER% -O ..\Temp\chrome.zip & title %TITLE%
if errorlevel 1 goto serverror
wbusy.exe "Chromium Update" /stop
wprompt.exe "Chromium Update" "Chromium %CHRVER% (#%CHRREV%) downloaded!^ ^Do you want to install it?" OkCancel 1
if errorlevel 2 goto checkflash
:checkrun
if not exist "..\User\Chrome\Default" goto install
if exist "..\User\Chrome\chrome_shutdown_ms.txt" goto install
if not exist "..\User\Chrome\lockfile" goto install
wprompt.exe "Chromium Update" "Please close Chromium to install update!" OkCancel 1
if errorlevel 2 goto checkflash
goto checkrun
:install
start wbusy.exe "Chromium Update" "Installing Chromium %CHRVER% (#%CHRREV%) ..." /marquee
7za.exe x -y -t7z "..\Temp\chrome.zip" -o"..\Temp\"
if errorlevel 1 goto downloaderror
7za.exe x -y "..\Temp\chrome.7z" -o"..\Bin\"
if errorlevel 1 goto downloaderror
cd ..\Bin
if not exist Chrome-bin goto downloaderror
:checkrun2
ren Chrome Chrome-old
if not exist Chrome goto finish
..\Update\wprompt.exe "Chromium Update" "Please close Chromium to install update!" OkCancel 1
if errorlevel 2 goto stop
goto checkrun2
:finish
ren Chrome-bin Chrome
if not exist Chrome-bin goto end
..\Update\wprompt.exe "Chromium Update" "Waiting for directory lock ..." Ok 1:3
goto finish
:end
rmdir /S /Q Chrome-old
cd ..\Update
copy /y ..\Temp\LASTCHR ..\Bin\VERSION
set LCHVER=%CHRVER%
wbusy.exe "Chromium Update" /stop
wprompt.exe "Chromium Update" "Chromium %CHRVER% (#%CHRREV%) installed!" Ok
goto checkflash
:noupdate
wbusy.exe "Chromium Update" /stop
wprompt.exe "Chromium Update" "Latest Chromium %CHRVER% (#%CHRREV%) is already installed^ ^Do you want to reinstall it?" OkCancel 2
if errorlevel 2 goto checkflash
goto download
:serverror
wbusy.exe "Chromium Update" "Connection to server could not be established" /stop
goto checkflash
:downloaderror
if exist "..\Bin\Chrome-bin" rmdir /S /Q ..\Bin\Chrome-bin
wbusy.exe "Chromium Update" "Update package is damaged^Try to update again later" /stop
goto checkflash
:stop
..\Update\wbusy.exe "Chromium Update" /stop
:checkflash
if "%LCHVER%" LSS "43.0.2324.0" goto nosysflash
if not exist %WINDIR%\%SPFDIR%\Macromed\Flash\manifest.json goto nosysflash
for /F "delims=" %%j in ('jq.exe -r ".\"x-ppapi-arch\"" %WINDIR%\%NSPFDIR%\Macromed\Flash\manifest.json') do set SPFARCH=%%j
if "%SPFARCH%" NEQ "%JSARCH%" goto nosysflash
for /F "delims=" %%j in ('jq.exe -r ".version" %WINDIR%\%SPFDIR%\Macromed\Flash\manifest.json') do set SPFVER=%%j
dir /B %WINDIR%\%SPFDIR%\Macromed\Flash\pepflashplayer%BIT%*.dll 2>NUL | find /I /N "pepflashplayer%BIT%">NUL
if errorlevel 1 goto nosysflash
if exist "..\Flash" rmdir /S /Q ..\Flash
find /I /N "ppapi-flash-path" ../%INI%.ini>NUL
if "%ERRORLEVEL%"=="0" sed.exe -i "s/disk-cache-dir.*/disk-cache-dir=\"$Cache$\"/" ..\%INI%.ini
wprompt.exe "Flash Update" "Using System Pepper Flash %SPFVER%" Ok 1:2
goto quit
:nosysflash
start wbusy.exe "Flash Update" "Searching for Flash updates ..." /marquee
wget.exe -q --no-check-certificate %AFLASH% -O ..\Temp\AFLASH & title %TITLE%
if errorlevel 1 goto flashserverror
if not exist "..\Temp\AFLASH" goto flashserverror
for /F "delims=" %%i in ('sed.exe ":a;N;$!ba;s/.*Platform//;s/.*Windows//;s/Macintosh.*//;s/.*PPAPI//;s/<\/tr>.*//;s/.*<td>//;s/<\/td>.*//" ..\Temp\AFLASH') do set APFVER=%%i
if not exist "..\Flash\manifest.json" goto noflash
for /F "delims=" %%j in ('jq.exe -r ".version" ..\Flash\manifest.json') do set LPFVER=%%j
goto flashcompare
:noflash
set LPFVER=undefined
:flashcompare
if "%APFVER%"=="%LPFVER%" goto nofupd
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "New Flash available!^ ^Current:  %LPFVER%^Recent:   %APFVER%^ ^Do you want to update?" OkCancel 1
if errorlevel 2 goto quit
wget.exe --no-check-certificate --post-data "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request protocol=\"3.0\" ismachine=\"1\"><os version=\"6.1\" arch=\"%ARCH%\"/><app appid=\"{4EA16AC7-FD5A-47C3-875B-DBF4A2008C20}\" ap=\"%CAP%\"><updatecheck/></app></request>" http://tools.google.com/service/update2 -O ..\Temp\CANARY & title %TITLE%
if errorlevel 1 goto flashserverror
if not exist "..\Temp\CANARY" goto flashserverror
for /F "tokens=1,2" %%i in ('sed.exe "s/.*codebase=\"//^;s/\"\/.*name=\"//^;s/\".*Version=\"/ /^;s/\".*//" ..\Temp\CANARY') do set CANURL=%%i& set CANVER=%%j
start wbusy.exe "Flash Update" "Downloading Chrome Canary %CANVER% ..." /marquee
wget.exe --no-check-certificate %CANURL% -O ..\Temp\canary.zip & title %TITLE%
if errorlevel 1 goto flashserverror
start wbusy.exe "Flash Update" "Extracting Flash from Chrome Canary %CANVER% ..." /marquee
if exist "..\Temp\chrome.7z" del /F /Q ..\Temp\chrome.7z
7za.exe x -y -t7z ..\Temp\canary.zip -o"..\Temp"
if errorlevel 1 goto relflash
if exist Flash-new rmdir /S /Q Flash-new
7za.exe e -y ..\Temp\chrome.7z Chrome-bin\%CANVER%\PepperFlash\* -o"..\Flash-new\"
if errorlevel 1 goto flashdownerror
if not exist "..\Flash-new\manifest.json" goto flashdownerror
if not exist "..\Flash-new\pepflashplayer.dll" goto flashdownerror
for /F "delims=" %%j in ('jq.exe -r ".version" ..\Flash-new\manifest.json') do set NPFVER=%%j
if "%NPFVER%"=="%APFVER%" goto instflash
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "Flash from Chrome Canary - %NPFVER%,^while Adobe stable version - %APFVER%!^ ^Do you want to check Flash from Chrome Release?" OkCancel 1
if errorlevel 2 goto quit
:relflash
wget.exe --no-check-certificate --post-data "<?xml version=\"1.0\" encoding=\"UTF-8\"?><request protocol=\"3.0\" ismachine=\"1\"><os version=\"6.1\" arch=\"%ARCH%\"/><app appid=\"{8A69D345-D564-463C-AFF1-A69D9E530F96}\" ap=\"%SAP%\"><updatecheck/></app></request>" http://tools.google.com/service/update2 -O ..\Temp\REL & title %TITLE%
if errorlevel 1 goto flashserverror
if not exist "..\Temp\REL" goto flashserverror
for /F "tokens=1,2" %%i in ('sed.exe "s/.*codebase=\"//^;s/\"\/.*name=\"//^;s/\".*Version=\"/ /^;s/\".*//" ..\Temp\REL') do set RELURL=%%i& set RELVER=%%j
start wbusy.exe "Flash Update" "Downloading Chrome Release %RELVER% ..." /marquee
wget.exe --no-check-certificate %RELURL% -O ..\Temp\rel.zip & title %TITLE%
if errorlevel 1 goto flashserverror
start wbusy.exe "Flash Update" "Extracting Flash from Chrome Release %RELVER% ..." /marquee
if exist "..\Temp\chrome.7z" del /F /Q ..\Temp\chrome.7z
7za.exe x -y -t7z ..\Temp\rel.zip -o"..\Temp"
if errorlevel 1 goto flashdownerror
if exist Flash-new rmdir /S /Q Flash-new
7za.exe e -y ..\Temp\chrome.7z Chrome-bin\%RELVER%\PepperFlash\* -o"..\Flash-new\"
if errorlevel 1 goto flashdownerror
if not exist "..\Flash-new\manifest.json" goto flashdownerror
if not exist "..\Flash-new\pepflashplayer.dll" goto flashdownerror
for /F "delims=" %%j in ('jq.exe -r ".version" ..\Flash-new\manifest.json') do set NPFVER=%%j
if not "%NPFVER%"=="%APFVER%" goto nonewflash
:instflash
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "New flash %NPFVER% found in Chrome!^ ^Do you want to install it?" OkCancel 1
if errorlevel 2 goto quit
start wbusy.exe "Flash Update" "Installing Flash %NPFVER% ..." /marquee
cd ..
:checkrun3
if exist Flash ren Flash Flash-old
if not exist Flash goto flashfinish
Update\wprompt.exe "Flash Update" "Please close Chromium to update Flash!" OkCancel 1
if errorlevel 2 goto flashstop
goto checkrun3
:flashfinish
ren Flash-new Flash
if exist Flash-old rmdir /S /Q Flash-old
Update\sed.exe -i "s/disk-cache-dir.*/disk-cache-dir=\"$Cache$\" --ppapi-flash-path=\"$Root$\\Flash\\pepflashplayer.dll\" --ppapi-flash-version=%NPFVER%/" %INI%.ini
cd Update
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "Flash %NPFVER% installed!" Ok 1
goto quit
:nofupd
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "Latest Flash %LPFVER% is already installed" Ok 1
goto quit
:nonewflash
wbusy.exe "Flash Update" /stop
wprompt.exe "Flash Update" "No new Flash found in Chrome^ ^Try to check again later ..." Ok 1
goto quit
:flashdownerror
wbusy.exe "Flash Update" "Update package is damaged^Try to update again later" /stop
goto quit
:flashserverror
wbusy.exe "Flash Update" "Connection to server could not be established" /stop
goto quit
:flashstop
cd Update
wbusy.exe "Flash Update" /stop
:quit
if exist "..\Temp" rmdir /S /Q ..\Temp
if exist "..\Flash-new" rmdir /S /Q ..\Flash-new
cd ..
exit
