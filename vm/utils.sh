#!/bin/sh

resolve_includes() {
	local rootdir="$1"
	local conf=$(cat "$2")
	local k
	local v
	test -z "$conf" && exit 1

	while test "${conf#*!include}" != "$conf" ; do
	        conf=$(printf "%s\n" "$conf" | while read -r k v; do
        	        case "$k" in
                	!include)
                        	local file=$(basename "$v")
	                        cat "$rootdir/$file"
        	                ;;
	                *)
        	                printf "%s %s\n" "$k" "$v"
	                        ;;
	                esac
	        done)
	done

	echo "$conf"
}

expand() {
	local data="$1"
	local newline="$(printf '\n ')"
	newline=${newline% }
	eval "cat <<EOF${newline}${data}${newline}"
}

read_conf() {
	local rootdir="$1"
	local file=$(basename "$2.conf")
	local conf=$(resolve_includes "$rootdir/conf" "$rootdir/conf/$file")
	local k
	local v

	while read -r k v ; do
	        eval "conf_$k=$v"
	done <<EOF
$conf
EOF
}
