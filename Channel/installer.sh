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
VERSION='2021_09_09'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel'

########################
# Path of Config Files #
BINPATH=/usr/bin
ETCPATH=/etc
ASTRAPATH=${ETCPATH}/astra
SETTINGS=${ETCPATH}/enigma2/settings
######
BBCPMT=${BINPATH}/bbc_pmt_starter.sh
BBCPY=${BINPATH}/bbc_pmt_v6.py
BBCENIGMA=${BINPATH}/enigma2_pre_start.sh
######
SYSCONF=${ETCPATH}/sysctl.conf
ASTRACONF=${ASTRAPATH}/astra.conf
ABERTISBIN=${ASTRAPATH}/scripts/abertis
ASTRABIN=${BINPATH}/astra
SPAMMERBIN=${BINPATH}/spammer
T2MBIN=${BINPATH}/t2mi_decap
ASTRASM=${ETCPATH}/init.d/astra-sm
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
CONFIGt2midecaptmp=${TMPDIR}/${PACKAGE}/t2mi_decap
CONFIGastrasmtmp=${TMPDIR}/${PACKAGE}/astra-sm
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

#########################
# Remove files (if any) #
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml
rm -rf ${ASTRACONF} ${SYSCONF}
rm -rf ${TMPDIR}/channels_backup_user_${VERSION}* astra-* bbc_pmt_v6*

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
        echo "   >>>>   Feed Missing $PACKAGE   <<<<"
        echo "   >>>>   Notification Abertis DTT Channel will not work   <<<<"
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
echo "   >>>>   Downloading And Insallling Config Tuner - Please Wait   <<<<"
init 2
sleep 2
sed -i '/Nims/d' ${SETTINGS}
sleep 2
{
    echo config.Nims.0.dvbs.advanced.sat.19.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.30.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.48.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.70.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.90.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.100.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.130.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.160.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.192.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.215.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.235.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.260.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.330.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.392.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.420.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.450.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.460.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.525.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3300.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3325.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3355.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3380.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3450.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3520.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3530.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3550.lnb=1
    echo config.Nims.0.dvbs.advanced.sat.3592.lnb=1
    echo config.Nims.0.dvbs.configMode=advanced
    echo config.Nims.1.dvbs.configMode=nothing
} >> ${SETTINGS}

echo
set -e
echo "Downloading And Insallling Channel Please Wait ......"
wget $MY_URL/channels_backup_user_${VERSION}.tar.gz -qP $TMPDIR
tar -zxf $TMPDIR/channels_backup_user_${VERSION}.tar.gz -C /
sleep 1
set +e
echo
echo "   >>>>   Reloading Services - Please Wait   <<<<"
wget -qO http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 2
echo

if [ -f $BBCPMT ] && [ -f $BBCPY ] && [ -f $BBCENIGMA ]; then
    echo "   >>>>   All Config BBC Files found   <<<<"
    sleep 2
else
    set -e
    echo "Downloading And Insallling Config BBC Please Wait ......"
    wget $MY_URL/bbc_pmt_v6.tar.gz -qP $TMPDIR
    tar -xzf $TMPDIR/bbc_pmt_v6.tar.gz -C $TMPDIR
    set +e
    chmod -R 755 ${TMPDIR}/bbc_pmt_v6
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

if [ $OSTYPE = "Opensource" ]; then
    uname -m > "$CHECK"
    sleep 1

    if grep -qs -i 'armv7l' cat "$CHECK" ; then
        if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ]; then
            echo "   >>>>   All Config $PACKAGE Files found   <<<<"
            sleep 2
        else
            set -e
            echo "Downloading Config $PACKAGE Please Wait ......"
            wget $MY_URL/astra-arm.tar.gz -qP $TMPDIR
            tar -xzf $TMPDIR/astra-arm.tar.gz -C $TMPDIR
            mv $TMPDIR/astra-arm $TMPDIR/${PACKAGE}
            set +e
            chmod -R 755 ${TMPDIR}/${PACKAGE}
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

    elif grep -qs -i 'mips' cat "$CHECK" ; then
        if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ]; then
            echo "   >>>>   All Config $PACKAGE Files found   <<<<"
            sleep 2
        else
            set -e
            echo "Downloading Config $PACKAGE Please Wait ......"
            wget $MY_URL/astra-mips.tar.gz -qP $TMPDIR
            tar -xzf $TMPDIR/astra-mips.tar.gz -C $TMPDIR
            mv $TMPDIR/astra-mips $TMPDIR/${PACKAGE}
            set +e
            chmod -R 755 ${TMPDIR}/${PACKAGE}
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
    fi
elif [ $OSTYPE = "DreamOS" ]; then
    if [ -f $ASTRACONF ] && [ -f $ABERTISBIN ] && [ -f $SYSCONF ] && [ -f $ASTRABIN ] && [ -f $SPAMMERBIN ] && [ -f $T2MBIN ] && [ -f $ASTRASM ]; then
        echo "   >>>>   All Config $PACKAGE Files found   <<<<"
        sleep 2
    else
        set -e
        echo "Downloading And Insallling Config $PACKAGE Please Wait ......"
        wget $MY_URL/astra-dreamos.tar.gz -qP $TMPDIR
        tar -xzf $TMPDIR/astra-dreamos.tar.gz -C $TMPDIR
        mv $TMPDIR/astra-dreamos $TMPDIR/${PACKAGE}
        set +e
        chmod -R 755 ${TMPDIR}/${PACKAGE}
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
            cp -f $CONFIGt2midecaptmp $BINPATH > /dev/null 2>&1
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
        if [ ! -f $ASTRASM ]; then
            cp -f $CONFIGastrasmtmp $ETCPATH/init.d > /dev/null 2>&1
            echo "[send (astra-sm) file]"
        fi
        echo "---------------------------------------------"
    fi
fi

#########################
# Remove files (if any) #
rm -rf ${TMPDIR}/channels_backup_user_${VERSION}* astra-* bbc_pmt_v6*

sync
echo ""
echo ""
echo "*********************************************************"
echo "#       Channel And Config INSTALLED SUCCESSFULLY       #"
echo "#                    MOHAMED_OS                         #"
echo "#                     support                           #"
echo "#  https://www.tunisia-sat.com/forums/threads/4208717   #"
echo "*********************************************************"
echo "#           your Device will RESTART Now                #"
echo "*********************************************************"
sleep 2

if [ $OSTYPE = "Opensource" ]; then
    sleep 2; init 3
else
    sleep 2; systemctl restart enigma2
fi

exit 0
