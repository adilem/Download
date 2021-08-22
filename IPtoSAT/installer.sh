#!/bin/sh
#####################################
# wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/IPtoSAT/installer.sh -qO - | /bin/sh

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='1.8'
Package='enigma2-plugin-extensions-iptosat*'
PKGEXP3='exteplayer3'
PKGGPLY='gstplayer'
PKGBAPP='gstreamer1.0-plugins-base-apps'
URL='https://github.com/MOHAMED19OS/Download/blob/main/IPtoSAT'

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
    OPKGREMOV='opkg remove --force-depends'
else
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

######################
#  Remove Old Plugin #
if grep -qs "Package: $Package" $STATUS ; then
    echo ""
    echo "Remove old version..."
    if [ $OSTYPE = "Opensource" ]; then
        $OPKGREMOV "$Package"
        echo ""
        sleep 2; clear
    else
        $OPKGREMOV "$Package"
        echo ""
        sleep 2; clear
    fi
else
    echo ""
    echo "No older version was found on the device... "
    sleep 1
    echo ""; clear
fi

#####################
# Package Checking  #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGEXP3" $STATUS ; then
        echo ""
        echo "$PKGEXP3 found in device..."
        sleep 1
        echo ""; clear
    else
        echo "Need to install $PKGEXP3"
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo ""
        echo " Downloading $PKGEXP3 ......"
        echo ""
        $OPKGINSTAL $PKGEXP3
        sleep 1
        echo ""; clear
    fi
else
    echo ""
    echo ""
    echo "#########################################################"
    echo "#            $PKGEXP3 Not found in feed                 #"
    echo "#    Notification Emu will not work without $PKGEXP3    #"
    echo "#########################################################"
    sleep 2
    exit 0
fi

if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGGPLY" $STATUS ; then
        echo ""
        echo "$PKGGPLY found in device..."
        sleep 1
        echo ""; clear
    else
        echo "Need to install $PKGGPLY"
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo ""
        echo " Downloading $PKGGPLY ......"
        echo ""
        $OPKGINSTAL $PKGGPLY
        sleep 1
        echo ""; clear
    fi
else
    echo ""
    echo ""
    echo "#########################################################"
    echo "#            $PKGGPLY Not found in feed                 #"
    echo "#    Notification Emu will not work without $PKGGPLY    #"
    echo "#########################################################"
    sleep 2
    exit 0
fi

if [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: $PKGBAPP" $STATUS ; then
        echo ""
        echo " $PKGBAPP found in device..."
        sleep 1
        echo ""; clear
    else
        echo "Need to install  $PKGBAPP"
        echo ""
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading  $PKGBAPP ......"
        echo ""
        $OPKGINSTAL  $PKGBAPP -y
        sleep 1
        echo ""; clear
    fi
else
    echo ""
    echo ""
    echo "#########################################################"
    echo "#             $PKGBAPP Not found in feed                 #"
    echo "#    Notification Emu will not work without  $PKGBAPP    #"
    echo "#########################################################"
    sleep 2
    exit 0
fi

###################
#  Install Plugin #
if [ $OSTYPE = "Opensource" ]; then
    wget --show-progress "$URL"/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk;
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk
else
    wget --show-progress "$URL"/enigma2-plugin-extensions-iptosat_"$VERSION".deb?raw=true -qO $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION".deb;
    $DPKINSTALL $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION".deb; $OPKGINSTAL -f -y
fi

######################
# Delete File In TMP #

if [ -f $TMPDIR/$Package ] ; then
    rm -rf $TMPDIR/$Package
else
    echo ""
fi

exit 0
