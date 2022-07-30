# -*- coding: utf-8 -*-
# code: BY MOHAMED_OS

# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Emu
# ###########################################
#
# Command: python -c "$(wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Emu/installer.py -qO -)"
#
# ###########################################

from zlib import decompress
from base64 import b64decode

exec(decompress(b64decode('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')))
