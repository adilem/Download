# coding: utf-8

# code: BY MOHAMED_OS


from __future__ import print_function

import tarfile
from datetime import datetime
from os import chdir, chmod, remove, system, uname
from os.path import exists, isfile
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


URL = 'https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel/'


def banner():

    system('clear')
    print(B)
    print(r"""
 ,-----.,--.       ,---.          ,--.  ,--.       ,--.
'  .--./|  ,---.  /  O  \ ,--,--, |  ,'.|  | ,---. |  |
|  |    |  .-.  ||  .-.  ||      \|  |' '  || .-. :|  |
'  '--'\|  | |  ||  | |  ||  ||  ||  | `   |\   --.|  '--.
 `-----'`--' `--'`--' `--'`--''--'`--'  `--' `----'`-----'
""", end='')
    print("{}   Install\n".format(C).rjust(30))
    print("   Written by {}MOHAMED_OS{} {}(͡๏̯͡๏){}\n".format(B, C, Y, C), end='')
    print((datetime.now().strftime("%d-%m-%Y %X")).rjust(25))


def image():
    return exists('/etc/opkg/opkg.conf')


def check(package):
    with open('/var/lib/opkg/status') as f:
        for items in f.readlines():
            if items.startswith('Package:'):
                if findall(package, items[items.index(' '):].strip(), MULTILINE):
                    return package


def info():
    try:
        req = Request('{}version'.format(URL))
        req.add_header(
            'User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0')
        response = urlopen(req)
        link = response.read().decode('utf-8')
        return link.strip()
    except HTTPError as e:
        print('HTTP Error code: ', e.code)
    except URLError as e:
        print('URL Error: ', e.reason)


def delete():
    if isfile('/etc/enigma2/lamedb'):
        remove('/etc/enigma2/lamedb')
    elif isfile('/etc/enigma2/*list'):
        remove('/etc/enigma2/*list')
    elif isfile('/etc/enigma2/*.tv'):
        remove('/etc/enigma2/*.tv')
    elif isfile('/etc/enigma2/*.radio'):
        remove('/etc/enigma2/*.radio')
    elif isfile('/etc/tuxbox/*.xml'):
        remove('/etc/tuxbox/*.xml')


def main():

    PathAbertis = '/etc/astra/scripts/abertis'
    PathAstra = '/etc/astra/astra.conf'
    Setting = 'channels_backup_user_{}.tar.gz'.format(info())

    banner()

    if image():
        system('opkg update >/dev/null 2>&1')
        for pkg in ['astra-sm', 'dvbsnoop']:
            while not check(pkg):
                system('clear')
                print("   >>>>   {}Please Wait{} while we Install {}{}{} ...".format(
                    B, C, Y, pkg, C))
                system('opkg install {}'.format(pkg))

    chdir('/tmp')

    if isfile(Setting):
        remove(Setting)

    delete()

    system('clear')
    print("{}Downloading{} And Installing Channel {}Please Wait{} {}......{}".format(
        Y, C, R, C, G, C))

    urlretrieve("".join([URL, Setting]), filename=Setting)

    with tarfile.open(Setting) as f:
        f.extractall('/')
        f.close()

    if isfile(Setting):
        remove(Setting)

    urlretrieve('http://127.0.0.1/web/servicelistreload?mode=0')

    if image():
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

        with open('/etc/enigma2/settings', 'r+') as s:
            if not findall('config.streaming.stream_ecm', f.read(), MULTILINE):
                s.write('config.streaming.stream_ecm=True')
                s.close()

        if isfile(PathAstra):
            remove(PathAstra)

        urlretrieve("".join([URL, 'astra.conf']), PathAstra)
        chmod(PathAstra, 0o755)

        if exists(PathAbertis):
            remove(PathAbertis)

        for name in ['armv7l', 'mips']:
            if uname()[4] == name:
                urlretrieve(
                    "".join([URL, 'astra-sm/{}/abertis'.format(name)]), PathAbertis)
        chmod(PathAbertis, 0o755)

        system('sleep 3;init 6')
    else:
        system('systemctl restart enigma2')


if __name__ == '__main__':
    main()
    banner()
