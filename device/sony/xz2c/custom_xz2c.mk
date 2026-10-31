#
# Copyright (C) 2018-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from xz2c device
$(call inherit-product, device/sony/xz2c/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

# Keep adb root on userdebug for on-device bring-up debugging.
# Must be empty: soong's add_json_bool treats any non-empty value as true.
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG :=

PRODUCT_NAME := custom_xz2c
PRODUCT_DEVICE := xz2c
PRODUCT_MANUFACTURER := Sony
PRODUCT_BRAND := Sony
PRODUCT_MODEL := Xperia XZ2 Compact

PRODUCT_GMS_CLIENTID_BASE := android-sony

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="H8324-user 10 52.1.A.3.49 052001A003004902006556692 release-keys" \
    BuildFingerprint=Sony/H8324/H8324:10/52.1.A.3.49/052001A003004902006556692:user/release-keys
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
