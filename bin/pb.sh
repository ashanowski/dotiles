#!/bin/sh
# script for https://ptpb.pw/

######## conf ########

cache_dir="$HOME/.cache/pb"
curl_args='-s'
# dmenu/peco/iomenu/fzf
browse="dmenu"

######## conf ########

upload() {
	# upload and catch output
	output="$(curl -F "c=@$in" $curl_args "https://ptpb.pw/$adress")"

	if printf "%s\n" "$output" | grep 'status: already exists'; then exit 1; fi
	if printf "%s\n" "$output" | grep 'status: no post content'; then exit 1; fi
	[ ! -d "$cache_dir" ] && mkdir -p  "$cache_dir"
	if [ "$in" = "-" ]; then
		file_name="pipe_$(date +%d_%m_%y-%H-%M-%S)"
	else
		file_name="$(basename "$in")"
		[ -f "$cache_dir/$file_name" ] && file_name=""$file_name"_$(date +%d_%m_%y-%H-%M-%S)"
	fi
	printf "%s\n" "$output" | tee "$cache_dir/$file_name"
}

delete() {
	curl -X DELETE https://ptpb.pw/"$uuid"
	[ -f "$cache_file" ] && rm -i "$cache_file"
}

if [ ! -t 0 ]; then
	in="-"
elif [ -z "$1" ]; then
	exit 1
else
	if [ "$1" = "-d" ]; then
		if [ -z "$2" ]; then
			cache_file="$(find "$cache_dir" -type f | $browse)"
			uuid="$(awk '/uuid/' "$cache_file" | awk '{ print $2 }')"
		else
			uuid="$2"
			cache_file="$(grep -l "$uuid" "$cache_dir"/*)"
		fi
		delete
		exit
	fi

	[ -f "$1" ] && in="$1" || { printf "%s\n" "no such file $1"; exit 1; }
	shift
fi


while true; do
	case "$1" in
		-p)
			curl_args="$curl_args -F p=1"; shift
			;;
		-t)
			[ -z "$2" ] && { printf "%s\n" "you must provide time"; exit; }
			curl_args="$curl_args -F sunset=$2"; shift 2
			;;
		-n)
			[ -z "$2" ] && { printf "%s\n" "you must provide paste name"; exit; }
			adress="~$2"; shift 2
			;;
		--)
			shift; break
			;;
		*)
			break
			;;
	esac
done

upload

