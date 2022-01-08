#!/usr/bin/python
# -*- coding: utf-8 -*-
# _^ code BY: MOHAMED_OS ^_

from __future__ import print_function

import os
try:
    import subprocess as sp
except ImportError:
    import commands as sp

package = 'libcurl4'
oscam_Ver = '11.704-emu-r798'
oscam_Package = 'enigma2-plugin-softcams-oscam'
ncam_Ver = 'V12.4-r1'
ncam_Package = 'enigma2-plugin-softcams-ncam'
path_site = 'https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Oscam_Ncam'


def Opensource():
    if os.path.exists('/var/lib/opkg/status'):
        return Opensource


def DreamOS():
    if os.path.exists('/var/lib/dpkg/status'):
        return DreamOS


def install():
    if DreamOS():
        opkg = 'apt-get'
        return opkg
    elif Opensource():
        opkg = 'opkg'
        return opkg


def Install_Package():
    check = sp.getoutput(
        "{:s} list-installed {:s} | awk '{{print $1}}'".format(install(), package))
    if check == package:
        pass
    else:
        if Opensource():
            os.system(
                '{:s} update >/dev/null 2>&1; {:s} install {:s}'.format(install(), install(), package))
        elif DreamOS():
            os.system(
                '{:s} update >/dev/null 2>&1; {:s} install {:s} -y'.format(install(), install(), package))
        else:
            print("   >>>>   Feed Missing {:s}   <<<<\n   >>>>   Notification Emu will not work without {:s}   <<<<".format(
                package, package))


def Remove_Oscam():
    checked = sp.getoutput(
        "{:s} list-installed {}* | awk '{{print $1}}'".format(install(), oscam_Package))
    if bool(checked) is True:
        if Opensource():
            os.system(
                '{:s} remove --force-depends {:s}'.format(install(), checked))
        elif DreamOS():
            os.system(
                '{:s} purge --auto-remove {:s}'.format(install(), checked))
    else:
        pass


def Remove_Ncam():
    checked = sp.getoutput(
        "{:s} list-installed {:s} | awk '{{print $1}}'".format(install(), ncam_Package))
    if bool(checked) is True:
        if Opensource():
            os.system(
                '{:s} remove --force-depends {:s}'.format(install(), ncam_Package))
        elif DreamOS():
            os.system(
                '{:s} purge --auto-remove {:s}'.format(install(), ncam_Package))
    else:
        pass


def Install_Menu():
    if Opensource():

        choice = True
        while choice:
            print("""
            > Oscam EMU MENU\n
            1 - Oscam
            2 - Ncam
            3 - SupTV_Oscam
            4 - Revcam_Oscam\n
            x - Exit\n
            """)
            try:
                choice = str(input("Please make a choice: "))
            except EOFError:
                pass

            if choice == "1":
                Remove_Oscam()
                print("Insallling Oscam plugin Please Wait ......")
                os.system(
                    '{:s} install {:s}/{:s}_{:s}_all.ipk'.format(install(), path_site, oscam_Package, oscam_Ver))
            elif choice == "2":
                Remove_Ncam()
                print("Insallling Ncam plugin Please Wait ......")
                os.system(
                    '{:s} install {:s}/{:s}_{:s}_all.ipk'.format(install(), path_site, ncam_Package, ncam_Ver))
            elif choice == "3":
                Remove_Oscam()
                print("Insallling SupTV_Oscam plugin Please Wait ......")
                os.system(
                    '{:s} install {:s}/{:s}-supcam_{:s}_all.ipk'.format(install(), path_site, oscam_Package, oscam_Ver))
            elif choice == "4":
                Remove_Oscam()
                print("Insallling Revcam_Oscam plugin Please Wait ......")
                os.system(
                    '{:s} install {:s}/{:s}-revcamv2_{:s}_all.ipk'.format(install(), path_site, oscam_Package, oscam_Ver))
            elif choice == "x":
                os.system('clear')
                print("Goodbye ;)")
                break
            else:
                print("I don't understand your choice.".title())
                break

    elif DreamOS():

        choice = True
        while choice:
            print("""
            > Oscam EMU MENU\n
            1 - Oscam
            2 - Ncam
            3 - Revcam_Oscam\n
            x - Exit\n
            """)
            try:
                choice = str(input("Please make a choice: "))
            except EOFError:
                pass

            if choice == "1":
                Remove_Oscam()
                print("Insallling Oscam plugin Please Wait ......")
                os.system(
                    'dpkg -i --force-overwrite install {:s}/{:s}_{:s}_all.deb'.format(path_site, oscam_Package, oscam_Ver))
            elif choice == "2":
                Remove_Ncam()
                print("Insallling Ncam plugin Please Wait ......")
                os.system(
                    'dpkg -i --force-overwrite install {:s}/{:s}_{:s}_all.deb'.format(path_site, ncam_Package, ncam_Ver))
            elif choice == "3":
                Remove_Oscam()
                print("Insallling Revcam_Oscam plugin Please Wait ......")
                os.system(
                    'dpkg -i --force-overwrite install {:s}/{:s}-revcamv2_{:s}_all.deb'.format(path_site, oscam_Package, oscam_Ver))
            elif choice == "x":
                os.system('clear')
                print("Goodbye ;)")
                break
            else:
                print("I don't understand your choice.".title())
                break


if __name__ == '__main__':
    Install_Package()
    Install_Menu()
