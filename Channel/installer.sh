#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Channel
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
CHECK='/tmp/check'
VERSION='2021_08_23'
PAKWGET='wget'
URL='https://github.com/MOHAMED19OS/Download/blob/main/Channel'

######################
# Delete File In Tmp #

rm -rf $TMPDIR/channels_${VERSION}.tar.xz
rm -rf $TMPDIR/astra-mips.tar.xz
rm -rf $TMPDIR/astra-arm.tar.xz


####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    Package='astra-sm'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
fi

if [ $OSTYPE = "Opensource" ]; then
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
else
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
fi

#####################
#  Checking Package #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $Package" $STATUS ; then
        echo ""
        echo "$Package Depends Are Installed..."
        sleep 2; clear
    else
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1 ;clear
        echo " Downloading $Package ......"
        $OPKGINSTAL $Package
        echo "" ;clear
    fi
else
    echo "Feed Missing $Package"
    echo "Sorry, the plugin will not be install"
    clear; echo "Goodbye!"
    exit 0
fi

if grep -qs "Package: $PAKWGET" $STATUS ; then
    echo ""
    echo "$PAKWGET Depends Are Installed..."
    sleep 2; clear
else
    if [ $OSTYPE = "Opensource" ]; then
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1 ;clear
        echo " Downloading $PAKWGET ......"
        $OPKGINSTAL $PAKWGET
        echo "" ;clear

    elif [ $OSTYPE = "DreamOS" ]; then
        echo ""
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1 ;clear
        echo " Downloading $PAKWGET ......"
        $OPKGINSTAL $PAKWGET
        echo "" ;clear
    else
        echo "Feed Missing $PAKWGET"
        echo "Sorry, the plugin will not be install"
        clear; echo "Goodbye!"
        exit 0
    fi
fi

###############################
# Downlaod And Install Plugin #
set -e
echo "Downloading And Insallling Channel Please Wait ......"
wget ${URL}/channels_${VERSION}.tar.xz -qO ${TMPDIR}/channels_${VERSION}.tar.xz
tar -xf ${TMPDIR}/channels_${VERSION}.tar.xz
set +e
rm -rf ${TMPDIR}/channels_${VERSION}.tar.xz

if [ $OSTYPE = "Opensource" ]; then
    uname -m > $CHECK
    sleep 1

    if grep -qs -i 'armv7l' cat $CHECK ; then
        echo ':Your Device IS ARM processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $Package Please Wait ......"
        wget ${URL}/astra-arm.tar.xz -qO ${TMPDIR}/astra-arm.tar.xz
        tar -xf ${TMPDIR}/astra-arm.tar.xz
        set +e
        rm -rf ${TMPDIR}/astra-arm.tar.xz
        chmod -R 755 /etc/astra

    elif grep -qs -i 'mips' cat $CHECK ; then
        echo ':Your Device IS MIPS processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $Package Please Wait ......"
        wget ${URL}/astra-mips.tar.xz -qO ${TMPDIR}/astra-mips.tar.xz
        tar -xf ${TMPDIR}/astra-mips.tar.xz
        set +e
        rm -rf ${TMPDIR}/astra-mips.tar.xz
        chmod -R 755 /etc/astra
    fi
fi

sync
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Channel    : $VERSION                      *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4208717/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""
sleep 2

if [ $OSTYPE = "Opensource" ]; then
    shutdown -r now
else
    systemctl restart enigma2
fi

exit 0
