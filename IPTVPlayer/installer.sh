#!/bin/sh
#####################################
# wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/installer.sh -qO - | /bin/sh

###########################################
# Configure where we can find things here #
DUKTAPE='duktape'
PY3SQLITE='python3-sqlite3'
PY2SQLITE='python-sqlite3'
TMPDIR='/tmp'
CHECK='/tmp/check'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer'

######################
# Delete File In TMP #

rm -rf /usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer
rm -rf /etc/enigma2/iptvplayerarabicgroup.json
rm -rf /etc/enigma2/iptvplayerenglishgroup.json
rm -rf /etc/enigma2/iptvplayerhostsgroups.json
rm -rf /etc/enigma2/iptvplayertsiplayercgroup.json
rm -rf /etc/tsiplayer_xtream.conf
rm -rf /iptvplayer_rootfs

####################
#  Image Checking  #
if [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
elif [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
fi

if [ $OSTYPE = "Opensource" ]; then
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
else
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#####################
# Package Checking  #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: $DUKTAPE" $STATUS ; then
        echo ""
        echo "$DUKTAPE Depends Are Installed..."
        sleep 2; clear
    else
        clear ;echo ""
        echo "Some Depends Need to Be downloaded From Feeds ...."
        if [ $OSTYPE = "Opensource" ]; then
            echo ""
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE
            echo "" ;clear
        elif [ $OSTYPE = "DreamOS" ]; then
            echo "APT Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE -y
        fi
    fi
else
    if grep -qs "Package: $DUKTAPE" $STATUS ; then
        echo ""
        echo "$DUKTAPE Depends Are Installed..."
        sleep 2; clear
    else
        clear ;echo ""
        echo "Some Depends Need to Be downloaded From Feeds ...."
        if [ $OSTYPE = "Opensource" ]; then
            echo ""
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE
            echo "" ;clear
        elif [ $OSTYPE = "DreamOS" ]; then
            echo "APT Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE -y
        fi
    fi

fi

#################

if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: $PY3SQLITE" $STATUS ; then
        echo ""
        echo "$PY3SQLITE Depends Are Installed..."
        sleep 2; clear
    else
        clear ;echo ""
        echo "Some Depends Need to Be downloaded From Feeds ...."
        if [ $OSTYPE = "Opensource" ]; then
            echo ""
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $PY3SQLITE ......"
            $OPKGINSTAL $PY3SQLITE
            echo "" ;clear
        fi
    fi
else
    if grep -qs "Package: $PY2SQLITE" $STATUS ; then
        echo ""
        echo "$PY2SQLITE Depends Are Installed..."
        sleep 2; clear
    else
        clear ;echo ""
        echo "Some Depends Need to Be downloaded From Feeds ...."
        if [ $OSTYPE = "Opensource" ]; then
            echo ""
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1 ;clear
            echo " Downloading $PY2SQLITE ......"
            $OPKGINSTAL $PY2SQLITE
            echo "" ;clear
        fi
    fi

fi

echo ""
cd $TMPDIR
###############################
# Downlaod And Install Plugin #

if python --version 2>&1 | grep -q '^Python 3\.'; then
    set -e
    echo "Downloading And Insallling IPTVPlayer plugin Please Wait ......"
    echo
    wget "http://ipkinstall.ath.cx/ipk-install/E2IPLAYER+TSIPLAYER-PYTHON3/E2IPLAYER_TSiplayer-PYTHON3.tar.gz" -q --show-progress
    tar -xzf E2IPLAYER_TSiplayer-PYTHON3.tar.gz -C /
    set +e
    rm -f E2IPLAYER_TSiplayer-PYTHON3.tar.gz
    echo "checking your device Arch ....."
    uname -m > $CHECK
    sleep 1;
    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=armv7" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=mipsel" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'aarch64' cat $CHECK ; then
        echo ':Your Device IS AARCH64 processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=ARCH64" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'sh4' cat $CHECK ; then
        echo ':Your Device IS SH4 processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultSH4MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultSH4MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=sh4" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings

    fi

    cd ..
    sync
    echo "#########################################################"
    echo "#          IPTVPlayer INSTALLED SUCCESSFULLY            #"
    echo "#                BY LINUXSAT - support on               #"
    echo "#   https://www.tunisia-sat.com/forums/threads/4029331/ #"
    echo "#########################################################"
    echo "#           your Device will RESTART Now                #"
    echo "#########################################################"
    sleep 2
    if which systemctl > /dev/null 2>&1; then
        sleep 2; systemctl restart enigma2
    else
        init 4; sleep 2; init 3;
    fi
else
    set -e
    echo "Downloading And Insallling IPTVPlayer plugin Please Wait ......"
    echo
    wget "http://ipkinstall.ath.cx/ipk-install/E2IPLAYER+TSIPLAYER/E2IPLAYER_TSiplayer.tar.gz" -q --show-progress
    tar -xzf E2IPLAYER_TSiplayer.tar.gz -C /
    set +e
    rm -f E2IPLAYER_TSiplayer.tar.gz
    echo "checking your device Arch ....."
    uname -m > $CHECK
    sleep 1;
    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=armv7" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=mipsel" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'aarch64' cat $CHECK ; then
        echo ':Your Device IS AARCH64 processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=ARCH64" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings
    elif grep -qs -i 'sh4' cat $CHECK ; then
        echo ':Your Device IS SH4 processor ...'
        echo "Add Setting To /etc/enigma2/settings ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' /etc/enigma2/settings
        sleep 2
        echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer0=extgstplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultSH4MoviePlayer=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.defaultSH4MoviePlayer0=exteplayer" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.remember_last_position=true" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.extplayer_skin=red" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.plarform=sh4" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk" >> /etc/enigma2/settings
        echo "config.plugins.iptvplayer.wgetpath=wget" >> /etc/enigma2/settings

    fi

    cd ..
    sync
    echo "#########################################################"
    echo "#          IPTVPlayer INSTALLED SUCCESSFULLY            #"
    echo "#                BY LINUXSAT - support on               #"
    echo "#   https://www.tunisia-sat.com/forums/threads/4029331/ #"
    echo "#########################################################"
    echo "#           your Device will RESTART Now                #"
    echo "#########################################################"
    sleep 2
    if which systemctl > /dev/null 2>&1; then
        sleep 2; systemctl restart enigma2
    else
        init 4; sleep 2; init 3;
    fi
fi

exit 0
