#!/bin/bash

cd $HOME/Downloads

export http_proxy="http://2015sdbulbule:22swapna25@196.1.114.238:2222/";
wget http://busybox.net/downloads/busybox-1.23.2.tar.bz2

BusyBox=busybox-1.23.2.tar.bz2

cd $HOME

echo "Extracting $BusyBox"

tar xf $HOME/Downloads/$BusyBox

cd busybox-1.23.2/

make ARCH=i386 defconfig

sed -i.bak '/CONFIG_STATIC/c\CONFIG_STATIC=y' .config
sed -i '43i #include <sys/resource.h>' include/libbb.h

make ARCH=i386 
make ARCH=i386 install

echo "Installed successfully"

cd _install/

find . | cpio -o --format=newc > ../../rfs.img

echo "rfs.img created"

cd $HOME

sudo dd if=/dev/zero of=rfs.img bs=4M count=1

sudo mkfs.ext2 -i 1024 -F rfs.img

sudo mkdir /mnt/rfs
echo " directory /mnt/rfs "
sudo mount -o loop rfs.img /mnt/rfs
sudo rsync -a busybox-1.23.2/_install/* /mnt/rfs/
sudo mkdir /mnt/rfs/dev
sudo mkdir /mnt/rfs/etc
sudo mkdir /mnt/rfs/proc
sudo mkdir /mnt/rfs/sys
sudo mkdir /mnt/rfs/etc/init.d
sudo mknod /mnt/rfs/dev/console c 5 1
sudo mknod /mnt/rfs/dev/null c 1 3 

sudo touch /mnt/rfs/etc/inittab
sudo bash -c 'echo "::sysinit:/etc/init.d/rcS" >> /mnt/rfs/etc/inittab'
sudo bash -c 'echo "::askfirst:-/bin/sh" >> /mnt/rfs/etc/inittab'
sudo bash -c 'echo "::restart:/sbin/init" >> /mnt/rfs/etc/inittab'
sudo bash -c 'echo "::ctrlaltdel:/sbin/reboot" >> /mnt/rfs/etc/inittab'
sudo bash -c 'echo "::shutdown:/bin/umount -a -r" >> /mnt/rfs/etc/inittab'

sudo touch /mnt/rfs/etc/init.d/rcS

echo "file is created"
sudo sed -i '/exec/d' /mnt/rfs/etc/init.d/rcS 
#sudo bash -c 'echo "#!/bin/sh" >> /mnt/rfs/etc/init.d/rcS'
sudo bash -c 'echo "mount -t proc none /proc" >> /mnt/rfs/etc/init.d/rcS'
sudo bash -c 'echo "mount -t sysfs none /sys" >> /mnt/rfs/etc/init.d/rcS'
sudo bash -c 'echo "/bin/sh" >> /mnt/rfs/etc/init.d/rcS' 
 
sudo chown -R root.root /mnt/rfs
sync

cd 
 echo "Rootfs created...!!"

#export "PATH=$PATH:/home/os/Qemu/install/bin/" >>.bashrc
#qemu-system-i386 -m 512 -hda rfs.img -kernel Source_code/linux-3.18.22/arch/i386/boot/bzImage -append "root=/dev/sda clock=pit"

