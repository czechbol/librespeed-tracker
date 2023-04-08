#!/bin/sh

PUID=${PUID:-9999}
PGID=${PGID:-9999}

if [[ $PUID != 9999 ]]; then
    
    # Change the group ID
    groupmod -o -g "$PGID" runner
fi
if [[ $PGID != 9999 ]]; then
    # Change the User ID
    usermod -o -u "$PUID" runner
fi

# Make sure the config directory is updated with the proper UID & GID
chown -R runner:runner /config

echo "  _ _ _                                _     _               _           ";
echo " | (_) |__ _ _ ___ ____ __  ___ ___ __| |___| |_ _ _ __ _ __| |_____ _ _ ";
echo " | | | '_ \ '_/ -_|_-< '_ \/ -_) -_) _\` |___|  _| '_/ _\` / _| / / -_) '_|";
echo " |_|_|_.__/_| \___/__/ .__/\___\___\__,_|    \__|_| \__,_\__|_\_\___|_|  ";
echo "                     |_|                                                 ";

echo '
To support Librespeed Tracker visit:
https://github.com/czechbol/librespeed-tracker
-------------------------------------
GID/UID
-------------------------------------'
echo "
User uid:    $(id -u runner)
User gid:    $(id -g runner)
-------------------------------------
"

if [ -z "${TZ}" ]; then
    echo "TZ is not set, using UTC instead"
    ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime && echo $TZ > /etc/timezone
else
    echo "Setting timezone to: $TZ"
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

# start serving the webserver here, running a single test instead
sudo -u runner /run_test.sh
