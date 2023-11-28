# This is a boot script for U-Boot
# Generate boot.scr:
# mkimage -c none -A arm -T script -d boot.cmd boot.scr
#
################
kernel_name=zImage

setenv bootargs console=ttyPS0,115200 earlyprintk uio_pdrv_genirq.of_id=generic-uio root=/dev/mmcblk0p2 rootwait

for boot_target in ${boot_targets};
do
	echo "Trying to load boot images from ${boot_target}"
	if test "${boot_target}" = "jtag" ; then
		bootm 0x00200000 0x04000000 0x00100000
	fi
	if test "${boot_target}" = "mmc0" || test "${boot_target}" = "mmc1" || test "${boot_target}" = "usb0" || test "${boot_target}" = "usb1"; then
		if test -e ${devtype} ${devnum}:${distro_bootpart} /uEnv.txt; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x02080000 uEnv.txt;
			echo "Importing environment(uEnv.txt) from ${boot_target}..."
			env import -t 0x02080000 $filesize
			if test -n $uenvcmd; then
				echo "Running uenvcmd ...";
				run uenvcmd;
			fi
		fi
		if test -e ${devtype} ${devnum}:${distro_bootpart} /${fitimage_name}; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x10000000 ${fitimage_name};
			bootm 0x10000000;
                fi
		if test -e ${devtype} ${devnum}:${distro_bootpart} /${kernel_name}; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x00200000 ${kernel_name};
		fi
		if test -e ${devtype} ${devnum}:${distro_bootpart} /system.dtb; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x00100000 system.dtb;
		fi
		if test -e ${devtype} ${devnum}:${distro_bootpart} /${ramdisk_name} && test "${skip_tinyramdisk}" != "yes"; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x04000000 ${ramdisk_name};
			bootm 0x00200000 0x04000000 0x00100000
		fi
		if test -e ${devtype} ${devnum}:${distro_bootpart} /${rootfs_name} && test "${skip_ramdisk}" != "yes"; then
			fatload ${devtype} ${devnum}:${distro_bootpart} 0x04000000 ${rootfs_name};
			bootm 0x00200000 0x04000000 0x00100000
		fi
		bootz 0x00200000 - 0x00100000
	fi
	if test "${boot_target}" = "xspi0" || test "${boot_target}" = "qspi" || test "${boot_target}" = "qspi0"; then
		sf probe 0 0 0;
		sf read 0x10000000 0xA80000 0x1500000
		bootm 0x10000000;
		echo "Booting using Fit image failed"

		sf read 0x00200000 0xA00000 0x600000
		sf read 0x04000000 0x1000000 0xF80000
		bootm 0x00200000 0x04000000 0x00100000;
		echo "Booting using Separate images failed"
	fi
	if test "${boot_target}" = "nand" || test "${boot_target}" = "nand0"; then
		nand info;
		nand read 0x10000000 0x1080000 0x6400000
		bootm 0x10000000;
		echo "Booting using Fit image failed"

		nand read 0x00200000 0x1000000 0x3200000
		nand read 0x04000000 0x4600000 0x3200000
		bootm 0x00200000 0x04000000 0x00100000;
		echo "Booting using Separate images failed"
	fi
done
