#!/bin/sh
#####################################
# sh <(wget -qO- https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam/installer.sh)

###########################################
# Configure where we can find things here #

TMPDIR='/tmp'
VEROS='11.695-emu-r798'
VERNC='V11.9-r2'
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
        echo ""
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV $EMUOS
            echo ""
            sleep 1; clear
        else
            $OPKGREMOV $EMUOS
            echo ""
            sleep 1; clear
        fi
    else
        echo ""
        echo "No older version was found on the device... "
        sleep 2
        echo ""
    fi
}
##################
# Ncam Checking  #
checkncam() {
    if grep -qs "Package: $EMUNC" $STATUS ; then
        echo ""
        echo "Remove old version..."
        if [ $OSTYPE = "Opensource" ]; then
            $OPKGREMOV "$EMUNC"
            echo ""
            sleep 2; clear
        else
            $OPKGREMOV "$EMUNC"
            echo ""
            sleep 2; clear
        fi
    else
        echo ""
        echo "No older version was found on the device... "
        sleep 1
        echo ""; clear
    fi
}

#####################
# Package Checking  #
if grep -qs "Package: $Package" $STATUS ; then
    echo ""
    echo "$Package found in device..."
    sleep 2
    echo ""; clear
else
    echo "Need to install $Package"
    echo ""
    if [ $OSTYPE = "Opensource" ]; then
        echo ""
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo ""
        echo " Downloading $Package ......"
        echo ""
        $OPKGINSTAL $Package
        sleep 1
        echo ""; clear
    elif [ $OSTYPE = "DreamOS" ]; then
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $Package ......"
        echo ""
        $OPKGINSTAL $Package -y
        sleep 1
        echo ""; clear
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
PS3='Please enter your choice: '
options=("Oscam" "Revcam_Oscam" "SupTV_Oscam" "Ncam" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Oscam") checkoscam
            if [ $OSTYPE = "Opensource" ]; then
                wget "$URL"/enigma2-plugin-softcams-oscam_"$VEROS"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam_"$VEROS"_all.ipk;
                $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam_"$VEROS"_all.ipk
            else
                wget "$URL"/enigma2-plugin-softcams-oscam_"$VEROS"_all.deb?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam_"$VEROS"_all.deb;
                $DPKINSTALL $TMPDIR/enigma2-plugin-softcams-oscam_"$VEROS"_all.deb; $OPKGINSTAL -f -y
            fi
            exit 0
            ;;
        "Revcam_Oscam") checkoscam
            wget "$URL"/enigma2-plugin-softcams-oscam-revcamv2_"$VEROS"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam-revcam_"$VEROS"_all.ipk;
            $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-revcam_"$VEROS"_all.ipk
            exit 0
            ;;
        "SupTV_Oscam") checkoscam
            wget "$URL"/enigma2-plugin-softcams-oscam-supcam_"$VEROS"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-oscam-supcam_"$VEROS"_all.ipk;
            $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-oscam-supcam_"$VEROS"_all.ipk
            exit 0
            ;;
        "Ncam") checkncam
            if [ $OSTYPE = "Opensource" ]; then
                wget "$URL"/enigma2-plugin-softcams-ncam_"$VERNC"_all.ipk?raw=true -qO $TMPDIR/enigma2-plugin-softcams-ncam_"$VERNC"_all.ipk;
                $OPKGINSTAL $TMPDIR/enigma2-plugin-softcams-ncam_"$VERNC"_all.ipk
            else
                wget "$URL"/enigma2-plugin-softcams-ncam_"$VERNC"_all.deb?raw=true -qO $TMPDIR/enigma2-plugin-softcams-ncam_"$VERNC"_all.deb;
                $DPKINSTALL $TMPDIR/enigma2-plugin-softcams-ncam_"$VERNC"_all.deb; $OPKGINSTAL -f -y
            fi
            exit 0
            ;;
        "Quit")
            echo ""; clear
            echo "Goodbye!"
            sleep 2
            break
            ;;
        *) echo "Invalid option. Try another one.";continue ;;
    esac
done
