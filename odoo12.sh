#!/bin/bash
# Copyright 2018 odooerpcloud.com 

ODOOVERSION=12.0
DEPTH=5
PATHBASE=~/Developments/odoo12
PATHREPOS=~/Developments/odoo12/extra-addons

#wk32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-i386.tar.xz"
#wk64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz"
wk64="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_amd64.deb"
wk32="https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.$(lsb_release -cs)_i386.deb"

# add universe repository & update (Fix error download libraries)
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install -y git
# Update and install Postgresql
sudo apt-get install postgresql -y
sudo su - postgres -c "createuser -s $USER"

mkdir ~/Developments
mkdir $PATHBASE
mkdir $PATHREPOS
cd $PATHBASE
# Download Odoo from git source
git clone https://github.com/odoo/odoo.git -b $ODOOVERSION --depth $DEPTH

# Install python3 and dependencies for Odoo
sudo apt-get -y install gcc python3-dev libxml2-dev libxslt1-dev \
 libevent-dev libsasl2-dev libldap2-dev libpq-dev \
 libpng-dev libjpeg-dev

sudo apt-get -y install python3 python3-pip python-pip
sudo pip3 install libsass vobject qrcode num2words setuptools

# FIX wkhtml* dependencie Ubuntu Server 18.04
sudo apt-get -y install libxrender1

# Install nodejs and less
sudo apt-get install -y npm node-less
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g less

# Download & install WKHTMLTOPDF
rm $PATHBASE/wkhtmltox_0.12.5-1*.deb
rm wkhtmltox_0.12.5-1*.deb
if [ "`getconf LONG_BIT`" == "32" ];

then
	wget $wk32
	wkhtmltox_0.12.5-1.bionic_amd64.deb
else
	wget $wk64
fi

sudo dpkg -i --force-depends wkhtmltox_0.12.5-1*.deb
sudo ln -s /usr/local/bin/wkhtml* /usr/bin
#tar xvf $PATHBASE/wkhtmltox*.tar.xz
#sudo cp -r $PATHBASE/wkhtmltox/bin/* /usr/local/bin/
#sudo cp -r $PATHBASE/wkhtmltox/bin/* /usr/bin/


# install python requirements file (Odoo)
sudo pip3 install -r $PATHBASE/odoo/requirements.txt
sudo apt-get -f -y install
python3 $PATHBASE/odoo/odoo-bin


echo "Odoo 12 Installation has finished!! ;) by odooerpcloud.com"

