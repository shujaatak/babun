#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

# fix symlinks on local instance
/bin/dos2unix.exe /etc/postinstall/symlinks_repair.sh

/bin/chmod 755 /etc/postinstall/symlinks_repair.sh
/etc/postinstall/symlinks_repair.sh
/bin/mv.exe /etc/postinstall/symlinks_repair.sh /etc/postinstall/symlinks_repair.sh.done

# regenerate user/group information
/bin/rm -rf -- /home

echo "[babun] HOME set to $HOME"

if [[ ! "$HOME" == /cygdrive* ]]; then
    echo "[babun] Running mkpasswd for CYGWIN home"
    # regenerate users' info
    /bin/mkpasswd -l -c > /etc/passwd
else
    echo "[babun] Running mkpasswd for WINDOWS home"
    # regenerate users' info using windows paths
    /bin/mkpasswd -l -c -p "$(/bin/cygpath -H)" > /etc/passwd
fi
/bin/mkgroup -l -c > /etc/group

# fix file permissions in /usr/local
/bin/chmod 755 -R /usr/local
/bin/chmod u+rwx -R /etc
