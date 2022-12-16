#!/bin/bash
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL E2IPLAYER_TSiplayer
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/E2IPLAYER_TSiplayer/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer'
SETTINGS='/etc/enigma2/settings'
URL='http://ipkinstall.ath.cx/ipk-install'
PYTHON_VERSION=$(python -c"import platform; print(platform.python_version())")

#########################
VERSION=$(wget $URL/E2IPLAYER-DREAMSATPANEL/e2iplayer.sh -qO- | grep 'versions=' | cut -d "=" -f2- | sed 's/^"\(.*\)".*/\1/')

########################
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#########################
if [ "$PYTHON_VERSION" == 3.9.9 ] || [ "$PYTHON_VERSION" == 3.9.7 ]; then
    echo ":You have Python3.9 image ..."
    PLUGINPY3='E2IPLAYER_TSiplayer-PYTHON3.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY3:?}"
elif [ "$PYTHON_VERSION" == 3.10.4 ]; then
    echo ":You have Python3.10 image ..."
    PLUGINPY4='E2IPLAYER_TSiplayer-PYTHON310.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY4:?}"
elif [ "$PYTHON_VERSION" == 3.11.0 ]; then
    echo ":You have $PYTHON_VERSION image ..."
    PLUGINPY5='E2IPLAYER_TSiplayer-PYTHON311.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY5:?}"
else
    echo ":You have Python2 image ..."
    PLUGINPY2='E2IPLAYER_TSiplayer.tar.gz'
    rm -rf ${TMPDIR}/"${PLUGINPY2:?}"
fi

#########################
case $(uname -m) in
armv7l*) plarform="armv7" ;;
mips*) plarform="mipsel" ;;
aarch64*) plarform="ARCH64" ;;
sh4*) plarform="sh4" ;;
esac

#########################
rm -rf ${PLUGINPATH}
rm -rf /etc/enigma2/iptvplaye*.json
rm -rf /etc/tsiplayer_xtream.conf
rm -rf /iptvplayer_rootfs

#########################
install() {
    if ! grep -qs "Package: $1" "$STATUS"; then
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Please Wait to install $1   <<<<"
        echo
        if [ "$OSTYPE" = "Opensource" ]; then
            $OPKGINSTAL "$1"
            sleep 1
            clear
        elif [ "$OSTYPE" = "DreamOS" ]; then
            $OPKGINSTAL "$1" -y
            sleep 1
            clear
        fi
    fi
}

#########################
if [ "$PYTHON_VERSION" == 3.9.9 ] || [ "$PYTHON_VERSION" == 3.9.7 ] || [ "$PYTHON_VERSION" == 3.10.4 ] || [ "$PYTHON_VERSION" == 3.11.0 ]; then
    for i in duktape python3-sqlite3; do
        install $i
    done
else
    for i in duktape python-sqlite3; do
        install $i
    done
fi

#########################
clear

echo "Downloading And Insallling IPTVPlayer plugin Please Wait ......"

if [ "$PYTHON_VERSION" == 3.9.9 ] || [ "$PYTHON_VERSION" == 3.9.7 ]; then
    set -e
    echo
    wget $URL/E2IPLAYER-DREAMSATPANEL/"$PLUGINPY3" -qP $TMPDIR
    tar -xzf $TMPDIR/"$PLUGINPY3" -C /
    set +e
elif [ "$PYTHON_VERSION" == 3.10.4 ]; then
    set -e
    echo
    wget $URL/E2IPLAYER-DREAMSATPANEL/"$PLUGINPY4" -qP $TMPDIR
    tar -xzf $TMPDIR/"$PLUGINPY4" -C /
    set +e
elif [ "$PYTHON_VERSION" == 3.11.0 ]; then
    set -e
    echo
    wget $URL/E2IPLAYER-DREAMSATPANEL/"$PLUGINPY5" -qP $TMPDIR
    tar -xzf $TMPDIR/"$PLUGINPY5" -C /
    set +e
else
    set -e
    echo
    wget $URL/E2IPLAYER-DREAMSATPANEL/"$PLUGINPY2" -qP $TMPDIR
    tar -xzf $TMPDIR/"$PLUGINPY2" -C /
    set +e
fi

#########################
if [ -d $PLUGINPATH ]; then
    echo ":Your Device IS $(uname -m) processor ..."
    echo "Add Setting To ${SETTINGS} ..."
    init 4
    sleep 5
    sed -e s/config.plugins.iptvplayer.*//g -i ${SETTINGS}
    sleep 2
    {
        echo "config.plugins.iptvplayer.AktualizacjaWmenu=false"
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
        echo "config.plugins.iptvplayer.alternative${plarform^^}MoviePlayer=extgstplayer"
        echo "config.plugins.iptvplayer.alternative${plarform^^}MoviePlayer0=extgstplayer"
        echo "config.plugins.iptvplayer.buforowanie_m3u8=false"
        echo "config.plugins.iptvplayer.default${plarform^^}MoviePlayer=exteplayer"
        echo "config.plugins.iptvplayer.default${plarform^^}MoviePlayer0=exteplayer"
        echo "config.plugins.iptvplayer.remember_last_position=true"
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
        echo "config.plugins.iptvplayer.extplayer_skin=red"
        echo "config.plugins.iptvplayer.plarform=${plarform}"
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
        echo "config.plugins.iptvplayer.wgetpath=wget"
    } >>${SETTINGS}
fi

#########################
if [ "$PYTHON_VERSION" == 3.9.9 ] || [ "$PYTHON_VERSION" == 3.9.7 ]; then
    rm -rf ${TMPDIR}/"${PLUGINPY3:?}"
elif [ "$PYTHON_VERSION" == 3.10.4 ]; then
    rm -rf ${TMPDIR}/"${PLUGINPY4:?}"
elif [ "$PYTHON_VERSION" == 3.11.0 ]; then
    rm -rf ${TMPDIR}/"${PLUGINPY5:?}"
else
    rm -rf ${TMPDIR}/"${PLUGINPY2:?}"
fi
sync
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       TSIPlayer  : $VERSION                      *"
echo "**                       Uploaded by: LINUXSAT                        *"
echo "**                       Script by  : MOHAMED_OS                      *"
echo "**                       Develop by : rgysoft                         *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/3951696/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""
if [ "$OSTYPE" = "DreamOS" ]; then
    sleep 2
    systemctl restart enigma2
else
    init 4
    sleep 2
    init 3
fi
exit 0
