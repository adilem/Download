# code: BY MOHAMED_OS


from __future__ import print_function

from os import path, system, remove, chdir
from re import findall, match, MULTILINE
from datetime import datetime
from sys import version_info
from time import sleep
from json import loads

if version_info.major == 3:
    from urllib.request import Request, urlopen, urlretrieve
    from urllib.error import URLError, HTTPError
else:
    from urllib2 import Request, urlopen, URLError, HTTPError
    from urllib import urlretrieve

package = 'enigma2-plugin-softcams-'
URL = 'https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Emu/'

# colors
C = "\033[0m"     # clear (end)
R = "\033[0;31m"  # red (error)
G = "\033[0;32m"  # green (process)
B = "\033[0;36m"  # blue (choice)
Y = "\033[0;33m"  # yellow (info)

if hasattr(__builtins__, 'raw_input'):
    input = raw_input


def info(item):
    try:
        req = Request('{}version.json'.format(URL))
        req.add_header(
            'User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0')
        response = urlopen(req)
        link = loads(response.read())
        return link.get(item)
    except HTTPError as e:
        print('HTTP Error code: ', e.code)
    except URLError as e:
        print('URL Error: ', e.reason)


def banner():
    ncam_ver = info('ncam')
    oscam_ver = info('oscam')
    system('clear')
    print(B)
    print(r"""
___________        ____ ___
\_   _____/ _____ |    |   \
 |    __)_ /     \|    |   /
 |        \  Y Y  \    |  /
/_______  /__|_|  /______/
        \/      \/ """, end='')
    print("{} Install\n".format(C))
    print("    {}Oscam{} : {}".format(Y, C, oscam_ver))
    print("    {}Ncam{}  : {}\n".format(Y, C, ncam_ver))


def image():
    global status, update, install, uninstall, extension
    if path.isfile('/etc/opkg/opkg.conf'):
        status = '/var/lib/opkg/status'
        update = 'opkg update >/dev/null 2>&1'
        install = 'opkg install'
        uninstall = 'opkg remove --force-depends'
        extension = 'ipk'
    else:
        status = '/var/lib/dpkg/status'
        update = 'apt-get update >/dev/null 2>&1'
        install = 'apt-get install'
        uninstall = 'apt-get purge --auto-remove'
        extension = 'deb'
    return path.isfile('/etc/opkg/opkg.conf')


def check(package):
    with open(status) as f:
        for items in f.readlines():
            if items.startswith('Package:'):
                if findall(package, items[items.index(' '):].strip(), MULTILINE):
                    return package


def stb_image():
    try:
        if path.isfile('/etc/issue'):
            distro = open('/etc/issue').readlines()[-2].strip()[:-6].split()[0]
            return distro.lower()
        elif path.isfile('/usr/lib/enigma.info'):
            distro = open('/usr/lib/enigma.info').readlines()
            for c in distro:
                if match('distro', c):
                    return c.split('=')[-1].strip().lower()
    except:
        return 'undefined'


def prompt(choices):

    options = list(choices)
    options.sort(key=int)

    while True:
        print(
            "{}(?){} Choose an option [{}-{}] : ".format(B, C, options[0], options[-1]), end='')
        choice = [str(x) for x in input().split()]

        for name in choice:
            if name not in options:
                print("\n{}(!){} Select one of the available options !!\n".format(R, C))
                continue
        return choice


def stb_image():
    try:
        if path.isfile('/etc/issue'):
            image_type = open("/etc/issue").readlines()[-2].strip()[:-6]
            return image_type.split()[0].lower()
        elif path.isfile('/usr/lib/enigma.info'):
            distro = open('/usr/lib/enigma.info').readlines()
            for c in distro:
                if match('distro', c):
                    return c.split('=')[-1].strip().lower()
    except:
        return 'undefined'


def main():
    image()

    if not check('libcurl4'):
        system('clear')
        print("   >>>>   {}Please Wait{} while we Install {}libcurl4{} ...".format(
            G, C, Y, C))
        system('{};{} libcurl4'.format(update, install))

    if stb_image() == 'teamblue':
        if not check('enigma2-plugin-systemplugins-softcamstartup'):
            system('clear')
            print("   >>>>   {}Please Wait{} while we Install {}SoftCam Startup{} ...".format(
                G, C, Y, C))
            system(
                '{};{} enigma2-plugin-systemplugins-softcamstartup'.format(update, install))

    if image():
        cam = {
            "1": "{}oscam".format(package),
            "2": "{}ncam".format(package),
            "3": "{}powercam".format(package),
            "4": "{}revcam".format(package),
            "5": "{}gosatplus".format(package),
            "6": "{}supcam-oscam".format(package),
            "7": "{}revcam-oscam".format(package),
            "8": "{}gosatplus-oscam".format(package),
            "9": "{}powercam-oscam".format(package),
            "10": "{}supcam-ncam".format(package),
            "11": "{}powercam-ncam".format(package),
            "12": "{}revcam-ncam".format(package),
            "13": "{}gosatplus-ncam".format(package),
        }
        menu = """
        (1) Oscam       (6)  SupTV_Oscam        (11) PowerCam_Ncam
        (2) Ncam        (7)  Revcam_Oscam       (12) Revcam_Ncam
        (3) PowerCam    (8)  GosatPlus_Oscam    (13) GosatPlus_Ncam
        (4) Revcam      (9)  PowerCam_Oscam
        (5) GosatPlus   (10) SupTV_Ncam
        """
    else:
        cam = {
            "1": "{}oscam".format(package),
            "2": "{}ncam".format(package),
            "3": "{}revcam".format(package),
            "4": "{}powercam".format(package),
            "5": "{}gosatplus".format(package)
        }
        menu = """
        (1) Oscam          (2) Ncam          (3) Revcam
        (4) PowerCam       (5) GosatPlus
        """

    banner()

    print(menu)

    choice = prompt(cam.keys())

    for number in choice:
        value = cam.get(number)
        file = "{}_{}_all.{}".format(
            value, info(value.split('-')[-1]), extension)

        if check(value):
            system('{} {} '.format(uninstall, value))
            sleep(2)

        if path.isfile(file):
            remove(file)
            sleep(0.8)

        chdir('/tmp')

        system('clear')
        print("{}Please Wait{} while we Download And Install {}{}{} ...".format(
            G, C, Y, value, C))

        urlretrieve("".join([URL, file]), filename=file)
        sleep(0.8)

        system(" ".join([install, file]))
        sleep(1)


if __name__ == '__main__':
    main()
    banner()
    print("   Written by {}MOHAMED_OS{} (͡๏̯͡๏)".format(R, C))
    print((datetime.now().strftime("%d-%m-%Y %X")).rjust(25))
    print()
