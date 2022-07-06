#!/bin/bash
# coding BY: MOHAMED_OS

package_list=(wget curl astra-sm dvbsnoop nano ffmpeg gstplayer exteplayer3 enigma2-plugin-systemplugins-serviceapp enigma2-plugin-extensions-epgimport enigma2-plugin-systemplugins-automaticcleanup enigma2-plugin-extensions-clearmem gstreamer1.0-plugins-good gstreamer1.0-plugins-base gstreamer1.0-plugins-bad-meta gstreamer1.0-plugins-ugly libgstplayer-1.0-0 enigma2-plugin-drivers-ntfs-3g enigma2-plugin-drivers-exfat enigma2-plugin-extensions-chromium2)
path_dir=(AJPan ArabicSavior FootOnSat IPAudio IPTVPlayer KeyAdder Quran RaedQuickSignal SubsSupport YouTube NewVirtualKeyBoard)
stb_image=$(cut </etc/opkg/all-feed.conf -d'-' -f1 | awk '{ print $2 }')
SETTINGS='/etc/enigma2/settings'

########################
if [ -f /etc/opkg/opkg.conf ]; then
        STATUS='/var/lib/opkg/status'
        OSTYPE='Opensource'
        OPKG='opkg update'
        OPKGINSTAL='opkg install'
fi

install() {
        if grep -qs "Package: $1" $STATUS; then
                echo
                clear
        else
                $OPKG >/dev/null 2>&1
                echo "   >>>>   Need to install $1   <<<<"
                echo
                $OPKGINSTAL "$1"
                sleep 1
                clear
        fi
}

if [ "$stb_image" = egami ]; then
        delete='enigma2-plugin-extensions-clearmem'
        package_list+=(qtwebengine enigma2-plugin-extensions-kodi)
        for i in "${package_list[@]/$delete/}"; do install "$i"; done
elif [ "$stb_image" = openatv ]; then
        package_list+=(enigma2-plugin-skins-metrix-atv-fhd-icons enigma2-plugin-skins-madmax-impossible)
        for i in "${package_list[@]}"; do install "$i"; done
else
        for i in "${package_list[@]}"; do install "$i"; done
fi

check() {
        if [ -d /usr/lib/enigma2/python/Plugins/Extensions/"$1" ]; then
                return 1
        elif [ -d /usr/lib/enigma2/python/Plugins/SystemPlugins/"$1" ]; then
                return 1
        fi
}

