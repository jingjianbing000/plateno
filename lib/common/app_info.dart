import 'package:meta/meta.dart';
import 'package:package_info/package_info.dart';

class AppInfo {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  AppInfo(
      {@required this.appName,
      @required this.packageName,
      @required this.version,
      @required this.buildNumber});

  static getAppInfo() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      return new AppInfo(
        appName: info.appName,
        packageName: info.packageName,
        version: info.version,
        buildNumber: info.buildNumber,
      );
    } catch (e) {
      print(e);
    }
  }
}
