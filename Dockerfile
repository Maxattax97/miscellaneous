FROM archlinux:latest

RUN pacman -Syu --noconfirm \
	base-devel \
	curl \
	git \
	sudo \
	coreutils \
	--needed

RUN useradd -m max && \
	echo "max ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER max

RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
	cd /tmp/yay && \
	makepkg -si --noconfirm && \
	rm -rf /tmp/yay

# NOTE: This is dangerous because it will include decrypted secrets in the image!
#RUN mkdir -p /home/max/src/miscellaneous
#COPY --chown=max . /home/max/src/miscellaneous/

RUN mkdir -p /home/max/src
RUN git clone https://github.com/Maxattax97/miscellaneous.git /home/max/src/miscellaneous

# Overwrite the install script with the latest one in the repository.
COPY --chown=max install.sh /home/max/src/miscellaneous/install.sh

WORKDIR /home/max/src/miscellaneous
RUN yes | AUTOMATED=1 /home/max/src/miscellaneous/install.sh

WORKDIR /home/max
ENTRYPOINT ["/bin/zsh"]
