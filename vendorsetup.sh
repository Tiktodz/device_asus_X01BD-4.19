#!/bin/bash

export TZ=Asia/Jakarta

# Removing
rm -rf device/asus/sdm660-common
rm -rf kernel/asus
rm -rf lineage/scripts
rm -rf vendor/asus

## Cloning
git clone --depth=1 https://github.com/Tiktodz/device_asus_sdm660-common-4.19 -b apterlip device/asus/sdm660-common
git clone --depth=1 https://github.com/Tiktodz/android_kernel_asus_sdm660 -b staging --single-branch kernel/asus/sdm660
git clone --depth=1 https://github.com/LineageOS/scripts lineage/scripts
git clone --depth=1 https://github.com/SonicBSV/proprietary_vendor_asus-4.19 --single-branch vendor/asus

## Integrate KernelSU
cd kernel/asus/sdm660
curl -LSs "https://raw.githubusercontent.com/Sorayukii/KernelSU-Next/stable/kernel/setup.sh" | bash -s hookless
cd -

rm -rf hardware/lineage/interfaces
rm -rf hardware/qcom-caf/sdm660/audio
git clone --depth=1 https://github.com/SonicBSV/android_hardware_lineage_interfaces hardware/lineage/interfaces
git clone --depth=1 https://github.com/SonicBSV/android_hardware_qcom-caf_sdm660_audio hardware/qcom-caf/sdm660/audio

#### Signing
rm -rf vendor/afterlife-priv/keys
mkdir -p vendor/afterlife-priv/keys
sed -i 's|PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/testkey|PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/afterlife-priv/keys/releasekey|g' lineage/scripts/lineage-priv-template/keys.mk
cp -R lineage/scripts/lineage-priv-template/* vendor/afterlife-priv/keys/
cd vendor/afterlife-priv/keys
bash keys.sh
cd -
