# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/PixelExtended/manifest -b ace -g default,-mips,-darwin,-notdefault
git clone https://github.com/sanjeevstunner/Manifest.git --depth 1 -b twolip_aosp-11 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch aosp_twolip-userdebug
export TZ=Asia/Kolkata #put before last build command
export PEX_BUILD_TYPE=OFFICIAL
export org.pex.build_maintainer="Chandler Bing"
mka bacon

#OTA Json Generate
python3 OTA/support/ota.py

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
rclone copy OTA/builds/twolip.json cirrus:twolip -P
