#!/bin/sh
#### "*******************************************"
#### "              Created By RAED              *"
#### "*        << Edited by  MOHAMED_OS >>       *"
#### "*        ..:: www.tunisia-sat.com ::..     *"
#### "*******************************************"

/usr/ppteam/Oscam_Supcam_cam.pp stop
killall -9 oscam 2>/dev/null


rm -rf /usr/bin/oscam
rm -rf /usr/ppteam/Oscam_Supcam_cam.pp
rm -rf /usr/ppuninstall/Oscam_Supcam_delfile.pp

exit 0
