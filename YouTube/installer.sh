#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL YouTube
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
VERSION='git824'
GIT='9e892cb'
PACKAGE='enigma2-plugin-extensions-youtube'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube'

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ] ; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ] ; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* > /dev/null 2>&1

######################
#  Remove Old Plugin #
if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo "   >>>>   Remove old version   <<<<"
    $OPKGREMOV $PACKAGE
    sleep 1; clear
else
    echo "   >>>>   No Older Version Was Found   <<<<"
    sleep 1; clear
fi

######################
#  Checking Depends  #

if python --version 2>&1 | grep -q '^Python 3\.'; then
    if grep -qs "Package: enigma2" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL enigma2
    fi
    if grep -qs "Package: python3-codecs" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-codecs
    fi
    if grep -qs "Package: python3-core" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-core
    fi
    if grep -qs "Package: python3-json" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-json
    fi
    if grep -qs "Package: python3-netclient" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-netclient
    fi
    if grep -qs "Package: python3-twisted" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-twisted
    fi
    if grep -qs "Package: python3-twisted-web" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python3-twisted-web
    fi
else
    if grep -qs "Package: python-codecs" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-codecs
    fi
    if grep -qs "Package: python-compression" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-compression
    fi
    if grep -qs "Package: python-core" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-core
    fi
    if grep -qs "Package: python-json" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-json
    fi
    if grep -qs "Package: python-netclient" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-netclient
    fi
    if grep -qs "Package: python-pyopenssl" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-pyopenssl
    fi
    if grep -qs "Package: python-twisted-web" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-twisted-web
    fi
    if grep -qs "Package: python-zlib" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL python-zlib
    fi
fi

if [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: gstreamer1.0-plugins-base-meta" $STATUS ; then
        echo
    else
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL gstreamer1.0-plugins-base-meta -y
    fi
    if grep -qs "Package: gstreamer1.0-plugins-good-spectrum" $STATUS ; then
        echo
    else
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        $OPKGINSTAL gstreamer1.0-plugins-good-spectrum -y
    fi
fi

sleep 1; clear
###################
#  Install Plugin #
if [ $OSTYPE = "Opensource" ]; then
    echo "Insallling YouTube plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.ipk
else
    echo "Insallling YouTube plugin Please Wait ......"
    wget $MY_URL/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_h1+${VERSION}+${GIT}-r0.0_all.deb; $OPKGINSTAL -f -y
fi


#########################
# Remove files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"*

if [ -f /etc/enigma2/YouTube.key-opkg ]; then
    rm -rf /etc/enigma2/YouTube.key-opkg
else
    echo

fi

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       YouTube    : $VERSION                          *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : Taapat                          *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/3776759/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
