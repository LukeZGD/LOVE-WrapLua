_type=".ogg"

if [[ "$1" != "" ]]; then
    _type=".$1"
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
    rm "$FILE"
done < _audioToConvert.txt
rm _audioToConvert.txt