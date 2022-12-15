# -*- coding: utf-8 -*-
# code: BY MOHAMED_OS


from __future__ import print_function

from os import chdir, popen, remove, system
from os.path import isfile
from re import MULTILINE, findall
from sys import version_info
from time import sleep

if version_info[0] == 3:
    from urllib.error import HTTPError, URLError
    from urllib.request import Request, urlopen, urlretrieve
else:
    from urllib import urlretrieve

    from urllib2 import HTTPError, Request, URLError, urlopen

C = "\033[0m"     # clear (end)
R = "\033[0;31m"  # red (error)
G = "\033[0;32m"  # green (process)
B = "\033[0;36m"  # blue (choice)
Y = "\033[0;33m"  # yellow (info)


if hasattr(__builtins__, 'raw_input'):
    input = raw_input


class Novacam():
    URL = 'https://raw.githubusercontent.com/MOHAMED19OS/Download/main/NovCam/'
    page = "https://github.com/MOHAMED19OS/Download/tree/main/NovCam"

    def __init__(self):
        self.package = ['python-requests', 'libusb-1.0-0']

        if version_info[0] == 3:
            self.package = list(
                map(lambda x: x.replace('python', 'python3'), self.package))

    def banner(self):
        system('clear')
        print(B, r"""
    88b 88  dP"Yb  Yb    dP    db         dP""b8    db    8b    d8
    88Yb88 dP   Yb  Yb  dP    dPYb       dP   `"   dPYb   88b  d88
    88 Y88 Yb   dP   YbdP    dP__Yb      Yb       dP__Yb  88YbdP88
    88  Y8  YbodP     YP    dP    Yb      YboodP dP    Yb 88 YY 88""", C)

    def Stb_Image(self):
        if isfile('/etc/opkg/opkg.conf'):
            self.status = '/var/lib/opkg/status'
            self.update = 'opkg update >/dev/null 2>&1'
            self.install = 'opkg install'
            self.uninstall = 'opkg remove --force-depends'

    def package_check(self, name):
        with open(self.status) as file:
            for item in file.readlines():
                if item.startswith('Package:'):
                    if findall(name, item[item.index(' '):].strip(), MULTILINE):
                        return True
            file.close()

    def version_pkg(self, name):
        return popen("opkg info {} | grep Version | awk '{{print $2}}'".format(name)).read().strip()

    def info(self, name):
        try:
            req = Request(self.page)
            req.add_header(
                'User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0')
            response = urlopen(req)
            link = response.read().decode('utf-8')
            return findall(r"".join(['href=.*?\/NovCam\/.*?(.*?', name, '.*?)">']), link)[0]
        except HTTPError as e:
            print('HTTP Error code: ', e.code)
        except URLError as e:
            print('URL Error: ', e.reason)

    def prompt(self, choices):
        options = list(choices)
        while True:
            print(
                "{}(?){} Choose an option [{}-{}] : ".format(B, C, options[0], options[-1]), end='')
            choice = input().strip()

            if choice not in options:
                print(
                    "\n{}(!){} Select one of the available options !!\n".format(R, C))
                continue
            return choice

    def Main_Menu(self):
        print("\n{}(?){} Choose the Plugin Install:".format(B, C))

        menu = """
                    (1) NOVACAM - SUPTV FREE       (2) NOVACAM - SUPTV PREMIUM"""

        print(menu, '\n')

        self.cam = {"1": "suptv-activator", "2": "pr-suptv"}

    def main(self):
        self.Stb_Image()

        self.banner()
        sleep(1)
        print("\n")

        print("\n{}(!){} Please Wait Check Package ...".format(R, C))
        system(self.update)
        sleep(1)

        for pkg_name in self.package:
            if not self.package_check(pkg_name):
                system('clear')
                print("     Need To InsTall : {}{}{}\n".format(Y, pkg_name, C))
                system(" ".join([self.install, pkg_name]))
                sleep(1)

        system('clear')
        self.banner()
        sleep(1)
        print("\n")

        self.Main_Menu()

        if self.prompt(self.cam.keys()) == '1':

            file_name = self.info(self.cam.get('1'))
        else:
            file_name = self.info(self.cam.get('2'))

        if version_info[0] == 3:
            file_ipk = file_name.replace('python2', 'python3')
        else:
            file_ipk = file_name.replace('python3', 'python2')

        if self.version_pkg(file_ipk.split('_')[0]) == file_ipk.split('_')[1]:
            system('clear')
            print('you are use the latest version: {}{}{}\n'.format(
                Y, file_ipk.split('_')[1], C).capitalize())
            sleep(0.8)
            print("   Written by {}MOHAMED_OS{} (͡๏̯͡๏)\n".format(R, C))
            exit()
        else:
            system("".join([self.uninstall, file_ipk.split('_')[0]]))

        system('clear')
        print("{}Please Wait{} while we Download And Install {}NovCam{} ...".format(
            G, C, Y, C))

        chdir('/tmp')

        if isfile(file_ipk):
            remove(file_ipk)
            sleep(0.8)

        urlretrieve("".join([self.URL, file_ipk]), filename=file_ipk)
        sleep(0.8)

        system(" ".join([self.install, file_ipk]))
        sleep(1)

        if isfile(file_ipk):
            remove(file_ipk)
            sleep(0.8)


if __name__ == '__main__':
    build = Novacam()
    build.main()
    print("\n   Written by {}MOHAMED_OS{} (͡๏̯͡๏)\n".format(R, C))
