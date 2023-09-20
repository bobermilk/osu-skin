if (!(Test-Path "4K/resource/convert.exe")){
    echo "Downloading utility to modify receptor images"
	Invoke-WebRequest "https://cdn.discordapp.com/attachments/1067041191134249012/1153856624646160404/convert.exe" -OutFile 4K/resource/convert.exe
	Invoke-WebRequest "https://cdn.discordapp.com/attachments/1067041191134249012/1153967370562445392/colors.xml" -OutFile 4K/resource/colors.xml
	echo ""
}
if (!(Test-Path "4K/resource/JREPL.BAT")){
    echo "Downloading utility to modify skin.ini"
	Invoke-WebRequest "https://cdn.discordapp.com/attachments/1067041191134249012/1153967281592860722/JREPL.BAT" -OutFile 4K/resource/JREPL.BAT
}