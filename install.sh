#!/bin/bash
if grep -q 'NAME="Debian GNU/Linux"' /etc/os-release; then
    system="debian"
else
    system="ubuntu"
fi

if [ "$system" = "debian" ]; then
    apt-get install -y sudo
fi

sudo apt update
sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg curl wget

if [ "$system" = "debian" ]; then
    repos=$(find /etc/apt/ -name '*.list' -exec cat {} + | grep  ^[[:space:]]*deb | grep -q "packages.sury.org/php" && echo 1 || echo 0)
    if [ "$repos" = "0" ]; then
        echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
        curl -fsSL  https://packages.sury.org/php/apt.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
        sudo apt update
    fi
else
    repos=$(find /etc/apt/ -name '*.list' -exec cat {} + | grep  ^[[:space:]]*deb | grep -q "/ondrej/php" && echo 1 || echo 0)
    if [ "$repos" = "0" ]; then
        sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y
        sudo add-apt-repository ppa:ondrej/php
        sudo apt update
    fi
fi

php_version="$(command php --version 2>'/dev/null' \
| command head -n 1 \
| command cut --characters=5-7)"
if [ "$system" = "ubuntu" ] && [ "$(lsb_release -rs)" = "18.04" ]; then
    sudo apt install php7.2-cli php7.2-curl php7.2-sqlite3 php7.2-pgsql git -y
    cake=$(uname -m)
if [ "$cake" = "x86_64" ]; then
    wget --user-agent "Mozilla" http://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz
    tar -xvzf loaders.linux-x86_64.tar.gz
    rm loaders.linux-x86_64.tar.gz
    else
    wget --user-agent "Mozilla" https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz
    tar -xvzf loaders.linux-aarch64.tar.gz
    rm loaders.linux-aarch64.tar.gz
    fi
    sudo mv ixed.7.2.lin $(php -i | grep extension_dir | awk '{print $3}' | head -n 1)
    
elif [ "$php_version" != "8.1" ]; then
    sudo apt purge php-cli php-curl php-sqlite3 php-pgsql -y
    sudo apt purge php8.2-cli php8.2-curl php8.2-sqlite3 git -y
    sudo apt autoremove -y
    sudo apt install php8.1-cli php8.1-curl php8.1-sqlite3 php8.1-pgsql git -y
    sudo update-alternatives --set php /usr/bin/php8.1

    PREFERENCES_FILE="/etc/apt/preferences.d/php-pin-8.1.pref"
    if [ ! -f "$PREFERENCES_FILE" ]; then
        sudo tee "$PREFERENCES_FILE" <<EOF
Package: php*
Pin: version 8.1*
Pin-Priority: 1001
EOF
        sudo apt update
        sudo apt upgrade -y
    fi
    php_version="$(command php --version 2>'/dev/null' \
| command head -n 1 \
| command cut --characters=5-7)"
cake=$(uname -m)
    if [ "$cake" = "x86_64" ]; then
    wget --user-agent "Mozilla" http://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz
    tar -xvzf loaders.linux-x86_64.tar.gz
    rm loaders.linux-x86_64.tar.gz
    else
    wget --user-agent "Mozilla" https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz
    tar -xvzf loaders.linux-aarch64.tar.gz
    rm loaders.linux-aarch64.tar.gz
    fi
    sudo mv ixed.${php_version}.lin $(php -i | grep extension_dir | awk '{print $3}' | head -n 1)
else

    sudo apt install php8.1-cli php8.1-curl php8.1-sqlite3 php8.1-pgsql git -y
    sudo update-alternatives --set php /usr/bin/php8.1

    PREFERENCES_FILE="/etc/apt/preferences.d/php-pin-8.1.pref"
    if [ ! -f "$PREFERENCES_FILE" ]; then
        sudo tee "$PREFERENCES_FILE" <<EOF
Package: php*
Pin: version 8.1*
Pin-Priority: 1001
EOF
        sudo apt update
        sudo apt upgrade -y
    fi
    php_version="$(command php --version 2>'/dev/null' \
| command head -n 1 \
| command cut --characters=5-7)"
cake=$(uname -m)
if [ "$cake" = "x86_64" ]; then
    wget --user-agent "Mozilla" http://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz
    tar -xvzf loaders.linux-x86_64.tar.gz
    rm loaders.linux-x86_64.tar.gz
    else
    wget --user-agent "Mozilla" https://www.sourceguardian.com/loaders/download/loaders.linux-aarch64.tar.gz
    tar -xvzf loaders.linux-aarch64.tar.gz
    rm loaders.linux-aarch64.tar.gz
    fi
    sudo mv ixed.${php_version}.lin $(php -i | grep extension_dir | awk '{print $3}' | head -n 1)
fi
php_version2="$(command php --version 2>'/dev/null' \
| command head -n 1 \
| command cut --characters=5-7)"
cat > /etc/php/${php_version2}/cli/conf.d/sourceguardian.ini << EOF
zend_extension=ixed.${php_version2}.lin
EOF
rm ixed.*
rm README
rm "SourceGuardian Loader License.pdf"
rm version

if [ ! -e "/bin/php" ]; then
    sudo ln -s "$(command -v php)" /bin/php
fi
cd $HOME
mkdir apiwpp
git clone https://github.com/Penguinehis/CobrancaAtlas.git $HOME/apiwpp
apt install screen -y
chmod +x $HOME/apiwpp/*
cd $HOME
echo ""
echo ""
echo "Para iniciar digite: ./start.sh"