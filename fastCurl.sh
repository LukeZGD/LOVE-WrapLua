#Cache requests

filetype="lua"
if [[ "$1" != "" ]]; then
    filetype="$1"
    echo "Send .$1 files"
fi

find ./homebrew/ -name "*.$filetype" >> _tempFileRequests.txt
_files=""
_fileArr=()
while read -r _cache;
do _files+=${_cache}",";
_fileArr+=( $_cache )
done < _tempFileRequests.txt
_files=${_files%,}

find ./homebrew/ -type d >> _tempDirRequests.txt
_dirs=()

while read -r _cache;
do _dirs+=( ${_cache#./homebrew} );
done < _tempDirRequests.txt

for dir in ${_dirs[@]}; do
    # echo $dir
    _buf=""
    #Populate _buf with useful filees
    for _file in ${_fileArr[@]}; do
        if [[ $_file =~ "$dir" ]]; then
            if [[ $dir == "/" ]]; then
                if [[ `grep -o '/' <<< $_file | wc -l` == $(( `grep -o '/' <<< $dir | wc -l` + 1 )) ]]; then #Must be 2, because it already has /homebrew/
                    _buf+=${_file}","
                fi
            else
                if [[ `grep -o '/' <<< $_file | wc -l` == $(( `grep -o '/' <<< $dir | wc -l` + 2 )) ]]; then 
                    _buf+=${_file}","
                fi
            fi
        fi
    done
    #Clean for curl
    _buf=${_buf%,}

    if [[ $_buf != "" ]]; then
        if [[ $dir != "/" ]]; then
            dir+="/"
        fi
        echo $dir
        curl --ftp-create-dirs -T  "{$_buf}" ftp://192.168.15.19:1337/ux0:app/ONELUAHP0$dir
    fi
done

rm _tempFileRequests.txt
rm _tempDirRequests.txt

# echo $_files

#_dirsList=""

#To create multiple files request, they must be embraced with {}, have a ',' between each file
#and don't have any space between them

# curl --ftp-create-dirs -T "{$_files}" -X MKCOL ftp://192.168.15.19:1337/ux0:app/ONELUAHP0/
