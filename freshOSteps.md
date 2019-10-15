Basic steps after new OS install
================================

Contents
--------

- [Useful Tools](#useful-tools)
- [Zsh Installation](#zsh-installation)
	- [Oh-My-Zsh-Installation](#oh-my-zsh-installation)
		- [Powerline-Fonts](#powerline-fonts-installation)
- [Vim-Plug Installation](#vim-plug-installation)
- [Vim Plugin Youcompleteme Installation](#vim-plugin-youcompleteme-installation)
- [Neovim Installation](#neovim-installation)
- [NodeJs Installation](#nodejs-installation)
- [Chrome Installation](#chrome-installation)
- [flash plugin for firefox](#flash-plugin-for-firefox)
- [Latex Installation](#latex-installation)
- [Virtualbox Installation](#virtualbox-installation)
- [Vpn Installation](#vpn-installation)
- [Youtube-dl Installation](#youtube-dl-installation)
- [Certificate Settings](#certificate-settings)
- [Git Settings](#git-settings)
- [Proxy Settings](#proxy-settings)
- [Xfce Settings](#xfce-settings)
- [Opera Settings](#opera-settings)

useful tools
------------
```
sudo apt install git
sudo apt install curl
sudo apt install python-pip
sudo apt install python3-pip
sudo apt install unrar
sudo -H pip install --upgrade pip
sudo -H pip install requests
sudo -H pip install beautifulsoup4
sudo apt install pdftk # did not work on 18.04
sudo apt install vim-gtk
sudo apt install ttf-mscorefonts-installer
```

zsh installation
----------------
```
sudo apt install zsh
```
###  oh my zsh installation
```
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```
append "zsh" at the end of .bashrc
change themes from .zshrc file
```
ZSH_THEME="agnoster"
```
### powerline-fonts installation
in order to view beatiful themes run this command, powerline-fonts
```
sudo apt install fonts-powerline
```
manual installation
```
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

vim plug installation
---------------------
with curl
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
manual way
```
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mv plug.vim ~/.vim/autoload/.
```
to source your .vimrc file use ":source" command in vim not in bash
```
:source ~/.vimrc
```

vim plugin youcompleteme installation
-------------------------------------

If vim version is newer than  Vim 7.4.1578 with Python 2 or Python 3 support
Ubuntu 16.04 and later have a Vim that's recent enough.
For vim youcompleteme install development tools and CMake:
```
sudo apt install build-essential cmake

```
Make sure you have Python headers installed
```
sudo apt install python-dev python3-dev
```
Add this line to .vimrc for vim-plug installation
```
Plug 'Valloric/YouCompleteMe'
```
Compiling YCM with semantic support for C-family languages:
```
cd ~/.vim/plugged/YouCompleteMe/
./install.py --clang-completer
```
Compiling YCM without semantic support for C-family languages:
```
cd ~/.vim/plugged/YouCompleteMe/
./install.py
```

neovim installation
-------------------
This is optional
```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```
python prerequisities
```
sudo apt install python-dev python-pip python3-dev python3-pip
```
vim plug installation with neovim
```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

nodeJs installation
-------------------
version 10.x
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```
chrome installation
-------------------
```
sudo dpkg -i google-chrome-stable_current_amd64.deb
```
If there is a problem (optional);
```
sudo add-apt-repository universe
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"
sudo apt update
sudo apt install libgconf2-4 libnss3-1d libxss1
sudo apt install -f
```

flash plugin for firefox
------------------------
Download latest adobe flash plugin [download page](https://get.adobe.com/flashplayer/)
```
tar zxvf flash_player_npapi_linux.x86_64.tar.gz
sudo cp libflashplayer.so /usr/lib/firefox-addons/plugins
```

latex installation
------------------
```
sudo apt install texlive
```
For resolve vimtex warning issue
```
sudo apt install latexmk
```
Run latex to produce documents from .tex docs
```
latex test.tex
```
To view .dvi output, press q to quit
```
xdvi test.dvi &
```
To produce a PDF of this you simply run pdflatex instead of latex
```
pdflatex test.tex
```
To work with .bib files for references
```
pdflatex test.tex
pdflatex test.tex
bibtex reference_file
pdflatex test.tex
```
# Custom class and style files management

Move custom .sty or .cls files to make them available to all .tex files

First determine the Tex home directory whixh is usually `~/texmf/`
```
kpsewhich -var-value=TEXMFHOME
```
Create directory according to TeX directory structure
```
mkdir -p ~/texmf/tex/latex/commonstuff/
```
Move files with these extensions `.cls .def .sty .bst`.
Hereafter latex sees these files whereever it is executed.

[Source of the discussion](https://tex.stackexchange.com/a/1138)

# Track changes with latexdiff
In order to track changes with latexdiff and to include all documents which included in main .tex file (with `--flatten` option).
```
latexdiff --flatten old.tex new.tex > diff.tex
```



virtualbox installation
-----------------------
### with apt
Append the following line at the end of this file if you are using Ubuntu 16.04
```
l=$(wc -l /etc/apt/sources.list | awk '{print $1}')
sudo sed -i "$l a\deb http://download.virtualbox.org/virtualbox/debian xenial contrib" /etc/apt/sources.list
```
Fetch the Oracle GPG public key and import it to your Ubuntu 16.04/Debian 8 system
```
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
```
Update local package index and install Virtualbox
```
sudo apt update
sudo apt install virtualbox-5.2
```
### with dpkg
Download latest virtualbox [download page](https://www.virtualbox.org/wiki/Linux_Downloads)
Install with dpkg
```
dpkg -i virtualbox-5.2_5.2.8-121009_Ubuntu_xenial_amd64.deb
```
vpn installation
----------------
```
sudo apt install libqtcore4
sudo apt install libqtgui4
sudo apt install libgnome-keyring0
sudo apt install gdebi
sudo ./via_vpn_bin_file
```
undo upstarting the vpn service at start
show all services and find your service
```
service --status-all
sudo systemctl disable  via-vpn
```
Verify the installation with dpkg
```
dpkg -l | grep via
```
Uninstall with dpkg
```
sudo dpkg -r via
```
youtube-dl installation
-----------------------
```
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```
extract audio you should install ffmpeg
```
sudo apt install ffmpeg
```
sample command
```
youtube-dl -o '%(title)s.%(ext)s' --restrict-filenames -i -x --audio-format mp3 url
```
certificate settings
--------------------
Sertifika dosyası .pem uzantılı olarak verildiyse .crt uzantılı hale getirilir
```
openssl x509 -in foo.pem -inform PEM -out foo.crt
```
Sertifika dosyası ayrı bir dizine kopyalanır
```
sudo mkdir /usr/share/ca-certificates/new_cert_dir
sudo cp foo.crt /usr/share/ca-certificates/new_cert_dir/foo.crt
```
İşletim sisteminin sertifika dizin ve dosya bilgisini konfigurasyon dosyasına yazması için
```
sudo dpkg-reconfigure ca-certificates
```
Çıkan ekranda yeni yüklenecek sertifika işaretlenir ve kurulum tamamlanır

git settings
------------
Yaptığımız değişikliklerde kullanıcı adımız ve eposta adresimiz bu şekilde gözükür.
```
git config --global user.name "username"
git config --global user.email you@example.com
```
Her seferinde parola girmememek için; cache de 1 saat saklanabilir
```
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
```

proxy settings
--------------

### Sistem için
/etc/environment
```
http_proxy="http://proxy:8080/"
https_proxy="http://proxy:8080/"
ftp_proxy="http://proxy:8080/"
socks_proxy="socks://proxy:8080/"
no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
HTTP_PROXY="http://proxy:8080/"
HTTPS_PROXY="http://proxy:8080/"
FTP_PROXY="http://proxy:8080/"
SOCKS_PROXY="socks://proxy:8080/"
NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"
```
Authenticaiton varsa;
```
"http://user_name:password@proxy:8080/"
```

### Apt için
/etc/apt/apt.conf
```
Acquire::http::proxy "http://proxy:8080/"; 
Acquire::https::proxy "https://proxy:8080/"; 
Acquire::ftp::proxy "ftp://proxy:8080/"; 
Acquire::socks::proxy "socks://proxy:8080/"; 
```

### Wget için
```
use_proxy=yes
http_proxy=http://proxy:8080
https_proxy=http://proxy:8080
```

### Pip için
```
sudo pip install --proxy http://proxy:8080 <module_name>
```

### Easy install için
```
export http_proxy=http://proxy:8080
```
modülü kurmak için
```
sudo -E easy_install <module_name>
```

### Geçici olarak o andaki oturumda geçerli olması için
```
export http_proxy=http://proxy:8080
export https_proxy=https://proxy:8080
```

xfce settings
-------------
### To enable dragging the windows in xfce panel

Rightclick on an empty space of the task bar (or at the corner)

Choose "properties" in the "Window Buttons" context menu

Choose "Sorting order": "None, allow drag-and-drop"


opera settings
--------------
### To view videos like in chrome browser

Download chromium codecs from packages website.
```
wget http://security.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_69.0.3497.81-0ubuntu0.16.04.1_amd64.deb
```

Extract the deb file into a tmp directory
```
mkdir tmp
dpkg-deb -R chromium-codecs-ffmpeg-extra_70.0.3534.4-0ubuntu1_ppa2_16.04.1_amd64.deb tmp
```
Copy `libffmpeg.so` file from chromium to opera directory.

```
sudo cp tmp/usr/lib/chromium-browser/libffmpeg.so /usr/lib/x86_64-linux-gnu/opera/libffmpeg.so
```