for d in "${path_dir[@]}"; do
        if check "$d"; then
                if [ AJPan = "$d" ]; then
                        wget https://raw.githubusercontent.com/biko-73/AjPanel/main/installer.sh -qO - | /bin/sh
                elif [ ArabicSavior = "$d" ]; then
                        wget https://raw.githubusercontent.com/fairbird/ArabicSavior/main/installer.sh -qO - | /bin/sh
                elif [ FootOnSat = "$d" ]; then
                        wget https://raw.githubusercontent.com/ziko-ZR1/FootOnsat/main/Download/install.sh -qO - | /bin/sh
                elif [ IPAudio = "$d" ]; then
                        wget http://ipkinstall.ath.cx/ipaudio/installer.sh -qO - | /bin/sh
                elif [ IPTVPlayer = "$d" ]; then
                        wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/E2IPLAYER_TSiplayer/installer.sh -qO - | /bin/sh
                elif [ KeyAdder = "$d" ]; then
                        wget https://raw.githubusercontent.com/fairbird/KeyAdder/main/installer.sh -qO - | /bin/sh
                elif [ Quran = "$d" ]; then
                        wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Quran/installer.sh -qO - | /bin/sh
                elif [ RaedQuickSignal = "$d" ]; then
                        wget https://raw.githubusercontent.com/fairbird/RaedQuickSignal/main/installer.sh -qO - | /bin/sh
                elif [ SubsSupport = "$d" ]; then
                        wget https://raw.githubusercontent.com/biko-73/SubsSupport/main/installer.sh -qO - | /bin/sh
                elif [ YouTube = "$d" ]; then
                        wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/YouTube/installer.sh -qO - | /bin/sh
                elif [ NewVirtualKeyBoard = "$d" ]; then
                        wget https://raw.githubusercontent.com/fairbird/NewVirtualKeyBoard/main/installer.sh -qO - | /bin/sh
                fi
        fi
        if ! check "$d"; then
                echo "Add Setting To $d ..."
                init 4
                sleep 5
                if [ AJPan = "$d" ]; then
                        sed -e s/config.plugins.AJPanel.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.AJPanel.autoResetFrozenIptvChan=true"
                                echo "config.plugins.AJPanel.backupPath=/media/mmc/Backup/"
                                echo "config.plugins.AJPanel.checkForUpdateAtStartup=true"
                                echo "config.plugins.AJPanel.downloadedPackagesPath=/media/mmc/Backup/"
                                echo "config.plugins.AJPanel.exportedPIconsPath=/media/mmc/Backup/"
                                echo "config.plugins.AJPanel.exportedTablesPath=/media/mmc/Backup/"
                                echo "config.plugins.AJPanel.hideIptvServerAdultWords=true"
                                echo "config.plugins.AJPanel.hideIptvServerChannPrefix=true"
                                echo "config.plugins.AJPanel.iptvAddToBouquetRefType=5002"
                                echo "config.plugins.AJPanel.MovieDownloadPath=/media/mmc/Downlaod/"
                                echo "config.plugins.AJPanel.packageOutputPath=/media/mmc/Backup/"
                                echo "config.plugins.AJPanel.PIconsPath=/media/mmc/picon/"
                        } >>"${SETTINGS}"
                elif [ ArabicSavior = "$d" ]; then
                        sed -e s/config.ArabicSavior.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.ArabicSavior.fonts=/usr/lib/enigma2/python/Plugins/Extensions/ArabicSavior//fonts/Khalid-Art-bold.ttf"
                        } >>"${SETTINGS}"
                elif [ IPAudio = "$d" ]; then
                        sed -e s/config.plugins.IPAudio.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.IPAudio.skin=light"
                                echo "config.plugins.IPAudio.volLevel=5"
                        } >>"${SETTINGS}"
                elif [ IPTVPlayer = "$d" ]; then
                        sed -e s/config.plugins.iptvplayer.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.iptvplayer.AktualizacjaWmenu=false"
                                echo "config.plugins.iptvplayer.SciezkaCache=/media/mmc/Player/"
                                echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer=extgstplayer"
                                echo "config.plugins.iptvplayer.alternativeARMV7MoviePlayer0=extgstplayer"
                                echo "config.plugins.iptvplayer.buforowanie_m3u8=false"
                                echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer=exteplayer"
                                echo "config.plugins.iptvplayer.defaultARMV7MoviePlayer0=exteplayer"
                                echo "config.plugins.iptvplayer.remember_last_position=true"
                                echo "config.plugins.iptvplayer.extplayer_infobanner_clockformat=24"
                                echo "config.plugins.iptvplayer.extplayer_skin=halidri1080p1"
                                echo "config.plugins.iptvplayer.plarform=armv7"
                                echo "config.plugins.iptvplayer.dukpath=/usr/bin/duk"
                                echo "config.plugins.iptvplayer.wgetpath=wget"
                                echo "config.plugins.iptvplayer.NaszaSciezka=/media/mmc/Player/"
                                echo "config.plugins.iptvplayer.osk_type=system"
                        } >>"${SETTINGS}"
                elif [ KeyAdder = "$d" ]; then
                        sed -e s/config.plugins.KeyAdder.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.KeyAdder.custom_softcampath=/etc/tuxbox/config"
                                echo "config.plugins.KeyAdder.softcampath=true"
                        } >>"${SETTINGS}"
                elif [ RaedQuickSignal = "$d" ]; then
                        sed -e s/coconfig.plugins.RaedQuickSignal.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.RaedQuickSignal.city=el eulma"
                                echo "config.plugins.RaedQuickSignal.keyname=KEY_INFO"
                                echo "config.plugins.RaedQuickSignal.numbers=Resolution"
                                echo "config.plugins.RaedQuickSignal.refreshInterval=30"
                                echo "config.plugins.RaedQuickSignal.style=AGC3"
                                echo "config.plugins.RaedQuickSignal.weather_location=dz-DZ"
                        } >>"${SETTINGS}"
                elif [ YouTube = "$d" ]; then
                        sed -e s/config.plugins.AJPanel.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.YouTube.downloadDir=/media/mmc/Downlaod/"
                                echo "config.plugins.YouTube.maxResolution=37"
                                echo "config.plugins.YouTube.onMovieEof=playnext"
                                echo "config.plugins.YouTube.onMovieStop=quit"
                                echo "config.plugins.YouTube.player=5002"
                                echo "config.plugins.YouTube.searchLanguage="
                                echo "config.plugins.YouTube.searchRegion="
                        } >>"${SETTINGS}"
                elif [ NewVirtualKeyBoard = "$d" ]; then
                        sed -e s/config.plugins.AJPanel.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.NewVirtualKeyBoard.firsttime=false"
                                echo "config.NewVirtualKeyBoard.keys_layout=00000401"
                                echo "config.NewVirtualKeyBoard.lastsearchText=el eulma"
                                echo "config.NewVirtualKeyBoard.showinplugins=false"
                                echo "config.NewVirtualKeyBoard.textinput=NewVirtualKeyBoard"
                        } >>"${SETTINGS}"
                elif [ SubsSupport = "$d" ]; then
                        sed -e s/config.plugins.subtitlesSupport.*//g -i "${SETTINGS}"
                        sleep 2
                        {
                                echo "config.plugins.subtitlesSupport.encodingsGroup=Arabic"
                                echo "config.plugins.subtitlesSupport.search.lang1=ar"
                                echo "config.plugins.subtitlesSupport.search.lang2=ar"
                                echo "config.plugins.subtitlesSupport.search.lang3=ar"
                        } >>"${SETTINGS}"
                fi
        fi
