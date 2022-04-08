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
PACKAGE='enigma2-plugin-extensions-youtube'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube'
PYTHON_VERSION=$(python -c"import sys; print(sys.version_info.major)")

#########################
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

#########################
VERSION=$(wget $MY_URL/version -qO- | grep 'version' | cut -d "=" -f2-)
GIT=$(wget $MY_URL/version -qO- | grep 'commit' | cut -d "=" -f2-)
CHECK_VERSION=$($OPKGLIST $PACKAGE | cut -d'+' -f2 | awk '{ print $1 }')
rm -rf $TMPDIR/"${PACKAGE:?}"* >/dev/null 2>&1

#########################
if [ "$CHECK_VERSION" = "$VERSION" ]; then
    echo " You are use the laste Version: $VERSION"
    exit 1
elif [ -z "$CHECK_VERSION" ]; then
    echo
    clear
else
    $OPKGREMOV $PACKAGE
fi

########################
install() {
    if grep -qs "Package: $1" $STATUS; then
        echo
    else
        $OPKG >/dev/null 2>&1
        echo "   >>>>   Need to install $1   <<<<"
        echo
        $OPKGINSTAL "$1"
        sleep 1
        clear
    fi
}

########################
if [ "$PYTHON_VERSION" -eq 3 ]; then
    for i in python3-codecs python3-core python3-json python3-netclient; do
        install $i
    done
else
    for i in python-codecs python-core python-json python-netclient; do
        install $i
    done
    if [ $OSTYPE = "DreamOS" ]; then
        for d in gstreamer1.0-plugins-base-meta gstreamer1.0-plugins-good-spectrum; do
            install $d
        done
    fi
fi

########################
echo "Insallling YouTube plugin Please Wait ......"
if [ $OSTYPE = "Opensource" ]; then
    wget $MY_URL/${PACKAGE}_h1+"${VERSION}"+"${GIT}"-r0.0_all.ipk -qP $TMPDIR
    $OPKGINSTAL $TMPDIR/${PACKAGE}_h1+"${VERSION}"+"${GIT}"-r0.0_all.ipk
else
    wget $MY_URL/${PACKAGE}_h1+"${VERSION}"+"${GIT}"-r0.0_all.deb -qP $TMPDIR
    $DPKINSTALL $TMPDIR/${PACKAGE}_h1+"${VERSION}"+"${GIT}"-r0.0_all.deb
    $OPKGINSTAL -f -y
fi

########################
rm -rf $TMPDIR/"${PACKAGE:?}"*

if [ -f /etc/enigma2/YouTube.key-opkg ]; then
    rm -rf /etc/enigma2/YouTube.key-opkg
else
    echo

fi

echo ""
echo "***********************************************************************"
echo "**                                                                    *"
echo "**                       YouTube    : $VERSION                            *"
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
