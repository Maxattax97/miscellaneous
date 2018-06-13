#!/bin/bash
if [ -d "_fonts/" ]; then
	rm -rf _fonts/
fi

mkdir _fonts
wget -O _fonts/FreeMono.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMono.otf
wget -O _fonts/FreeMonoBold.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoBold.otf
wget -O _fonts/FreeMonoBoldOblique.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoBoldOblique.otf
wget -O _fonts/FreeMonoOblique.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoOblique.otf
wget -O _fonts/FreeSans.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSans.otf
wget -O _fonts/FreeSansBold.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansBold.otf
wget -O _fonts/FreeSansBoldOblique.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansBoldOblique.otf
wget -O _fonts/FreeSansOblique.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansOblique.otf
wget -O _fonts/FreeSerif.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerif.otf
wget -O _fonts/FreeSerifBold.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifBold.otf
wget -O _fonts/FreeSerifBoldItalic.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifBoldItalic.otf
wget -O _fonts/FreeSerifItalic.otf https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifItalic.otf

wget -O _fonts/SourceCodePro.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
wget -O _fonts/Terminus.ttf "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete%20Mono.ttf"
wget -O _fonts/UbuntuMono.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
wget -O _fonts/DroidSansMono.otf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf
wget -O _fonts/DejaVuSansMono.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
wget -O _fonts/FiraCode.otf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.otf
wget -O _fonts/FiraMono.otf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.otf
wget -O _fonts/Hack.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf

sudo mkdir /usr/share/fonts/pretty-fonts/
sudo cp _fonts/* /usr/share/fonts/pretty-fonts/
rm -rf _fonts/
fc-cache -fv
