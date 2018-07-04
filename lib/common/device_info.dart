import 'dart:io';

import 'package:meta/meta.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceInfo {
  String model;
  String os;
  String version;
  String device;
  String manufacturer;
  bool isPhysicalDevice;

  DeviceInfo({
    @required this.model,
    @required this.os,
    @required this.version,
    @required this.device,
    @required this.manufacturer,
    @required this.isPhysicalDevice,
  });

  static getDevInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    DeviceInfo deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isFuchsia) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {}

    return deviceData;
  }

  static readAndroidBuildData(AndroidDeviceInfo build) {
    return new DeviceInfo(
        model: build.model,
        os: Platform.isAndroid ? 'android' : 'fuchsia',
        version: build.version.release,
        device: build.device,
        manufacturer: build.manufacturer,
        isPhysicalDevice: build.isPhysicalDevice);
  }

  static readIosDeviceInfo(IosDeviceInfo data) {
    return new DeviceInfo(
      model: data.model,
      os: Platform.isIOS ? 'ios' : 'android',
      version: data.systemVersion,
      device: data.utsname.machine,
      manufacturer: 'Apple',
      isPhysicalDevice: data.isPhysicalDevice,
    );
  }
}
