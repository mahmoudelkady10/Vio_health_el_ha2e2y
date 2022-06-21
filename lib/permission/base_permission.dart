import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestStorage() async {
    var status = await Permission.manageExternalStorage.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus storageStatus =
          await Permission.manageExternalStorage.request();
      if (storageStatus.isGranted) {
        return true;
      }
    }
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
