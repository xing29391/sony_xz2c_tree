# Sony Xperia XZ2 Compact (xz2c / apollo / H8324) 设备树 — Android 17

从 PixelOS 17（Android 17 / API 37）实际构建树导出的设备树源码，已针对 xz2c 做 A17 适配。

目录结构与 AOSP 源码树一致，直接放到源码树根目录：

```
device/sony/xz2c
device/sony/tama-common
vendor/sony/xz2c          (仅 Android.bp / Android.mk / BoardConfigVendor.mk / *-vendor.mk)
vendor/sony/tama-common   (同上)
```

闭源 blob（`vendor/sony/*/proprietary`，约 800 MB）**未包含**，请用设备树中的 extract 脚本从官方固件提取，或使用对应的 vendor blob 仓库。

## A17 适配要点

- `BoardConfigCommon.mk` / `BoardConfig.mk`：A17 分区布局、VNDK/FCM、内核命令行
- `manifest.xml` / `framework_compatibility_matrix.xml`：声明的 HAL 与版本矩阵需与 A17 framework 的 FCM 5/6 匹配，否则 vendor 侧 HAL 不会被注册
- `rootdir/etc/fstab.qcom`：A/B、recovery-as-boot、system-as-root 的挂载配置
- `sepolicy/vendor/*`：A17 的 `file.te` / `file_contexts` / `genfs_contexts` / `property_contexts` 与各 HAL 的 `hal_*_default.te`
- **默认手势导航**：`overlay/frameworks/base/core/res/res/values/config.xml` 中 `config_navBarInteractionMode=2`。
  原因：三键导航模式下，设置向导未完成时 Launcher 的 Taskbar 窗口仍为 48dp，而按钮容器被设为 96dp 且底部对齐，导致三个导航键只显示下半部分。向导阶段手势导航不绘制按钮，可规避该问题。
  注意：由于 `PRODUCT_ENFORCE_RRO_TARGETS := *`，该 device overlay 不会合并进 `framework-res.apk`，而是生成 vendor 静态 RRO（`vendor/overlay/framework-res__custom_xz2c__auto_generated_rro_vendor.apk`）。用户显式选择三键导航后，运行时的 navbar RRO 优先级最高，仍会覆盖该默认值。

## 产品配置

- `device/sony/xz2c/custom_xz2c.mk`：PixelOS 17 产品配置（`custom_xz2c-userdebug`）
- `device/sony/xz2c/lineage_xz2c.mk`：LineageOS 侧产品配置（两套构建共用同一份设备树）

## 编译

```bash
source build/envsetup.sh
lunch custom_xz2c-userdebug   # 或 lineage_xz2c-userdebug
m bacon                        # 或 brunch xz2c
```

## 已知问题

- `vendor.qti.hardware.alarm@1.0-service` 每次开机 abort 一次（旧 vendor `libhidlbase` 的 ClientCounterCallback 与 A17 hwservicemanager 不兼容），仅影响关机闹钟。
- 电源键长按/关机闹钟常驻提示可能因上一条出现一次。
