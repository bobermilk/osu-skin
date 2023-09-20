@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion

:: Customize Window
title osu! skin wizard

:: Greetings
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set "tim=%%I"
set "tim=%tim:~8,4%"
if "%tim%" geq "20" echo Good Night, %username% :)?&goto :done
if "%tim%" geq "18" echo Good Evening, %username% :3&goto :done
if "%tim%" geq "12" echo Good Afternoon, %username% :P&goto :done
if "%tim%" geq "06" echo Good Morning, %username% :O&goto :done
:done

echo/
echo What would you like to customize?
echo/
:: Main menu options
echo     1. Rice notes flavors
echo     2. Noodle tail flavors
echo     3. Hit position
echo     4. Column width/spacing (wip)
echo     5. Rice notes aspect ratio (wip)
echo     6. Judgement images
echo/

:ask
set /p "menu_choice=>> "
if "%menu_choice%" == "1" goto menu1
if "%menu_choice%" == "2" goto menu2
if "%menu_choice%" == "3" goto menu3
if "%menu_choice%" == "6" goto menu6

:: invalid selection
goto ask

:menu1
cls
echo #############################
echo ### 1. Rice notes flavors ###
echo #############################
echo/
echo What flavor would you like?
echo/
set i=0
set folder[0]=..
echo Circle:
for /D %%d in (4K/flavors/rice/circle/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
set circle_cnt=!i!
echo/
echo Diamond:
for /D %%d in (4K/flavors/rice/diamond/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
set diamond_cnt=!i!
echo/
echo Arrow:
for /D %%d in (4K/flavors/rice/arrow/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
set arrow_cnt=!i!
echo/
:q1
set /p "option=>> "
if %option% leq 0 (
    goto q1
) else if %option% leq %circle_cnt% (
    set note_type=circle
) else if %option% leq %diamond_cnt% (
    set note_type=diamond
) else if %option% leq %arrow_cnt% (
    set note_type=arrow
) else (
    goto q1
)
echo/
echo "You have selected %note_type%: !folder[%option%]!"

:: copy the selected flavor assets
for /l %%i in (1,1,4) do (
    :: (noodle tail will also be replaced to match the selected flavor)
    :: stock receptors are at 460
    xcopy "4K\flavors\receptors\!note_type!\Receptor_%%i.png" "4K\current\misc\Receptor_%%i.png*" /Y
    xcopy "4K\flavors\receptors\!note_type!\Receptor_Tapped_%%i.png" "4K\current\misc\Receptor_Tapped_%%i.png*" /Y
    xcopy "4K\flavors\rice\!note_type!\!folder[%option%]!\rice_%%i.png" "4K\current\rice_%%i.png*" /Y
    xcopy "4K\flavors\rice\!note_type!\!folder[%option%]!\noodle_%%i.png" "4K\current\noodle_%%i.png*" /Y
)
xcopy "4K\flavors\noodles\!note_type!\noodle_body.png" "4K\current\noodle_body.png*" /Y
xcopy "4K\flavors\noodles\!note_type!\noodle_tail.png" "4K\current\noodle_tail.png*" /Y

call :skin_ini_edit "HitPosition" 460

exit /B

:menu2
cls
echo ##############################
echo ### 2. Noodle tail flavors ###
echo ##############################
echo/
echo What noodle tail would you like?
set i=0
set folder[0]=..
for /D %%d in (4K/flavors/noodles/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
echo/
:q2
set /p "option=>> "
if %option% leq 0 (
    goto q2
) else if not %option% leq %i% (
    goto q2
)

echo "You have selected !folder[%option%]!"
:: copy the selected flavor assets
xcopy "4K\flavors\noodles\!folder[%option%]!\noodle_body.png" "4K\current\noodle_body.png*" /Y
xcopy "4K\flavors\noodles\!folder[%option%]!\noodle_tail.png" "4K\current\noodle_tail.png*" /Y

exit /B

:menu3
cls
echo #######################
echo ### 3. Hit position ###
echo #######################
echo/
powershell.exe -nologo -file "4K\resource\dep.ps1" "MY-PC"
echo What receptor would you like?
set i=0
set folder[0]=..
for /D %%d in (4K/flavors/receptors/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
echo/
:q3-1
set /p "option=>> "
if %option% leq 0 (
    goto q3-1
) else if not %option% leq %i% (
    echo %option%
    goto q3-1
)

echo "You have selected !folder[%option%]!"
echo/
echo ===========================================================
echo/
echo What hit position would you like (400-480, increments of 5)
echo boge: 430, sel: 460/463, kanemining: 481
echo/
:q3-2
set /p "hitpos=>> "
set /a remainder = %hitpos% %% 5
if %hitpos% lss 400 (
    goto q3-2
) else if %hitpos% gtr 480 (
    goto q3-2
) else if not %remainder% == 0 (
    goto q3-2
)
:: copy the receptors
for /l %%i in (1,1,4) do (
    xcopy "4K\flavors\receptors\!folder[%option%]!\Receptor_%%i.png" "4K\current\misc\Receptor_%%i.png*" /Y
    xcopy "4K\flavors\receptors\!folder[%option%]!\Receptor_Tapped_%%i.png" "4K\current\misc\Receptor_Tapped_%%i.png*" /Y
)
set /a offset=((%hitpos%-460)/5)*8
for /l %%i in (1,1,4) do (
    "4K\resource\convert.exe" "4K\current\misc\Receptor_%%i.png" -page +0+%offset% -background none -flatten "4K\current\misc\Receptor_%%i.png"
    "4K\resource\convert.exe" "4K\current\misc\Receptor_Tapped_%%i.png" -page +0+%offset% -background none -flatten "4K\current\misc\Receptor_Tapped_%%i.png"
)
call :skin_ini_edit "HitPosition" %hitpos%
exit /B

:menu4
cls
echo ###########################
echo ### 6. Judgement images ###
echo ###########################
echo/
echo What flavor would you like?
echo/
set i=0
set folder[0]=..
for /D %%d in (4K/flavors/judgements/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
echo/
:q3-1
set /p "option=>> "
if %option% leq 0 (
    goto q3-1
) else if not %option% leq %i% (
    echo %option%
    goto q3-1
)

echo "You have selected !folder[%option%]!"
:: copy the selected judgements
for /f %%f in ('dir /b "4K\flavors\judgements\!folder[%option%]!\"') do (
    xcopy "4K\flavors\judgements\!folder[%option%]!\%%f" "4K\current\judgements\%%f" /Y
)
exit /B


:: utilities

:skin_ini_edit
:: jrepl usage reference https://stackoverflow.com/questions/18871870/batch-file-to-edit-an-ini
set file="skin.ini"
set arg1=%~1
set arg2=%~2
type "%file%"| call 4K/resource/JREPL "^%arg1%.*" "%arg1%: %arg2%" >"%file%.tmp"
move "%file%.tmp" "%file%" >nul