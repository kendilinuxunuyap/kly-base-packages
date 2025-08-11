#!/bin/bash
#set -x
### linux-firmware (optional)
fwversion="20240709"
downloadfw()
{
FIRMWARE="1"
#if [[ "$FIRMWARE" != "" ]] ; then
    fwsrc_uri="https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/refs/"
    fwtarball=https://git.kernel.org/$(wget -O - ${fwsrc_uri} 2>/dev/null | sed "s/.tar.gz'.*/.tar.gz/g;s/.*'//g" | grep "^/pub" | sort -V | tail -n 1)
    fwversion=$(echo $fwtarball | sed "s/.*-//g;s/\..*//g")
    wget $fwtarball -O /tmp/linux-firmware.tar.gz
    cd /tmp
    tar -xvf linux-firmware.tar.gz
    cd linux-firmware-$fwversion
    #chroot $rootfs  /tmp/linux-firmware-$fwversion/copy-firmware.sh ../../lib/firmware
    make install DESTDIR=../../
    #rm -rf $rootfs/lib/firmware/ath*
    #rm -rf $rootfs/lib/firmware/qcom
    #rm -rf $rootfs/lib/firmware/netronome
   #rm -rf $rootfs/lib/firmware/iwl*
    
    #chroot $rootfs depmod -a
    cd ../../..
    #rm -rf /tmp/linux-firmware*
#fi,
}

makepackagefwd()
{
rm -rf /tmp/bps/files/
mkdir -p /tmp/bps/files/

cp -prfv /tmp/linux-firmware-$fwversion/$1 /tmp/bps/files/

fakeroot bps -c fw-"$1"
}

makepackagefwf()
{
rm -rf /tmp/bps/files/
mkdir -p /tmp/bps/files/

cp -prfv /tmp/linux-firmware-$fwversion/$1* /tmp/bps/files/

fakeroot bps -c fw-"$1"
}

makepackagefwg()
{
rm -rf /tmp/bps/files/
mkdir -p /tmp/bps/files/
cp -prfv /tmp/linux-firmware-$fwversion/* /tmp/bps/files/
rm -rf /tmp/bps/files/amd*
rm -rf /tmp/bps/files/intel
rm -rf /tmp/bps/files/mediatek
rm -rf /tmp/bps/files/mellanox
rm -rf /tmp/bps/files/mrvl
rm -rf /tmp/bps/files/netronome
rm -rf /tmp/bps/files/qcom
rm -rf /tmp/bps/files/qed
rm -rf /tmp/bps/files/nvidia
rm -rf /tmp/bps/files/ath*
rm -rf /tmp/bps/files/iwl*

fakeroot bps -c fw-"$1"
}
#downloadfw
makepackagefwf amd
makepackagefwd intel
makepackagefwd mediatek
makepackagefwd mellanox
makepackagefwd mrvl
makepackagefwd netronome
makepackagefwd qcom
makepackagefwd qed
makepackagefwd nvidia
makepackagefwf ath
makepackagefwf iwl
makepackagefwg generic


