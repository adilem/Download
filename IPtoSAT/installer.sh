#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL IPtoSAT
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/IPtoSAT/installer.sh -qO - | /bin/sh
#
# ###########################################

###########################################
# Configure where we can find things here #
TMPDIR='/tmp'
PACKAGE='enigma2-plugin-extensions-iptosat'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/IPtoSAT'

#################
# Check Version #
VERSION=$(wget $MY_URL/version -qO- | cut -d "=" -f2-)

####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGLIST='opkg list-installed'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGLIST='apt-get list-installed'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi
######################
$OPKG >/dev/null 2>&1

###########
# install #

install() {
    if grep -qs "Package: $1" $STATUS; then
        echo
    else
        echo "   >>>>   Need to install $1   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGINSTAL "$1"
            sleep 1
            clear
        elif [ $OSTYPE = "DreamOS" ]; then
            $OPKGINSTAL "$1" -y
            sleep 1
            clear
        fi
    fi
}

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

if [ "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" = "$VERSION" ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$($OPKGLIST $PACKAGE | awk '{ print $3 }')" ]; then
    echo
    clear
else
    $OPKGREMOV $PACKAGE
fi

#####################
# Package Checking  #
if [ $OSTYPE = "Opensource" ]; then
    for i in exteplayer3 gstplayer; do
        install $i
    done
elif [ $OSTYPE = "DreamOS" ]; then
    install gstreamer1.0-plugins-base-apps
fi

###################
#  Install Plugin #

echo "Insallling IPtoSAT plugin Please Wait ......"
if [ $OSTYPE = "Opensource" ]; then
    wget $MY_URL/${PACKAGE}_"${VERSION}"_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_"${VERSION}"_all.ipk
else
    wget $MY_URL/${PACKAGE}_"${VERSION}".deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_"${VERSION}".deb
    $OPKGINSTAL -f -y
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${PACKAGE:?}"*

sleep 1
clear
echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       IPtoSAT    : $VERSION                             *"
echo "**                       Uploaded by: MOHAMED_OS                      *"
echo "**                       Develop by : ZAKARIYA KHA                    *"
echo "**  Support    : https://www.tunisia-sat.com/forums/threads/4171372/  *"
echo "**                                                                    *"
echo "***********************************************************************"
echo ""

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
