#!/bin/sh
# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Oscam_Ncam
# ###########################################
#
# Command: sh -c "$(wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/installer.sh -qO -)"
#
# ###########################################

###########################################
# Configure where we can find things here #

PACKAGE='libcurl4'
TMPDIR='/tmp'
OSC_PACKAGE='enigma2-plugin-softcams-oscam'
NCM_PACKAGE='enigma2-plugin-softcams-ncam'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/'

#################
# Check Version #
OSC_VERSION=$(wget $MY_URL/version -qO- | grep 'oscam' | cut -d "=" -f2-)
NCM_VERSION=$(wget $MY_URL/version -qO- | grep 'ncam' | cut -d "=" -f2-)

####################
#  Image Checking  #

if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    OPKGREMOV='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ]; then
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    OPKGREMOV='apt-get purge --auto-remove'
    DPKINSTALL='dpkg -i --force-overwrite'
fi

##################################
# Remove previous files (if any) #
rm -rf $TMPDIR/"${OSC_PACKAGE:?}"* $TMPDIR/"${NCM_PACKAGE:?}"* >/dev/null 2>&1

################
# Oscam Remove #
removeoscam() {
    if grep -qs "Package: $OSC_PACKAGE*" $STATUS; then
        echo "   >>>>   Remove Old Version   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $OSC_PACKAGE*
            sleep 2
            clear
        else
            $OPKGREMOV $OSC_PACKAGE
            sleep 2
            clear
        fi
    fi
}
################
# Ncam Remove  #
removencam() {
    if grep -qs "Package: $NCM_PACKAGE" $STATUS; then
        echo "   >>>>   Remove Old Version   <<<<"
        echo
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $NCM_PACKAGE
            sleep 2
            clear
        else
            $OPKGREMOV $NCM_PACKAGE
            sleep 2
            clear
        fi
    fi
}
################
# TNTSAT Remove #
removetntsat() {
    if grep -qs "Package: $OSC_PACKAGE-tnt" $STATUS; then
        echo "   >>>>   Remove Old Version   <<<<"
        echo
        $OPKGREMOV $OSC_PACKAGE-tnt
        sleep 2
        clear
    fi
}
##########
$OPKG >/dev/null 2>&1

#####################
# Package Checking  #
if grep -qs "Package: $PACKAGE" $STATUS; then
    echo
else
    echo "   >>>>   Need to install $PACKAGE   <<<<"
    echo
    if [ $OSTYPE = "Opensource" ]; then
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE
    elif [ $OSTYPE = "DreamOS" ]; then
        echo " Downloading $PACKAGE ......"
        echo
        $OPKGINSTAL $PACKAGE -y
    else
        echo "   >>>>   Feed Missing $PACKAGE   <<<<"
        echo "   >>>>   Notification Emu will not work without $PACKAGE   <<<<"
        sleep 3
        exit 0
    fi
fi

#####################
clear
if [ $OSTYPE = "Opensource" ]; then
    echo "> Oscam EMU MENU"
    echo
    echo "  1 - Oscam"
    echo "  2 - Ncam"
    echo "  3 - SupTV_Oscam"
    echo "  4 - Revcam_Oscam"
    echo "  5 - TNTSAT"
    echo
    echo "  x - Exit"
    echo
    echo "- Enter option:"
    read -r opt
    case $opt in
    "1")
        EMU=Oscam removeoscam
        echo "Insallling Oscam plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}_"${OSC_VERSION}"_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}_"${OSC_VERSION}"_all.ipk
        ;;
    "2")
        EMU=Ncam removencam
        echo "Insallling Ncam plugin Please Wait ......"
        wget $MY_URL/${NCM_PACKAGE}_"${NCM_VERSION}"_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${NCM_PACKAGE}_"${NCM_VERSION}"_all.ipk
        ;;
    "3")
        EMU=SupTV_Oscam removeoscam
        echo "Insallling SupTV_Oscam plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-supcam_"${OSC_VERSION}"_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-supcam_"${OSC_VERSION}"_all.ipk
        ;;
    "4")
        EMU=Revcam_Oscam removeoscam
        echo "Insallling Revcam_Oscam plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-revcamv2_"${OSC_VERSION}"_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-revcamv2_"${OSC_VERSION}"_all.ipk
        ;;
    "5")
        EMU=TNTSAN removetntsat
        echo "Insallling TNTSAN plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}-tnt_11.678-tnt_all.ipk -qP $TMPDIR
        $OPKGINSTAL $TMPDIR/${OSC_PACKAGE}-tnt_11.678-tnt_all.ipk
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
elif [ $OSTYPE = "DreamOS" ]; then
    echo "> Oscam EMU MENU"
    echo
    echo "  1 - Oscam"
    echo "  2 - Ncam"
    echo
    echo "  x - Exit"
    echo
    echo "- Enter option:"
    read -r opt
    case $opt in
    "1")
        EMU=Oscam removeoscam
        echo "Insallling Oscam plugin Please Wait ......"
        wget $MY_URL/${OSC_PACKAGE}_"${OSC_VERSION}"_all.deb -qP $TMPDIR
        $DPKINSTALL $TMPDIR/${OSC_PACKAGE}_"${OSC_VERSION}"_all.deb
        $OPKGINSTAL -f -y
        ;;
    "2")
        EMU=Ncam removencam
        echo "Insallling Ncam plugin Please Wait ......"
        wget $MY_URL/${NCM_PACKAGE}_"${NCM_VERSION}"_all.deb -qP $TMPDIR
        $DPKINSTALL $TMPDIR/${NCM_PACKAGE}_"${NCM_VERSION}"_all.deb
        $OPKGINSTAL -f -y
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
fi

################################
# Remove script files (if any) #
rm -rf $TMPDIR/"${OSC_PACKAGE:?}"* $TMPDIR/"${NCM_PACKAGE:?}"*

exit 0
