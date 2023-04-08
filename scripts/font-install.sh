#!/usr/bin/env bash
if [ -d "_fonts/" ]; then
	rm -rf _fonts/
fi

mkdir _fonts
curl -Lo _fonts/FreeMono.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMono.otf'
curl -Lo _fonts/FreeMonoBold.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoBold.otf'
curl -Lo _fonts/FreeMonoBoldOblique.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoBoldOblique.otf'
curl -Lo _fonts/FreeMonoOblique.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeMonoOblique.otf'
curl -Lo _fonts/FreeSans.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSans.otf'
curl -Lo _fonts/FreeSansBold.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansBold.otf'
curl -Lo _fonts/FreeSansBoldOblique.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansBoldOblique.otf'
curl -Lo _fonts/FreeSansOblique.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSansOblique.otf'
curl -Lo _fonts/FreeSerif.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerif.otf'
curl -Lo _fonts/FreeSerifBold.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifBold.otf'
curl -Lo _fonts/FreeSerifBoldItalic.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifBoldItalic.otf'
curl -Lo _fonts/FreeSerifItalic.otf 'https://github.com/Maxattax97/gnu-freefont/raw/master/otf/FreeSerifItalic.otf'

curl -Lo _fonts/SourceCodePro.ttf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf'
curl -Lo _fonts/Terminus.ttf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/terminus-ttf-4.40.1/Regular/complete/Terminess%20(TTF)%20Nerd%20Font%20Complete%20Mono.ttf'
curl -Lo _fonts/UbuntuMono.ttf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete%20Mono.ttf'
curl -Lo _fonts/DroidSansMono.otf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf'
curl -Lo _fonts/DejaVuSansMono.ttf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf'
curl -Lo _fonts/FiraCode.otf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete%20Mono.otf'
curl -Lo _fonts/FiraMono.otf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.otf'
curl -Lo _fonts/Hack.ttf 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf'

curl -Lo _fonts/HelveticaNeueu.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeue.ttf'
curl -Lo _fonts/HelveticaNeueBold.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueBold.ttf'
curl -Lo _fonts/HelveticaNeueBoldItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueBoldItalic.ttf'
curl -Lo _fonts/HelveticaNeueCondensedBlack.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueCondensedBlack.ttf'
curl -Lo _fonts/HelveticaNeueCondensedBold.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueCondensedBold.ttf'
curl -Lo _fonts/HelveticaNeueItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueItalic.ttf'
curl -Lo _fonts/HelveticaNeueLight.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueLight.ttf'
curl -Lo _fonts/HelveticaNeueLightItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueLightItalic.ttf'
curl -Lo _fonts/HelveticaNeueMedium.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueMedium.ttf'
curl -Lo _fonts/HelveticaNeueMediumItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueMediumItalic.ttf'
curl -Lo _fonts/HelveticaNeueThin.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueThin.ttf'
curl -Lo _fonts/HelveticaNeueThinItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueThinItalic.ttf'
curl -Lo _fonts/HelveticaNeueUltraLight.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueUltraLight.ttf'
curl -Lo _fonts/HelveticaNeueUltraLightItalic.ttf 'https://github.com/Maxattax97/Helvetica-Neue/raw/gh-pages/HelveticaNeueUltraLightItalic.ttf'

curl -Lo _fonts/RobotoSlab.zip 'https://fonts.google.com/download?family=Roboto%20Slab'
curl -Lo _fonts/Roboto.zip 'https://fonts.google.com/download?family=Roboto'

unzip _fonts/RobotoSlab.zip -d _fonts/
mv _fonts/static/* _fonts/
rm -rf _fonts/RobotoSlab.zip _fonts/LICENSE.txt _fonts/README.txt _fonts/RobotoSlab-VariableFont_wght.ttf _fonts/static/

unzip _fonts/Roboto.zip -d _fonts/
rm -rf _fonts/Roboto.zip _fonts/LICENSE.txt

# This folder should be universal to Linux / FreeBSD.
sudo mkdir -p /usr/local/share/fonts/pretty-fonts/
sudo cp _fonts/* /usr/local/share/fonts/pretty-fonts/

rm -rf _fonts/

# Do this for both root and the current user.
sudo fc-cache -rfv
fc-cache -rfv
