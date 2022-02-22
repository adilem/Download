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
PACKAGE='astra-sm'
DVBSNOOP='dvbsnoop'
VERSION='2022_02_22'
MY_URL='https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel'

########################
# Path of Config Files #
BINPATH=/usr/bin
ETCPATH=/etc
ASTRAPATH=${ETCPATH}/astra
######
BBCPMT=${BINPATH}/bbc_pmt_starter.sh
BBCPY=${BINPATH}/bbc_pmt_v6.py
BBCENIGMA=${BINPATH}/enigma2_pre_start.sh
######
SYSCONF=${ETCPATH}/sysctl.conf
ASTRACONF=${ASTRAPATH}/astra.conf
ABERTISBIN=${ASTRAPATH}/scripts/abertis
###############################
# Path of Config Files in Tmp #
CONFIGpmttmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_starter.sh
CONFIGpytmp=${TMPDIR}/bbc_pmt_v6/bbc_pmt_v6.py
CONFIGentmp=${TMPDIR}/bbc_pmt_v6/enigma2_pre_start.sh
CONFIGsysctltmp=${TMPDIR}/${PACKAGE}/sysctl.conf
CONFIGastratmp=${TMPDIR}/${PACKAGE}/astra.conf
CONFIGabertistmp=${TMPDIR}/${PACKAGE}/abertis
####################
#  Image Checking  #
if [ -f /etc/opkg/opkg.conf ]; then
    STATUS='/var/lib/opkg/status'
    OSTYPE='Opensource'
    OPKG='opkg update'
    OPKGINSTAL='opkg install'
fi

###########################
# Remove Channel (if any) #
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*list
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/tuxbox/*.xml

#####################
#  Checking Package #
if [ $OSTYPE = "Opensource" ]; then
    if grep -qs "Package: $PACKAGE" $STATUS; then
        echo
    else
        $OPKG >/dev/null 2>&1
        echo " Downloading And Insallling $PACKAGE ......"
        $OPKGINSTAL $PACKAGE
    fi
    if grep -qs "Package: $DVBSNOOP" $STATUS; then
        echo
    else
        $OPKG >/dev/null 2>&1
        echo " Downloading And Insallling $DVBSNOOP ......"
        $OPKGINSTAL $DVBSNOOP
    fi
    if grep -qs "Package: $PACKAGE" $STATUS; then
        echo
    else
        echo "   >>>>   Feed Missing $PACKAGE   <<<<"
        echo "   >>>>   Notification Abertis DTT Channel will not work   <<<<"
    fi
    if grep -qs "Package: $DVBSNOOP" $STATUS; then
        echo
    else
        echo "   >>>>   Feed Missing $DVBSNOOP   <<<<"
    fi
fi

#########################
# Remove files (if any) #
rm -rf ${ASTRACONF} ${SYSCONF}
rm -rf ${TMPDIR}/channels_backup_user_${VERSION}* astra-* bbc_pmt_v6*

###############################
# Downlaod And Install Plugin #
echo
set -e
echo "Downloading And Insallling Channel Please Wait ......"
wget $MY_URL/channels_backup_user_${VERSION}.tar.gz -qP $TMPDIR
tar -zxf $TMPDIR/channels_backup_user_${VERSION}.tar.gz -C /
sleep 5
set +e
echo
echo "   >>>>   Reloading Services - Please Wait   <<<<"
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 >/dev/null 2>&1
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
        cp -f $CONFIGpmttmp $BINPATH >/dev/null 2>&1
        echo "[send (bbc_pmt_starter.sh) file]"
    fi
    if [ ! -f $BBCPY ]; then
        cp -f $CONFIGpytmp $BINPATH >/dev/null 2>&1
        echo "[send (bbc_pmt_v6.py) file]"
    fi
    if [ ! -f $BBCENIGMA ]; then
        cp -f $CONFIGentmp $BINPATH >/dev/null 2>&1
        echo "[send (enigma2_pre_start.sh) file]"
    fi
    echo "---------------------------------------------"
fi

if [ $OSTYPE = "Opensource" ]; then
    if uname -m | grep -qs armv7l; then
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
                cp -f $CONFIGsysctltmp $ETCPATH >/dev/null 2>&1
                echo "[send (sysctl.conf) file]"
            fi
            if [ ! -f $ASTRACONF ]; then
                cp -f $CONFIGastratmp $ASTRAPATH >/dev/null 2>&1
                echo "[send (astra.conf) file]"
            fi
            if [ ! -f $ABERTISBIN ]; then
                cp -f $CONFIGabertistmp $ASTRAPATH/scripts >/dev/null 2>&1
                echo "[send (abertis) file]"
            fi
            echo "---------------------------------------------"
        fi

    elif uname -m | grep -qs mips; then
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
                cp -f $CONFIGsysctltmp $ETCPATH >/dev/null 2>&1
                echo "[send (sysctl.conf) file]"
            fi
            if [ ! -f $ASTRACONF ]; then
                cp -f $CONFIGastratmp $ASTRAPATH >/dev/null 2>&1
                echo "[send (astra.conf) file]"
            fi
            if [ ! -f $ABERTISBIN ]; then
                cp -f $CONFIGabertistmp $ASTRAPATH/scripts >/dev/null 2>&1
                echo "[send (abertis) file]"
            fi
            echo "---------------------------------------------"
        fi
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
    init 6
else
    systemctl restart enigma2
fi

exit 0
