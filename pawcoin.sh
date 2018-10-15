#/bin/bash
#/bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=9

COINGITHUB=https://github.com/PawCoin/PawCoinMN.git
COINDAEMON=pawcoind
COINCORE=.PawcoinMN
COINCONFIG=Pawcoin.conf
DIR=PawCoin

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
    if [[ `cat /etc/issue.net`  == *16.04* ]]; then
        echo -e "${GREEN}* You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
    else
        echo -e "${RED}* You are not running Ubuntu 16.04.X. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

updateAndUpgrade() {
    echo
    echo "[2/${MAX}] Runing update and upgrade. Please wait..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}



installDependencies() {
    echo
    echo -e "[5/${MAX}] Installing dependencies. Please wait..."
    sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev libboost-all-dev autoconf automake -qq -y > /dev/null 2>&1
    sudo apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libgmp-dev -qq -y > /dev/null 2>&1
    sudo apt-get install openssl -qq -y > /dev/null 2>&1
    sudo apt-get install software-properties-common -qq -y > /dev/null 2>&1
    sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
    sudo apt-get update -qq -y > /dev/null 2>&1
    sudo apt-get install libdb4.8-dev libdb4.8++-dev -qq -y > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installWallet() {
    echo
    echo -e "[6/${MAX}] Installing wallet. Please wait..."
    sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=1000 2>&1
	sudo mkswap /var/swap.img 2>&1
	sudo swapon /var/swap.img 2>&1
	sudo chmod 0600 /var/swap.img 2>&1
	sudo chown root:root /var/swap.img 2>&1
	mkdir $DIR  2>&1
  cd $DIR 2>&1
	git clone $COINGITHUB 2>&1
	cd ~/PawCoin/PawCoinMN/src/leveldb 2>&1
  chmod +x build_detect_platform 2>&1
  make libleveldb.a libmemenv.a 2>&1
  cd ../..
  cd ./src
	make -f makefile.unix 2>&1
    chmod 755 $COINDAEMON 2>&1
    strip $COINDAEMON 2>&1
    sudo mv $COINDAEMON /usr/bin 2>&1
    cd 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}


echo
echo -e "--------------------------------------------------------------------"
echo -e "|                                                                  |"
echo -e "|         ${BOLD}----- Coin Masternode script -----${NONE}             |"
echo -e "|                                                                  |"
echo -e "--------------------------------------------------------------------"

echo -e "${BOLD}"
read -p "This script will setup your Masternode. Do you wish to continue? (y/n)? " response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    checkForUbuntuVersion
    updateAndUpgrade
    installDependencies
    installWallet
    
else
    echo && echo "Installation cancelled" && echo
fi
