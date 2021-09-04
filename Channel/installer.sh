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
VERSION='2021_09_02'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel'

####################
#  Image Checking  #
if which opkg > /dev/null 2>&1; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
    PACKAGE='astra-sm'
fi

###########################
# Remove Channel (if any) #
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml

#########################
# Remove files (if any) #
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-*.tar.gz

#####################
#  Checking Package #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PACKAGE" $STATUS ; then
        echo
    else
        echo "Opkg Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $PACKAGE ......"
        $OPKGINSTAL $PACKAGE
    fi
else
    echo ""
    echo "#########################################################"
    echo "#              $PACKAGE Not found in feed               #"
    echo "#      Notification Abertis DTT Channel will not work   #"
    echo "#                    without $PACKAGE                   #"
    echo "#########################################################"
    sleep 3
fi

###############################
# Downlaod And Install Plugin #
set -e
echo "Downloading And Insallling Channel Please Wait ......"
wget $MY_URL/channels_backup_user_${VERSION}.tar.gz -qP $TMPDIR
tar -zxf $TMPDIR/channels_backup_user_${VERSION}.tar.gz -C /
sleep 1
set +e
echo
echo 'Reloading Services - Please Wait'
wget -qO http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 1
echo

if [ $OSTYPE = "Opensource" ]; then
    uname -m > "$CHECK"
    sleep 1

    if grep -qs -i 'armv7l' cat "$CHECK" ; then
        echo ':Your Device IS ARM processor ...'
        echo
        set -e
        echo "Downloading And Insallling Config $PACKAGE Please Wait ......"
        wget $MY_URL/astra-arm.tar.gz -qP $TMPDIR
        tar -xzf $TMPDIR/astra-arm.tar.gz -C /
        sleep 1
        set +e
        chmod -R 755 /etc/astra

    elif grep -qs -i 'mips' cat "$CHECK" ; then
        echo ':Your Device IS MIPS processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $PACKAGE Please Wait ......"
        wget $MY_URL/astra-mips.tar.gz -qP $TMPDIR
        tar -xzf $TMPDIR/astra-mips.tar.gz -C /
        sleep 1
        set +e
        chmod -R 755 /etc/astra

    fi
fi

#########################
# Remove files (if any) #
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-*.tar.gz

sync
echo ""
echo ""
echo "#########################################################"
echo "#       Channel And Config INSTALLED SUCCESSFULLY       #"
echo "#                    MOHAMED_OS                         #"
echo "#                     support                           #"
echo "#  https://www.tunisia-sat.com/forums/threads/4208717   #"
echo "#########################################################"
echo "#           your Device will RESTART Now                #"
echo "#########################################################"
sleep 2

if [ $OSTYPE = "Opensource" ]; then
    killall -9 enigma2
else
    systemctl restart enigma2
fi

exit 0
