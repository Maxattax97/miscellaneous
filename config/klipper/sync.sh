#! /bin/sh

scp printer-creality-ender3-v2-mod.cfg forge@mainsailos.local:/home/forge/printer_data/config/printer.cfg
scp crowsnest-raspicam-v2.1.cfg forge@mainsailos.local:/home/forge/printer_data/config/crowsnest.conf

scp accelerometer-adxl345-usb.cfg forge@mainsailos.local:/home/forge/printer_data/config/
scp moonraker.conf forge@mainsailos.local:/home/forge/printer_data/config/

scp PRINT_START.cfg forge@mainsailos.local:/home/forge/printer_data/config/
scp PRINT_END.cfg forge@mainsailos.local:/home/forge/printer_data/config/
scp PRESENT_PRINT.cfg forge@mainsailos.local:/home/forge/printer_data/config/
scp PURGE_LINE.cfg forge@mainsailos.local:/home/forge/printer_data/config/
scp TEST_SPEED.cfg forge@mainsailos.local:/home/forge/printer_data/config/
