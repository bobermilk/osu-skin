@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion

if not exist "4K/resource/convert.exe" (
    echo Downloading utility to modify receptor images
    powershell.exe -nologo -Command "& {Invoke-WebRequest 'https://cdn.discordapp.com/attachments/1067041191134249012/1153856624646160404/convert.exe' -OutFile 4K/resource/convert.exe}"
)

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
echo Main:
echo     1. Rice notes flavors
echo     2. Noodle tail flavors
echo     3. Receptor hit position
echo     4. Judgement images
echo     5. Column width and spacing
echo/
echo Miscellanous:
echo     6. Rice notes coloration
echo     7. Theme (song selection, ranking panel, score font)
echo/

:ask
set /p "menu_choice=>> "
if "%menu_choice%" == "1" goto menu1
if "%menu_choice%" == "2" goto menu2
if "%menu_choice%" == "3" goto menu3
if "%menu_choice%" == "4" goto menu4
if "%menu_choice%" == "5" goto menu5
if "%menu_choice%" == "6" goto menu6
if "%menu_choice%" == "7" goto menu7
if "%menu_choice%" == "8" goto menu8

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
echo ################################
echo ### 3. Receptor hit position ###
echo ################################
echo/
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
echo boge: 430, sel: 460, kanemining: 480
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
echo ### 4. Judgement images ###
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
    copy "4K\flavors\judgements\!folder[%option%]!\%%f" "4K\current\judgements\%%f" /y
)
exit /B

:menu5
cls
echo ###############################
echo ### 5. Column width/spacing ###
echo ###############################
echo/
echo Examples:
echo/
echo     boge [default]: 70,70,70,70 and 0,0,0
echo     xvenn: 74,73,73,74 and 4,4,4
echo/
set /p "c1=Column 1 width >> "
set /p "c2=Column 2 width >> "
set /p "c3=Column 3 width >> "
set /p "c4=Column 4 width >> "
echo/
set /p "s1=Column 1,2 spacing >> "
set /p "s2=Column 2,3 spacing >> "
set /p "s3=Column 3,4 spacing >> "
echo/
echo Column width: %c1%,%c2%,%c3%,%c4%
echo Column spacing: %s1%,%s2%,%s3%
echo/
set /p "confirm=Press enter to confirm changes"
call :skin_ini_edit "ColumnWidth" "%c1%,%c2%,%c3%,%c4%"
call :skin_ini_edit "ColumnSpacing" "%s1%,%s2%,%s3%"
exit /B

echo     6. Rice notes coloration
echo     7. Receptor visibility
echo     8. Judgement position
:menu6
cls
echo ################################
echo ### 6. Rice notes coloration ###
echo ################################
powershell.exe -nologo -file "4K\resource\dep.ps1" "MY-PC"
echo/
echo Hue modification:
echo/
echo Using a red image:
echo     100 = cyan
echo     66 = green
echo     33 = yellow
echo     0 = no changes
echo     -33 = blue
echo     -66 = pink
echo     -100 = cyan
echo/
:q6-1
set /p "rice_hue=rice hue >> "
if %rice_hue% lss -100 (
    goto :q6-1
) else if %rice_hue% gtr 100 (
    goto :q6-1
)

:q6-2
set /p "noodle_hue=noodle hue >> "
if %noodle_hue% lss -100 (
    goto :q6-2
) else if %noodle_hue% gtr 100 (
    goto :q6-2
)

set /a rice_hue=%rice_hue%+100
set /a noodle_hue=%noodle_hue%+100

set /p "confirm=Press enter to confirm changes"

for /l %%i in (1,1,4) do (
    "4K\resource\convert.exe" "4K\current\rice_%%i.png" -modulate 100,100,%rice_hue% "4K\current\rice_%%i.png"
    "4K\resource\convert.exe" "4K\current\noodle_%%i.png" -modulate 100,100,%noodle_hue% "4K\current\noodle_%%i.png"
)

exit /B


:menu7
cls
echo ###########################
echo ### 7. Ranking Panel UI ###
echo ###########################
echo/
echo What flavor would you like?
echo/
set i=0
set folder[0]=..
for /D %%d in (4K/flavors/misc/ranking_panel/*) do (
    set /A i+=1
    set folder[!i!]=%%d
    echo     !i!: %%d
)
echo/
set /p "option=>> "

echo "You have selected !folder[%option%]!"
:: delete the previous stuff
if exist mania-hit*.png del mania-hit*.png
if exist ranking-panel.png del ranking-panel.png
if exist ranking-panel@2x.png del ranking-panel@2x.png
 
:: copy the selected ranking_panel
for /f %%f in ('dir /b "4K\flavors\misc\ranking_panel\!folder[%option%]!\"') do (
    copy "4K\flavors\misc\ranking_panel\!folder[%option%]!\%%f" .
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
