#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_DEFCONFIG_DIR/fwup.conf

echo "Creating BOOT.BIN..."
cd $BINARIES_DIR
cp -f $NERVES_DEFCONFIG_DIR/board/bootgen.bif .
cp -f $NERVES_DEFCONFIG_DIR/board/zynq_fsbl.elf .
cp -f $NERVES_DEFCONFIG_DIR/board/system.bit .
cp -f $NERVES_DEFCONFIG_DIR/board/system.dtb .
$HOST_DIR/bin/bootgen -arch zynq -image bootgen.bif -w -o BOOT.BIN
cd -

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
