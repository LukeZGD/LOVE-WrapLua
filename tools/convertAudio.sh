_rate="44100"
_type=".ogg"
_force=true
_channels=1

if [[ "$1" != "" ]]; then
    _type=".$1"
fi

_sox=$( command -v sox)
if [[ "$_sox" == "" ]]; then
    currCommand=$( command -v zenity)
    if [[ "$currCommand" != "" ]]; then
        zenity --error --text="Please download SoX ( http://sox.sourceforge.net/ ) before using the convertAudio.sh"
    else
        currCommand=$( command -v notify-send)
        if [[ "$currCommand" != "" ]]; then
            notify-send -u critical "SoX Not Found" "Please download SoX ( http://sox.sourceforge.net/ ) before using the convertAudio.sh"
        else
            currCommand=$( command -v zenity)
            if [[ "$currCommand" != "" ]]; then
                kdialog --title "SoX Not Found " --passivepopup "Please download SoX ( http://sox.sourceforge.net/ ) before using the convertAudio.sh" 5
            fi
        fi
    fi
    echo "Please download SoX ( http://sox.sourceforge.net/ ) before using the convertAudio.sh"
    exit -1
fi

find ./homebrew/ -type f \( -iname \*.wav -o -iname \*.wma -o -iname \*.m4a -o -iname \*.3gp \) >> _audioToConvert.txt
while read -r currAudio; do
    IFS="."
    read -ra SPLITTED <<< "$currAudio"
    FILE="."
    len="${#SPLITTED[@]}"
    for (( i = 0; i < $len - 1; i++ )); do
        FILE+="${SPLITTED[$i]}"
    done
    FILE+=$_type
    if [[ ! -f "$FILE"  || "$_force" = true ]]; then
        sox "$currAudio" "$FILE" rate $_rate
        echo "Created $FILE"
    fi
done < _audioToConvert.txt
rm _audioToConvert.txt