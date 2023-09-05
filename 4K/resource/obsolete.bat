@ECHO off
cls
:start
ECHO What flavor would you like?
ECHO.
ECHO 1. sel/nepjin
ECHO 2. mysteryL
ECHO 3. mysteryL
ECHO 4. dyssodia
ECHO 5. jkzu
ECHO 6. CPK
ECHO 7. niflox
ECHO 8. xvenn
ECHO 9. crewk
ECHO 10. outline

rem allow more than 9 options for user input
@set userinp=%userinp:~0,2%

set choice=
set /p choice=Type the number corresponding to your choice: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto 1
if '%choice%'=='2' goto 2
if '%choice%'=='3' goto 3
if '%choice%'=='4' goto 4
if '%choice%'=='5' goto 5
if '%choice%'=='6' goto 6
if '%choice%'=='7' goto 7
if '%choice%'=='8' goto 8
if '%choice%'=='9' goto 9
if '%choice%'=='10' goto 10
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:1
set location="flavors\sel-nepjin\*.png"
goto end
:2
set location="flavors\mysteryL\*.png"
goto end
:3
set location="flavors\mysteryL_outlineless\*.png"
goto end
:4
set location="flavors\dyssodia\*.png"
goto end
:5
set location="flavors\jkzu\*.png"
goto end
:6
set location="flavors\CPK\*.png"
goto end
:7
set location="flavors\niflox\*.png"
goto end
:8
set location="flavors\xvenn\*.png"
goto end
:9
set location="flavors\crewk\*.png"
goto end
:10
set location="flavors\outline\*.png"
goto end
:end
xcopy %1 %location% /Y
