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
PACKAGE='astra-sm'
VERSION='2021_09_04'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel'

####################
#  Image Checking  #
if which opkg > /dev/null 2>&1; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
else
    STATUS='/var/lib/dpkg/status'
    OSTYPE='DreamOS'
    OPKG='apt-get update'
    OPKGINSTAL='apt-get install'
    LIBAIO1='libaio1'
    LIBC6='libc6'
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
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-*.tar.gz bbc_pmt_v6.tar.gz

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
elif [ $OSTYPE = 'DreamOS' ]; then
    if grep -qs "Package: $LIBAIO1" $STATUS ; then
        echo
    else
        echo "APT Update ..."
        $OPKG > /dev/null 2>&1
        echo " Downloading $LIBAIO1 ......"
        $OPKGINSTAL $LIBAIO1
    fi
elif grep -qs "Package: $LIBC6" $STATUS ; then
    echo
else
    echo "APT Update ..."
    $OPKG > /dev/null 2>&1
    echo " Downloading $LIBC6 ......"
    $OPKGINSTAL $LIBC6
fi

if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PACKAGE" $STATUS ; then
        echo
    else
        echo ""
        echo "#########################################################"
        echo "#              $PACKAGE Not found in feed               #"
        echo "#      Notification Abertis DTT Channel will not work   #"
        echo "#                    without $PACKAGE                   #"
        echo "#########################################################"
    fi
elif [ $OSTYPE = "DreamOS" ]; then
    if grep -qs "Package: $LIBAIO1" $STATUS ; then
        echo
    else
        echo "Feed Missing $LIBAIO1"
        echo "Sorry, the $PACKAGE will not be work"
        exit 1
    fi
    if grep -qs "Package: $LIBC6" $STATUS ; then
        echo
    else
        echo "Feed Missing $LIBC6"
        echo "Sorry, the $PACKAGE will not be work"
        exit 1
    fi

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

set -e
echo "Downloading And Insallling Config BBC Please Wait ......"
wget $MY_URL/bbc_pmt_v6.tar.gz -qP $TMPDIR
tar -zxf $TMPDIR/bbc_pmt_v6.tar.gz -C /
sleep 1
set +e
chmod 755 /usr/bin/{bbc_pmt_starter.sh,bbc_pmt_v6.py,enigma2_pre_start.sh}


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
elif [ $OSTYPE = "DreamOS" ]; then
    if grep -qs -i 'aarch64' cat "$CHECK" ; then
        echo ':Your Device IS AARCH64 processor ...'
        sleep 2; clear
        set -e
        echo "Downloading And Insallling Config $PACKAGE Please Wait ......"
        wget $MY_URL/astra-aarch64.tar.gz -qP $TMPDIR
        tar -xzf $TMPDIR/astra-aarch64.tar.gz -C /
        sleep 1
        set +e
        chmod 755 /usr/bin/{astra,spammer,t2mi_decap}
        chmod -R 755 /etc/astra
    fi
fi
#########################
# Remove files (if any) #
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-*.tar.gz bbc_pmt_v6.tar.gz

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
