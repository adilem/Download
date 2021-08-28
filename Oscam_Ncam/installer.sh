#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Oscam_Ncam
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/installer.sh -q; sh installer.sh; rm -rf installer.sh
#
# ###########################################

###########################################
# Configure where we can find things here #

TMPDIR='/tmp'
VEROS='11.695-emu-r798'
VERNC='11.9-r3'
Package='libcurl4'
EMUOS='enigma2-plugin-softcams-oscam*'
EMUNC='enigma2-plugin-softcams-ncam*'
URL='https://github.com/MOHAMED19OS/Download/blob/main/Oscam_Ncam'

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

##################
# Oscam Checking #
checkoscam() {
    if grep -qs "Package: $EMUOS" $STATUS ; then
        echo
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $EMUOS
            sleep 2; clear
        else
            $OPKGREMOV $EMUOS
            sleep 2; clear
        fi
    else
        echo
        echo "No older version was found on the device... "
        sleep 1
    fi
}
##################
# Ncam Checking  #
checkncam() {
    if grep -qs "Package: $EMUNC" $STATUS ; then
        echo
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV "$EMUNC"
            sleep 2; clear
        else
            $OPKGREMOV "$EMUNC"
            sleep 2; clear
        fi
    else
        echo
        echo "No older version was found on the device... "
        sleep 1
    fi
}
#####################
# Package Checking  #
if grep -qs "Package: $Package" $STATUS ; then
    echo
else
    echo "Need to install $Package"
    echo
    if [ $OSTYPE = "Opensource" ]; then
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo
        echo " Downloading $Package ......"
        echo
        $OPKGINSTAL $Package
    elif [ $OSTYPE = "DreamOS" ]; then
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $Package ......"
        echo
        $OPKGINSTAL $Package -y
    else
        echo ""
        echo ""
        echo "#########################################################"
        echo "#            $Package Not found in feed                 #"
        echo "#    Notification Emu will not work without $Package    #"
        echo "#########################################################"
        sleep 3
        exit 0
    fi
fi

#####################
clear
echo "> Oscam EMU MENU"
echo
echo "  1 - Oscam"
echo "  2 - Revcam_Oscam"
echo "  3 - SupTV_Oscam"
echo "  4 - Ncam"
echo
echo "  x - Exit"
echo
echo "- Enter option:"
read opt
case $opt in
    "1") EMU=Oscam checkoscam
        if [ $OSTYPE = "Opensource" ]; then
            echo "Downloading And Insallling Oscam plugin Please Wait ......"
            wget $URL/enigma2-plugin-softcams-oscam_${VEROS}_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam_${VEROS}_all.ipk
            $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam_${VEROS}_all.ipk
        else
            echo "Downloading And Insallling Oscam plugin Please Wait ......"
            wget $URL/enigma2-plugin-softcams-oscam_${VEROS}_all.deb?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam_${VEROS}_all.deb
            $DPKINSTALL $TMPDIR/enigma2-plugin-softcams-oscam_${VEROS}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    "2") EMU=Revcam_Oscam checkoscam
        echo "Downloading And Insallling Revcam_Oscam plugin Please Wait ......"
        wget $URL/enigma2-plugin-softcams-oscam-revcamv2_${VEROS}_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam-revcam_${VEROS}_all.ipk
        $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-revcam_${VEROS}_all.ipk
        ;;
    "3") EMU=SupTV_Oscam checkoscam
        echo "Downloading And Insallling SupTV_Oscam plugin Please Wait ......"
        wget $URL/enigma2-plugin-softcams-oscam-supcam_${VEROS}_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam-supcam_${VEROS}_all.ipk
        $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-supcam_${VEROS}_all.ipk
        ;;
    "4") EMU=Ncam checkncam
        if [ $OSTYPE = "Opensource" ]; then
            echo "Downloading And Insallling Ncam plugin Please Wait ......"
            wget $URL/enigma2-plugin-softcams-ncam_V${VERNC}_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-ncam_V${VERNC}_all.ipk
            $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-ncam_V${VERNC}_all.ipk
        else
            echo "Downloading And Insallling Ncam plugin Please Wait ......"
            wget $URL/enigma2-plugin-softcams-ncam_V${VERNC}_all.deb?raw=true -qO $TMPDIR/enigma2-plugin-softcams-ncam_V${VERNC}_all.deb
            $DPKINSTALL $TMPDIR/enigma2-plugin-softcams-ncam_V${VERNC}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    x)
        clear
        echo
        echo "Goodbye ;)"
        echo
        exit 1
        ;;
    *)
        echo "Invalid option"
        sleep 2
        exit 1
        ;;
esac
