# -*- coding: utf-8 -*-
# code: BY MOHAMED_OS


from __future__ import print_function

import tarfile
from datetime import datetime
from os import chdir, chmod, remove, system, uname
from os.path import exists, isfile, join
from re import MULTILINE, findall
from sys import version_info

if version_info.major == 3:
    from urllib.error import HTTPError, URLError
    from urllib.request import Request, urlopen, urlretrieve
else:
    from urllib import urlretrieve

    from urllib2 import HTTPError, Request, URLError, urlopen

# colors
C = "\033[0m"     # clear (end)
R = "\033[0;31m"  # red (error)
G = "\033[0;32m"  # green (process)
B = "\033[0;36m"  # blue (choice)
Y = "\033[0;33m"  # yellow (info)


class Setting():
    URL_DOW = 'https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel/'
    url = 'https://github.com/MOHAMED19OS/Download/tree/main/Channel'

    def __init__(self):
        self.link = Setting.URL_DOW
        self.page = Setting.url
        self.package = []
        self.file_info = []
        self.date = datetime.now().strftime("%d-%m-%Y %X")
        self.path_abertis = '/etc/astra/scripts/abertis'
        self.path_astra = '/etc/astra/astra.conf'

    def banner(self):
        system('clear')
        print(B, r"""

 .d8888b.  888                                          888
d88P  Y88b 888                                          888
888    888 888                                          888
888        88888b.   8888b.  88888b.  88888b.   .d88b.  888
888        888 "88b     "88b 888 "88b 888 "88b d8P  Y8b 888
888    888 888  888 .d888888 888  888 888  888 88888888 888
Y88b  d88P 888  888 888  888 888  888 888  888 Y8b.     888
 "Y8888P"  888  888 "Y888888 888  888 888  888  "Y8888  888
""", C, end='')
        print("   Install\n".rjust(30))
        print("Written by {}MOHAMED_OS{} {}(͡๏̯͡๏){}\n".format(
            B, C, Y, C).rjust(73), end='')
        print((self.date).rjust(35))

    def info(self):
        try:
            req = Request(self.page)
            req.add_header(
                'User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0')
            response = urlopen(req)
            link = response.read().decode('utf-8')
            self.version = findall(
                r'href=.*?\/Channel.*?">channels_backup_user_(.*?).tar.gz', link)[0]
            self.file_tar = findall(
                r'href=.*?\/Channel\/channels.*?">(.*?)<', link)[0]
            for name in [self.version, self.file_tar]:
                self.file_info.append(name)
        except HTTPError as e:
            print('HTTP Error code: ', e.code)
        except URLError as e:
            print('URL Error: ', e.reason)

    def image(self):
        return exists('/etc/opkg/opkg.conf')

    def check(self):
        self.pkg = []
        with open('/var/lib/opkg/status') as f:
            for items in f.readlines():
                if items.startswith('Package:'):
                    self.pkg.append(items[items.index(' '):].strip())
        for p in ['astra-sm', 'dvbsnoop']:
            if p not in self.pkg:
                self.package.append(p)

    def delete(self):
        for file in ['lamedb', '*list', '*.tv', '*.radio', '*.xml']:
            if file != '*.xml':
                self.path_dir = '/etc/enigma2/'
            else:
                self.path_dir = '/etc/tuxbox/'
            if isfile(join(self.path_dir, file)):
                remove(join(self.path_dir, file))

    def main(self):
        build.check()
        build.banner()

        if build.image():
            if self.package:
                system('opkg update >/dev/null 2>&1')
                for pkg in self.package:
                    system('clear')
                    print("   >>>>   {}Please Wait{} while we Install {}{}{} ...".format(
                        B, C, Y, pkg, C))
                    system('opkg install {}'.format(pkg))

        chdir('/tmp')

        if isfile(self.file_info[-1]):
            remove(self.file_info[-1])

        build.delete()

        system('clear')
        print("{}Downloading{} And Installing Channel {}Please Wait{} {}......{}".format(
            Y, C, R, C, G, C))

        try:
            urlretrieve("".join([self.link, self.file_info[-1]]),
                        filename=self.file_info[-1])
            with tarfile.open(self.file_info[-1]) as f:
                f.extractall('/')
            f.close()
            if isfile(self.file_info[-1]):
                remove(self.file_info[-1])
        except:
            print('No File Found')
            exit()

        urlretrieve('http://127.0.0.1/web/servicelistreload?mode=0')

        if build.image():
            with open('/etc/sysctl.conf', 'r+') as f:
                if not findall('net.core.rmem_default', f.read(), MULTILINE):
                    f.writelines("""\n
## added for Abertis ###
net.core.rmem_default = 16777216
net.core.rmem_max = 16777216
net.core.wmem_default = 16777216
net.core.wmem_max = 16777216
net.ipv4.udp_mem = 8388608 12582912 16777216
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 65536 8388608
net.ipv4.tcp_tw_recycle = 0""")
            f.close()

            if isfile(self.path_astra):
                remove(self.path_astra)
            urlretrieve(
                "".join([self.link, self.path_astra[11:]]), self.path_astra)
            chmod(self.path_astra, 0o755)

            if exists(self.path_abertis):
                remove(self.path_abertis)

            for name in ['armv7l', 'mips']:
                if uname()[4] == name:
                    urlretrieve(
                        "".join([self.link, join('astra-sm/', name, self.path_abertis[19:])]), self.path_abertis)
            chmod(self.path_abertis, 0o755)

            system('sleep 3;init 6')
        else:
            system('systemctl restart enigma2')


if __name__ == '__main__':
    build = Setting()
    build.info()
    build.main()
