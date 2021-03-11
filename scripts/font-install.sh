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

wget -O _fonts/HelveticaNeueu.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeue.ttf
wget -O _fonts/HelveticaNeueBold.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueBold.ttf
wget -O _fonts/HelveticaNeueBoldItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueBoldItalic.ttf
wget -O _fonts/HelveticaNeueCondensedBlack.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueCondensedBlack.ttf
wget -O _fonts/HelveticaNeueCondensedBold.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueCondensedBold.ttf
wget -O _fonts/HelveticaNeueItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueItalic.ttf
wget -O _fonts/HelveticaNeueLight.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueLight.ttf
wget -O _fonts/HelveticaNeueLightItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueLightItalic.ttf
wget -O _fonts/HelveticaNeueMedium.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueMedium.ttf
wget -O _fonts/HelveticaNeueMediumItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueMediumItalic.ttf
wget -O _fonts/HelveticaNeueThin.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueThin.ttf
wget -O _fonts/HelveticaNeueThinItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueThinItalic.ttf
wget -O _fonts/HelveticaNeueUltraLight.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueUltraLight.ttf
wget -O _fonts/HelveticaNeueUltraLightItalic.ttf https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueUltraLightItalic.ttf

wget -O _fonts/RobotoSlab.zip https://fonts.google.com/download?family=Roboto%20Slab
wget -O _fonts/Roboto.zip https://fonts.google.com/download?family=Roboto

unzip _fonts/RobotoSlab.zip -d _fonts/
mv _fonts/static/* _fonts/
rm -rf _fonts/RobotoSlab.zip _fonts/LICENSE.txt _fonts/README.txt _fonts/RobotoSlab-VariableFont_wght.ttf _fonts/static/

unzip _fonts/Roboto.zip -d _fonts/
rm -rf _fonts/Roboto.zip _fonts/LICENSE.txt

sudo mkdir /usr/share/fonts/pretty-fonts/
sudo cp _fonts/* /usr/share/fonts/pretty-fonts/
rm -rf _fonts/
fc-cache -fv
