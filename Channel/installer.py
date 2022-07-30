# -*- coding: utf-8 -*-
# code: BY MOHAMED_OS

# ###########################################
# SCRIPT : DOWNLOAD AND INSTALL Channel
# ###########################################
#
# Command: wget https://raw.githubusercontent.com/MOHAMED19OS/Download/main/Channel/installer.py -qO - | python
#
# ###########################################

from zlib import decompress
from base64 import b64decode

exec(decompress(b64decode('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')))
