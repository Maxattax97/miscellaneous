FROM archlinux:latest

RUN pacman -Syu --noconfirm git curl

RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
	cd /tmp/yay && \
	makepkg -si --noconfirm && \
	rm -rf /tmp/yay

RUN git clone https://github.com/Maxattax97/miscellaneous /root/miscellaneous

WORKDIR /root/miscellaneous

RUN ./install.sh

WORKDIR /root

ENTRYPOINT ["/bin/zsh"]
