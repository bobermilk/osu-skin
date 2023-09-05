@echo off

setlocal EnableDelayedExpansion
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
:getOption
set option=0+
set /P "option=Type the number corresponding to your choice: "
set note_type
echo %note_type%
if %option% gtr %i% (
    goto getOption
) else if %option% leq %circle_cnt% (
    set note_type=circle
) else if %option% leq %diamond_cnt% (
    set note_type=diamond
) else if %option% leq %arrow_cnt% (
    set note_type=arrow
)
echo %note_type%
echo "You have selected !folder[%option%]!"

rem copy the selected flavor assets
for /l %%i in (1,1,4) do (
    xcopy "4K\flavors\receptors\!note_type!\Receptor_%%i.png" "4K\current\misc\Receptor_%%i.png*" /Y
    xcopy "4K\flavors\receptors\!note_type!\Receptor_Tapped_%%i.png" "4K\current\misc\Receptor_Tapped_%%i.png*" /Y
    xcopy "4K\flavors\rice\!note_type!\!folder[%option%]!\rice_%%i.png" "4K\current\rice_%%i.png*" /Y
    xcopy "4K\flavors\rice\!note_type!\!folder[%option%]!\noodle_%%i.png" "4K\current\noodle_%%i.png*" /Y
)
xcopy "4K\flavors\noodles\!note_type!\noodle_body.png" "4K\current\noodle_body.png*" /Y
xcopy "4K\flavors\noodles\!note_type!\noodle_tail.png" "4K\current\noodle_tail.png*" /Y

exit /B
