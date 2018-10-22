sudo apt update && sudo apt upgrade -y

sudo apt install -y gnome-shell-extensions chrome-gnome-shell vanilla-gnome-desktop vim atom git tor autossh keepassxc nmap build-essential cmatrix irssi firejail

sudo wget https://atom.io/download/deb -O /tmp/atom-amd64.deb && sudo apt install /tmp/atom-amd64.deb

apm install autocomplete-python python-tools python-indent

echo "PS1='\[\e[0;37m\]\[\e[0m\]┌─[\[\e[0;96m\]\u\[\e[37m\]@\[\e[0m\]\h] \n└─[\[\e[1;37m\]\w\[\e[0m\]]> '" >> ~/.bashrc

echo "alias pdfjail='function jail() { firejail --seccomp --nonewprivs --private --private-dev --private-tmp --net=none --x11 --whitelist="$1" evince "$1"; }; jail'" >> ~/.bash_aliases

echo ". ~/.bash_aliases" >> ~/.bashrc
