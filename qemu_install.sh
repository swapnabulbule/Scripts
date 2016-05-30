#!/bin/bash
#sudo dpkg -i $HOME/Packages/libperl-dev_5.20.2-3+deb8u1_i386.deb
#sudo dpkg -i $HOME/Packages/libgtk2.0-dev_2.24.25-3_i386.deb
#sudo dpkg -i $HOME/Packages/dh-autoreconf_10_all.deb
#sudo dpkg -i $HOME/Packages/gir1.2-gtk-2.0_2.24.25-3_i386.deb
#sudo dpkg -i $HOME/Packages/libpcrecpp0_8.35-3.3_i386.deb
#sudo dpkg -i $HOME/Packages/libpcre3-dev_8.35-3.3_i386.deb
#sudo dpkg -i $HOME/Packages/libglib2.0-dev_2.42.1-1_i386.deb
#sudo dpkg -i $HOME/Packages/zlib1g-dev_1.2.8.dfsg-2+b1_i386.deb
#sudo dpkg -i $HOME/Packages/pkg-config_0.28-1_i386.deb
#sudo dpkg -i $HOME/Packages/g++_4.9.2-2_i386.deb
cd $HOME
mkdir Qemu
cd Qemu
mkdir source
mkdir install
mkdir build
cd source
cp $HOME/Downloads/qemu-2.4.0.tar.bz2 $HOME/Qemu/.
tar -xjvf $HOME/Qemu/qemu-2.4.0.tar.bz2
cd ..
cd build/
bash $HOME/Qemu/source/qemu-2.4.0/configure --prefix=$HOME/Qemu/install
make
make install
cd $HOME/Qemu/
export "PATH=$PATH:/home/os/Qemu/install/bin/" >>.bashrc
qemu-img create Qemu_img 5G
qemu-system-i386 -hda Qemu_img -boot d -cdrom /home/os/Downloads/debian-8.2.0-i386-netinst.iso
#qemu-system-i386 -m 512 -hda Qemu_img
