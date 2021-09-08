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
VERSION='2021_09_08'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel'

########################
# Path of Config Files #
BINPATH=/usr/bin
ETCPATH=/etc
ASTRAPATH=${ETCPATH}/astra
######
BBCPMT=$BINPATH/bbc_pmt_starter.sh
BBCPY=$BINPATH/bbc_pmt_v6.py
BBCENIGMA=$BINPATH/enigma2_pre_start.sh
######
SYSCONF=${ETCPATH}/sysctl.conf
ASTRACONF=${ASTRAPATH}/astra.conf
ABERTISBIN=${ASTRAPATH}/scripts/abertis
ASTRABIN=$BINPATH/astra
SPAMMERBIN=$BINPATH/spammer
T2MBIN=$BINPATH/t2mi_decap
###############################
# Path of Config Files in Tmp #
CONFIGpmttmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_starter.sh
CONFIGpytmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_v6.py
CONFIGentmp=${TMPDIR}/bbc_pmt_v6/enigma2_pre_start.sh
CONFIGsysctltmp=${TMPDIR}/${PACKAGE}/sysctl.conf
CONFIGastratmp=${TMPDIR}/${PACKAGE}/astra.conf
CONFIGabertistmp=${TMPDIR}/${PACKAGE}/abertis
CONFIGBINastratmp=${TMPDIR}/${PACKAGE}/astra
CONFIGspammertmp=${TMPDIR}/${PACKAGE}/spammer
CONFIGt2mi_decaptmp=${TMPDIR}/${PACKAGE}/t2mi_decap
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
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-* bbc_pmt_v6*
rm -rf $ASTRACONF $SYSCONF

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
echo "   >>>>   Reloading Services - Please Wait   <<<<"
wget -qO http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 1
echo

if [ -f $BBCPMT ] && [ -f $BBCPY ] && [ -f $BBCENIGMA ]; then
    echo "   >>>>   All Config BBC Files found   <<<<"
    sleep 2
else
    set -e
    echo "Downloading Config BBC Please Wait ......"
    wget $MY_URL/bbc_pmt_v6.tar.gz -qP $TMPDIR
    tar -xzf bbc_pmt_v6.tar.gz
    set +e
    sleep 1
    echo "---------------------------------------------"
    if [ ! -f $BBCPMT ]; then
        cp -f $CONFIGpmttmp $BINPATH > /dev/null 2>&1
        echo "[send (bbc_pmt_starter.sh) file]"
    fi
    if [ ! -f $BBCPY ]; then
        cp -f $CONFIGpytmp $BINPATH > /dev/null 2>&1
        echo "[send (bbc_pmt_v6.py) file]"
    fi
    if [ ! -f $BBCENIGMA ]; then
        cp -f $CONFIGentmp $BINPATH > /dev/null 2>&1
        echo "[send (enigma2_pre_start.sh) file]"
    fi
    echo "---------------------------------------------"
fi
chmod 755 /usr/bin/{bbc_pmt_starter.sh,bbc_pmt_v6.py,enigma2_pre_start.sh}


