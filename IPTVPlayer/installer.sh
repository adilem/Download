#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL TSIPlayer
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/IPTVPlayer/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
VERSION='30.10.2021'
DUKTAPE='duktape'
TMPDIR='/tmp'
CHECK='/tmp/check'
PLUGINPATH='/usr/lib/enigma2/python/Plugins/Extensions/IPTVPlayer'
SETTINGS='/etc/enigma2/settings'
MY_URL='http://ipkinstall.ath.cx/ipk-install'

#########################
# Delete File In Plugin #
rm -rf $PLUGINPATH
rm -rf /etc/enigma2/iptvplayerarabicgroup.json
rm -rf /etc/enigma2/iptvplayerenglishgroup.json
rm -rf /etc/enigma2/iptvplayerhostsgroups.json
rm -rf /etc/enigma2/iptvplayertsiplayercgroup.json
rm -rf /etc/tsiplayer_xtream.conf
rm -rf /iptvplayer_rootfs

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

if python --version 2>&1 | grep -q '^Python 3\.'; then
    echo ":You have Python3 image ..."
    sleep 1; clear
    PY3SQLITE='python3-sqlite3'
    PLUGINPY3='E2IPLAYER_TSiplayer-PYTHON3.tar.gz'
else
    echo ":You have Python2 image ..."
    sleep 1; clear
    PY2SQLITE='python-sqlite3'
    PLUGINPY2='E2IPLAYER_TSiplayer.tar.gz'
fi

#########################
# Remove files (if any) #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    rm -rf ${TMPDIR}/"${PLUGINPY3:?}"
else
    rm -rf ${TMPDIR}/"${PLUGINPY2:?}"
fi

#####################
# Package Checking  #
if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: $DUKTAPE" $STATUS ; then
        echo
    else
        echo "   >>>>   Need to install $DUKTAPE   <<<<"
        if [ $OSTYPE = "Opensource" ]; then
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE
            clear
        fi
    fi
else
    if grep -qs "Package: $DUKTAPE" $STATUS ; then
        echo
    else
        echo "   >>>>   Need to install $DUKTAPE   <<<<"
        if [ $OSTYPE = "Opensource" ]; then
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE
            clear

        elif [ $OSTYPE = "DreamOS" ]; then
            echo "APT Update ..."
            $OPKG > /dev/null 2>&1
            echo " Downloading $DUKTAPE ......"
            $OPKGINSTAL $DUKTAPE -y
        fi
    fi

fi

#################

if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: $PY3SQLITE" $STATUS ; then
        echo
    else
        echo "   >>>>   Need to install $PY3SQLITE   <<<<"
        if [ $OSTYPE = "Opensource" ]; then
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1
            echo " Downloading $PY3SQLITE ......"
            $OPKGINSTAL $PY3SQLITE
            clear
        fi
    fi
else
    if grep -qs "Package: $PY2SQLITE" $STATUS ; then
        echo
    else
        echo "   >>>>   Need to install $PY2SQLITE   <<<<"
        if [ $OSTYPE = "Opensource" ]; then
            echo "Opkg Update ..."
            $OPKG > /dev/null 2>&1
            echo " Downloading $PY2SQLITE ......"
            $OPKGINSTAL $PY2SQLITE
            clear
        fi
    fi

fi

###############################
# Downlaod And Install Plugin #

if python --version 2>&1 | grep -q '^Python 3\.'; then
    set -e
    echo "Downloading And Insallling IPTVPlayer plugin Please Wait ......"
    echo
    wget $MY_URL/E2IPLAYER+TSIPLAYER-PYTHON3/$PLUGINPY3 -qP $TMPDIR
    tar -xzf $TMPDIR/$PLUGINPY3 -C /
    set +e
    echo "checking your device Arch ....."
    uname -m > $CHECK
    sleep 1;
    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=armv7"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=mipsel"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'aarch64' cat $CHECK ; then
        echo ':Your Device IS AARCH64 processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=ARCH64"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'sh4' cat $CHECK ; then
        echo ':Your Device IS SH4 processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultSH4MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultSH4MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=sh4"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}

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
    sleep 1
    if which systemctl > /dev/null 2>&1; then
        sleep 2; systemctl restart enigma2
    else
        init 4; sleep 2; init 3;
    fi
else
    set -e
    echo "Downloading And Insallling IPTVPlayer plugin Please Wait ......"
    echo
    wget $MY_URL/E2IPLAYER+TSIPLAYER/$PLUGINPY2 -qP $TMPDIR
    tar -xzf $TMPDIR/$PLUGINPY2 -C /
    set +e
    echo "checking your device Arch ....."
    uname -m > $CHECK
    sleep 1;
    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=armv7"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeMIPSELMoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultMIPSELMoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=mipsel"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'aarch64' cat $CHECK ; then
        echo ':Your Device IS AARCH64 processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeARCH64MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultARCH64MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=ARCH64"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}
    elif grep -qs -i 'sh4' cat $CHECK ; then
        echo ':Your Device IS SH4 processor ...'
        echo "Add Setting To ${SETTINGS} ..."
        init 2
        sleep 2
        sed -i '/iptvplayer/d' ${SETTINGS}
        sleep 2
        {
            echo "config.plugins.iptvplayer.SciezkaCache=/etc/IPTVCache/"
            echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer=extgstplayer"
            echo "config.plugins.iptvplayer.alternativeSH4MoviePlayer0=extgstplayer"
            echo "config.plugins.iptvplayer.defaultSH4MoviePlayer=exteplayer"
            echo "config.plugins.iptvplayer.defaultSH4MoviePlayer0=exteplayer"
            echo "config.plugins.iptvplayer.remember_last_position=true"
            echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
            echo "config.plugins.iptvplayer.extplayer_skin=red"
            echo "config.plugins.iptvplayer.plarform=sh4"
            echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
            echo "config.plugins.iptvplayer.wgetpath=wget"
        } >> ${SETTINGS}

    fi
    #########################
    # Remove files (if any) #
    if python --version 2>&1 | grep -q '^Python 3\.'; then
        rm -rf ${TMPDIR}/"${PLUGINPY3:?}"
    else
        rm -rf ${TMPDIR}/"${PLUGINPY2:?}"
    fi

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


clear
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

exit 0
