#!/bin/bash
pactl load-module module-null-sink sink_name=Virtual1
pactl load-module module-loopback source=alsa_input.usb-Corsa_ir_Components_Inc._Corsair_HS60_Surround_Adapter_v0.1-00.mono-fallback sink=Virtual1
pactl load-module module-loopback source=Virtual1.monitor sink=alsa_output.usb-Corsa_ir_Components_Inc._Corsair_HS60_Surround_Adapter_v0.1-00.analog-stereo
