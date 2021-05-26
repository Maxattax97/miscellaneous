all: install

install:
	cp *.timer /usr/lib/systemd/system/
	cp *.service /usr/lib/systemd/system/
	cp *.target /usr/lib/systemd/system/
	cp rig.json /etc/xmrig/rig.json
	sed -i "s/HOSTNAME/$HOST/g" /etc/xmrig/rig.json
	#systemctl enable after-hours.service
	#systemctl enable before-hours.service