done

echo "Add Setting To Chromium ..."
sed -e s/config.plugins.Chromium.*//g -i "${SETTINGS}"
sleep 2
{
        echo "config.plugins.Chromium.presets.0.portal=https://www.opena.tv"
        echo "config.plugins.Chromium.presets.1.portal=https://www.netflix.com/GB/login"
        echo "config.plugins.Chromium.presets.2.portal=https://www.youtube.com/tv"
        echo "config.plugins.Chromium.presets.3.portal=https://www.disneyplus.com/en-gb/"
        echo "config.plugins.Chromium.presets.4.portal=https://www.dazn.com/en-GB/signin"
        echo "config.plugins.Chromium.presets.5.portal=https://www.primevideo.com/offers/nonprimehomepage/ref=atv_nb_lcl_en_GB"
        echo "config.plugins.Chromium.presets.6.portal=https://www.joyn.de/"
        echo "config.plugins.Chromium.presets.7.portal=https://www.beinsports.com"
        echo "config.plugins.Chromium.presets.8.portal=https://www.blutv.com/int"
        echo "config.plugins.Chromium.presets.9.portal=https://www.canalplus.com/"
        echo "config.plugins.Chromium.presets.10.portal=https://www.digiturkplay.com/"
        echo "config.plugins.Chromium.presets.11.portal=https://www.dsmartgo.com.tr/anasayfa"
        echo "config.plugins.Chromium.presets.12.portal=https://connect.bein.com/"
        echo "config.plugins.Chromium.showinpluginmenu1=false"
        echo "config.plugins.Chromium.showinpluginmenu2=false"
        echo "config.plugins.Chromium.showinpluginmenu3=false"
        echo "config.plugins.Chromium.showinpluginmenu4=false"
        echo "config.plugins.Chromium.showinpluginmenu5=false"
} >>"${SETTINGS}"

echo "Add Setting To WeatherPlugin ..."
sed -e s/config.plugins.WeatherPlugin.*//g -i "${SETTINGS}"
sleep 2
{
        echo "config.plugins.WeatherPlugin.Entry.0.city=El Eulma, Algeria"
        echo "config.plugins.WeatherPlugin.Entry.0.weatherlocationcode=wc:AGXX0016"
        echo "config.plugins.WeatherPlugin.entrycount=1"
} >>"${SETTINGS}"

init 3