if [ $OSTYPE = "Opensource" ]; then
    uname -m > "$CHECK"
    sleep 1

    if grep -qs -i 'armv7l' cat "$CHECK" ; then
        echo ':Your Device IS ARM processor ...'
        echo
        if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ]; then
            echo "   >>>>   All Config $PACKAGE Files found   <<<<"
            sleep 2
        else
            set -e
            echo "Downloading Config $PACKAGE Please Wait ......"
            wget $MY_URL/astra-arm.tar.gz -qP $TMPDIR
            tar -xzf astra-arm.tar.gz
            mv astra-arm ${PACKAGE}
            set +e
            sleep 1
            echo "---------------------------------------------"
            if [ ! -f $SYSCONF ]; then
                cp -f $CONFIGsysctltmp $ETCPATH > /dev/null 2>&1
                echo "[send (sysctl.conf) file]"
            fi
            if [ ! -f $ASTRACONF ]; then
                cp -f $CONFIGastratmp $ASTRAPATH > /dev/null 2>&1
                echo "[send (astra.conf) file]"
            fi
            if [ ! -f $ABERTISBIN ]; then
                cp -f $CONFIGabertistmp $ASTRAPATH/scripts > /dev/null 2>&1
                echo "[send (abertis) file]"
            fi
            echo "---------------------------------------------"
        fi
        chmod -R 755 /etc/astra

    elif grep -qs -i 'mips' cat "$CHECK" ; then
        echo ':Your Device IS MIPS processor ...'
        echo
        if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ]; then
            echo "   >>>>   All Config $PACKAGE Files found   <<<<"
            sleep 2
        else
            set -e
            echo "Downloading Config $PACKAGE Please Wait ......"
            wget $MY_URL/astra-mips.tar.gz -qP $TMPDIR
            tar -xzf astra-mips.tar.gz
            mv astra-mips ${PACKAGE}
            set +e
            sleep 1
            echo "---------------------------------------------"
            if [ ! -f $SYSCONF ]; then
                cp -f $CONFIGsysctltmp $ETCPATH > /dev/null 2>&1
                echo "[send (sysctl.conf) file]"
            fi
            if [ ! -f $ASTRACONF ]; then
                cp -f $CONFIGastratmp $ASTRAPATH > /dev/null 2>&1
                echo "[send (astra.conf) file]"
            fi
            if [ ! -f $ABERTISBIN ]; then
                cp -f $CONFIGabertistmp $ASTRAPATH/scripts > /dev/null 2>&1
                echo "[send (abertis) file]"
            fi
            echo "---------------------------------------------"
        fi
        chmod -R 755 /etc/astra

    fi
elif [ $OSTYPE = "DreamOS" ]; then
    #if grep -qs -i 'aarch64' cat "$CHECK" ; then
        #echo ':Your Device IS AARCH64 processor ...'
        #echo
        if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ] && [ -f $ASTRABIN ] && [ -f $SPAMMERBIN ] && [ -f $T2MBIN ]; then
            echo "   >>>>   All Config $PACKAGE Files found   <<<<"
            sleep 2
        else
            set -e
            echo "Downloading Config $PACKAGE Please Wait ......"
            wget $MY_URL/astra-aarch64.tar.gz -qP $TMPDIR
            tar -xzf astra-aarch64.tar.gz
            mv astra-aarch64 ${PACKAGE}
            set +e
            sleep 1; clear
            echo "---------------------------------------------"
            if [ ! -f $ASTRABIN ]; then
                cp -f $CONFIGBINastratmp $BINPATH > /dev/null 2>&1
                echo "[send (astra) file]"
            fi
            if [ ! -f $SPAMMERBIN ]; then
                cp -f $CONFIGspammertmp $BINPATH > /dev/null 2>&1
                echo "[send (spammer) file]"
            fi
            if [ ! -f $T2MBIN ]; then
                cp -f $CONFIGt2mi_decaptmp $BINPATH > /dev/null 2>&1
                echo "[send (t2mi_decap) file]"
            fi
            if [ ! -f $SYSCONF ]; then
                cp -f $CONFIGsysctltmp $ETCPATH > /dev/null 2>&1
                echo "[send (sysctl.conf) file]"
            fi
            if [ ! -f $ASTRACONF ]; then
                cp -f $CONFIGastratmp $ASTRAPATH > /dev/null 2>&1
                echo "[send (astra.conf) file]"
            fi
            if [ ! -f $ABERTISBIN ]; then
                cp -f $CONFIGabertistmp $ASTRAPATH/scripts > /dev/null 2>&1
                echo "[send (abertis) file]"
            fi
            echo "---------------------------------------------"
        fi
        chmod 755 /usr/bin/{astra,spammer,t2mi_decap}
        chmod -R 755 /etc/astra
    #fi
fi
#########################
# Remove files (if any) #
rm -rf $TMPDIR/channels_backup_user_${VERSION}.tar.gz astra-* bbc_pmt_v6*

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
