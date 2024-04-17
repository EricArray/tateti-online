#!/bin/sh
echo -ne '\033c\033]0;online-ta-te-ti\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/tateti-dedicated-server.x86_64" "$@"
