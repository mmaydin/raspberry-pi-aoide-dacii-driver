#!/bin/bash

kernelversion=$(uname -r)

modules=$(<files/modules.alias)

cp files/codecs/* /lib/modules/$kernelversion/kernel/sound/soc/codecs/
cp files/bcm/* /lib/modules/$kernelversion/kernel/sound/soc/bcm/
cp files/overlays/* /boot/overlays/
echo "$modules">>/lib/modules/$kernelversion/modules.alias

depmod -a

cp files/config.txt /boot/

dacs=$(<files/dacs.json)
escapedacs=`echo -e $(printf '%q' $dacs)`
sed -i -e "s/{\"name\":\"Raspberry PI\",\"data\":\[/{\"name\":\"Raspberry PI\",\"data\":\[${escapedacs}/" /volumio/app/plugins/system_controller/i2s_dacs/dacs.json

cards=$(<files/cards.json)
escapecards=`echo -e $(printf '%q' $cards)`
sed -i -e "s/\"cards\": \[/\"cards\": \[${escapecards}/" /volumio/app/plugins/audio_interface/alsa_controller/cards.json
