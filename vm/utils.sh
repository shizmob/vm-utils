#!/bin/sh

resolve_includes() {
	local rootdir="$1"
	local conf="$(cat "$2")"
	local k
	local v
	test -z "$conf" && exit 1

	conf="$(printf "%s\n" "$conf" | sed -e '/^#/d' | sed -e '/^$/d')"
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
	        done | sed -e '/^#/d' -e '/^$/d')
	done

	echo "$conf"
}

expand() {
	local data="$1"
	local newline="$(printf '\n ')"
	newline=${newline% }
	eval "cat <<EOF${newline}${data}${newline}EOF"
}

rundir() {
	echo "/run/vm/$1"
}

pidfile() {
	echo "$(rundir "$1")/pid"
}

consolefile() {
	echo "$(rundir "$1")/console.sock"
}

virtiofsfile() {
	echo "$(rundir "$1")/virtiofs-$2.sock"
}

getpid() {
	local pidfile="$(pidfile "$1")"
	if test -f "$pidfile"; then
		pid="$(cat "$pidfile")"
		case "$(ps -p "$pid" -o comm 2>/dev/null | tail -n 1)" in
		qemu*|launch)
			echo "$pid"
			return 0
			;;
		esac
	fi
	return 1
}
