#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Oscam_Ncam
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/installer.sh -q; sh installer.sh
#
# ###########################################

###########################################
# Configure where we can find things here #

PACKAGE='libcurl4'
TMPDIR='/tmp'
OSC_VERSION='11.695-emu-r798'
ENC_VERSION='V11.9-r3'
OSC_PACKAGE='enigma2-plugin-softcams-oscam*'
ENC_PACKAGE='enigma2-plugin-softcams-ncam'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/'

####################
#  Image Checking  #

if which opkg > /dev/null 2>&1; then
  STATUS='/var/lib/opkg/status'
  OSTYPE='Opensource'
  OPKG='opkg update'
  OPKGINSTAL='opkg install'
  OPKGREMOV='opkg remove --force-depends'
else
  STATUS='/var/lib/dpkg/status'
  OSTYPE='DreamOS'
  OPKG='apt-get update'
  OPKGINSTAL='apt-get install'
  OPKGREMOV='apt-get purge --auto-remove'
  DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/${OSC_PACKAGE} $TMPDIR/${ENC_PACKAGE}*

##################
# Oscam Checking #
checkoscam() {
    if grep -qs "Package: $OSC_PACKAGE" $STATUS ; then
        echo
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $OSC_PACKAGE
            sleep 2; clear
        else
            $OPKGREMOV $OSC_PACKAGE
            sleep 2; clear
        fi
    else
        echo "No older version was found on the device... "
        sleep 1; clear
    fi
}
##################
# Ncam Checking  #
checkncam() {
    if grep -qs "Package: $ENC_PACKAGE" $STATUS ; then
        echo
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $ENC_PACKAGE
            sleep 2; clear
        else
            $OPKGREMOV $ENC_PACKAGE
            sleep 2; clear
        fi
    else
        echo "No older version was found on the device... "
        sleep 1; clear
    fi
}
#####################
# Package Checking  #
if grep -qs "Package: $PACKAGE" $STATUS ; then
    echo
else
    echo "Need to install $PACKAGE"
    echo
    if [ $OSTYPE = "Opensource" ]; then
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE
    elif [ $OSTYPE = "DreamOS" ]; then
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE -y
    else
        echo ""
        echo ""
        echo "#########################################################"
        echo "#            $PACKAGE Not found in feed                 #"
        echo "#    Notification Emu will not work without $PACKAGE    #"
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
            wget $MY_URL/enigma2-plugin-softcams-oscam_${OSC_VERSION}_all.ipk -qP $TMPDIR
            $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam_${OSC_VERSION}_all.ipk
        else
            echo "Downloading And Insallling Oscam plugin Please Wait ......"
            wget $MY_URL/enigma2-plugin-softcams-oscam_${OSC_VERSION}_all.deb -qP $TMPDIR
            $DPKINSTALL $TMPDIR/enigma2-plugin-softcams-oscam_${OSC_VERSION}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    "2") EMU=Revcam_Oscam checkoscam
        echo "Downloading And Insallling Revcam_Oscam plugin Please Wait ......"
        wget $MY_URL/enigma2-plugin-softcams-oscam-revcamv2_${OSC_VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-revcamv2_${OSC_VERSION}_all.ipk
        ;;
    "3") EMU=SupTV_Oscam checkoscam
        echo "Downloading And Insallling SupTV_Oscam plugin Please Wait ......"
        wget $MY_URL/enigma2-plugin-softcams-oscam-supcam_${OSC_VERSION}_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-supcam_${OSC_VERSION}_all.ipk
        ;;
    "4") EMU=Ncam checkncam
        if [ $OSTYPE = "Opensource" ]; then
            echo "Downloading And Insallling Ncam plugin Please Wait ......"
            wget $MY_URL/${ENC_PACKAGE}_${ENC_VERSION}_all.ipk -qP $TMPDIR
            $OPKGINSTAL $TMPDIR/${ENC_PACKAGE}_${ENC_VERSION}_all.ipk
        else
            echo "Downloading And Insallling Ncam plugin Please Wait ......"
            wget $MY_URL/${ENC_PACKAGE}_${ENC_VERSION}_all.deb -qP $TMPDIR
            $DPKINSTALL $TMPDIR/${ENC_PACKAGE}_${ENC_VERSION}_all.deb; $OPKGINSTAL -f -y
        fi
        ;;
    x)
        clear
        echo
        echo "Goodbye ;)"
        echo
        ;;
    *)
        echo "Invalid option"
        sleep 2
        ;;
esac

MY_RESULT=$?

################################
# Remove script files (if any) #
if [ $MY_RESULT -eq 0 ] ; then
    rm -rf $TMPDIR/${OSC_PACKAGE} $TMPDIR/${ENC_PACKAGE}*
    rm -rf $TMPDIR/installer.sh
    exit 1
fi
