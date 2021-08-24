#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL IPtoSAT
# ###########################################
#
# Command: wget wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/IPtoSAT/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='1.8'
Package='enigma2-plugin-extensions-iptosat*'
URL='https://github.com/MOHAMED19OS/Download/blob/main/IPtoSAT'

####################
#  Image Checking  #
if [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    PKGBAPP='gstreamer1.0-plugins-base-apps'
elif [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    PKGEXP3='exteplayer3'
    PKGGPLY='gstplayer'
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
    echo "No older version was found on the device... "
    sleep 1
    echo ""; clear
fi

#####################
# Package Checking  #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGEXP3" $STATUS ; then
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

elif [ $OSTYPE = "DreamOS" ]; then
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
fi

if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PKGEXP3" $STATUS ; then
        echo ""
    else
        echo "Feed Missing $PKGEXP3"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
    if grep -qs "Package: $PKGGPLY" $STATUS ; then
        echo ""
    else
        echo "Feed Missing $PKGGPLY"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
elif [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: $PKGBAPP" $STATUS ; then
        echo ""
    else
        echo "Feed Missing $PKGBAPP"
        echo "Sorry, the plugin will not be install"
        exit 1
    fi
fi
###################
#  Install Plugin #
if [ $OSTYPE = "Opensource" ]; then
    echo "Downloading And Insallling IPtoSAT plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk;
    $OPKGINSTAL $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION"_all.ipk
else
    echo "Downloading And Insallling IPtoSAT plugin Please Wait ......"
    wget "$URL"/enigma2-plugin-extensions-iptosat_"$VERSION".deb?raw=true -qO $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION".deb;
    $DPKINSTALL $TMPDIR/enigma2-plugin-extensions-iptosat_"$VERSION".deb; $OPKGINSTAL -f -y
fi

######################
# Delete File In TMP #

if [ -f $TMPDIR/$Package ] ; then
    rm -rf $TMPDIR/$Package
else
    echo ""
fi


sleep 1; clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       Ansite     : $VERSION                             *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : ZAKARIYA KHA                    *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4171372/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

exit 0
