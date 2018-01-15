# steps after new OS install
# useful tools
```
sudo apt install git
sudo apt install curl
```

# zsh installation
```
sudo apt install zsh
```
# oh my zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
# append "zsh" at the end of .bashrc
# change themes from .zshrc file
```
ZSH_THEME="agnoster"
```
# in order to view beatiful themes run this command, powerline-fonts
```
sudo apt-get install fonts-powerline
```

# vim plug installation with vim
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
# to source your .vimrc file use ":source" command in vim not in bash
```
:source ~/.vimrc
```

### OPTIONAL ####
# neovim installation
```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```
# python prerequisities
```
sudo apt-get install python-dev python-pip python3-dev python3-pip
```
# vim plug installation with neovim
```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
### OPTIONAL ####

# chrome installation
```
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo add-apt-repository universe
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse"
sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"
sudo apt-get update
sudo apt-get install libgconf2-4 libnss3-1d libxss1
sudo apt install -f
```


# flash plugin for firefox
# download latest adobe flash plugin 
# https://get.adobe.com/flashplayer/
```
tar zxvf flash_player_npapi_linux.x86_64.tar.gz
sudo cp libflashplayer.so /usr/lib/firefox-addons/plugins
```

# vpn installation
```
sudo apt install gdebi gksu
sudo ./via_vpn_bin_file
```
# undo upstarting the vpn service at start
# show all services and find your service 
```
service --status-all
sudo systemctl disable  via-vpn
```


# youtube-dl installation
```
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```
# extract audio you should install libav tools
```
sudo apt-get install -y libav-tools
```
# sample command
# youtube-dl -o '%(title)s.%(ext)s' --restrict-filenames -i -x --audio-format mp3 url


#Proxy ayarlari

#Sistem için
#/etc/environment
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
#Authenticaiton varsa;
```
"http://user_name:password@proxy:8080/"
```

#Apt için
#/etc/apt/apt.conf
```
Acquire::http::proxy "http://proxy:8080/"; 
Acquire::https::proxy "https://proxy:8080/"; 
Acquire::ftp::proxy "ftp://proxy:8080/"; 
Acquire::socks::proxy "socks://proxy:8080/"; 
```

#Wget için
```
use_proxy=yes
http_proxy=http://proxy:8080 
https_proxy=http://proxy:8080 
```

#Pip için
```
sudo pip install --proxy http://proxy:8080 <module_name>
```

#Easy install için
```
export http_proxy=http://proxy:8080
```
#modülü kurmak için
```
sudo -E easy_install <module_name>
```

#Geçici olarak o andaki oturumda geçerli olması için
```
export http_proxy=http://proxy:8080
export https_proxy=https://proxy:8080
```
