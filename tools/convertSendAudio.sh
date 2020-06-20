_type="mp3"

if [[ "$1" != "" ]]; then
    _type="$1"
fi
./convertAudio.sh "$_type"
./fastCurl.sh "$_type"
