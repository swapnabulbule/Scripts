#!/bin/bash

	#sudo apt-get install libncurses5
	#sudo apt-get install libncurses-dev

cd $HOME/Downloads
export https_proxy="https://2015sdbulbule:22swapna25@196.1.114.238:2222/";

wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.18.22.tar.xz

LINUX=linux-3.18.22.tar.xz
 
	#go to source code directory
mkdir $HOME/Source_code

cd $HOME/Source_code/

cp $HOME/Downloads/$LINUX .

tar xf $LINUX

	#go to the extracted source code folder
cd linux-3.18.22/

	#modify in make file line number 301,300 
sed -i.bak '300 s/-O2/-O0/' Makefile

sed -i '301 s/-O2/-O0/' Makefile

LINE=$(sed -n 300p Makefile)

sed -i "300 s/$LINE/$LINE -g3/" Makefile

sed -i '805 s/boot/home\/os\/Source_code/' Makefile

echo "Changes in Makefile file done!!"

	#defconfig creates default config file
make ARCH=i386 defconfig

echo "Changes is config file!!"
NO=$(sed -n '/CONFIG_DEBUG_INFO/'= .config)
sed -i.bak '/CONFIG_DEBUG_INFO/c\CONFIG_DEBUG_INFO=y' .config
sed -i "$((NO+1)) i # CONFIG_DEBUG_INFO_REDUCED is not set " .config
sed -i "$((NO+2)) i CONFIG_DEBUG_INFO_SPLIT=y " .config
sed -i "$((NO+3)) i CONFIG_DEBUG_INFO_DWARF4=y " .config

make ARCH=i386 -j 4
make modules
sudo make modules_install
sudo make install

echo "You are done with compilation and Installation of kernel. Congratulations !"
cd $HOME/bin/

sh busybox_rootfs_script.sh
