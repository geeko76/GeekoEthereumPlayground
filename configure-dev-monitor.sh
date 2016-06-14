#!/bin/bash

# print commands and arguments as they are executed
set -x

echo "initializing geth installation"
date
ps axjf

#############
# Parameters
#############

AZUREUSER=$1
AZUREPWD=$2
MINERSCOUNT=$3
HOMEDIR="/home/$AZUREUSER"
VMNAME=`hostname`
INDEX=${VMNAME: -1}
echo "User: $AZUREUSER"
echo "User home dir: $HOMEDIR"
echo "vmname: $VMNAME"
echo "index: $INDEX"

#####################
# setup the Azure CLI
#####################
time sudo npm install azure-cli -g
time sudo update-alternatives --install /usr/bin/node nodejs /usr/bin/nodejs 100

####################
# Setup Geth
####################
time sudo apt-get -y git
time sudo apt-get install -y software-properties-common
time sudo add-apt-repository -y ppa:ethereum/ethereum
time sudo add-apt-repository -y ppa:ethereum/ethereum-dev
time sudo apt-get update
time sudo apt-get install -y ethereum

####################
# Install sol compiler
####################
time sudo add-apt-repository ppa:ethereum/ethereum -y
time sudo apt-get update
time sudo apt-get install solc -y

# Fetch Genesis and Start Command
cd $HOMEDIR
wget https://raw.githubusercontent.com/geeko76/CrifEthereumPlayground/master/genesis.json
if test "$INDEX" -lt "$MINERSCOUNT"
then
     wget https://raw.githubusercontent.com/geeko76/CrifEthereumPlayground/master/start-private-blockchain-miner.sh
else
     wget https://raw.githubusercontent.com/geeko76/CrifEthereumPlayground/master/start-private-blockchain-peer.sh
fi

# Init node with custom genesis block
time sudo geth --datadir $HOMEDIR/GethData init genesis.json

# Create the default account
time sudo echo -e "$AZUREPWD\n" > password.txt 
time sudo geth --datadir $HOMEDIR/GethData --password password.txt account new
time sudo rm password.txt

# Install Node.js 6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Git
sudo apt-get install -y git

# Install Truffle
sudo npm install -g truffle

date
echo "completed geth install $$"