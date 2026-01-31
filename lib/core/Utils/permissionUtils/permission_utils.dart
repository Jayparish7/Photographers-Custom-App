import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fluttertoast/fluttertoast.dart'as toa;

import 'dialog.dart';
class PermissionUtils{
  static Future<bool>getDownloadPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      var release = androidInfo.version.release;

      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      print('Android $release (SDK $sdkInt), $manufacturer $model');
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
      ToastContext().init(context);
      ToastUtil toastUtil = ToastUtil();
      var statusOne = await Permission.storage.status;
      showLog("the status 1 >> $statusOne");
      if (!statusOne.isGranted && (sdkInt < 32)) {
        PermissionStatus _status =
        await Permission.storage.request();
        if (!_status.isGranted) {
          toastUtil.showShortToast(
              context, 'Storage ${S.of(context).permissionDenied}');
          return false;
        }
      }


      if(sdkInt > 32){
        var statusThree =
        await Permission.mediaLibrary.status;
        showLog("the status 3 >> $statusThree");

        if (!statusThree.isGranted) {
          PermissionStatus _status =
          await Permission.mediaLibrary.request();
          showLog("mediaLibrary ${_status}");
          if (!_status.isGranted) {
            toastUtil.showShortToast(
                context, "Media Library ${S.of(context).permissionDenied}");
            return false;
          }
        }
      }

      return true;

    }else{
      await PermissionUtil.requestAll();
      bool statusOne = await PermissionUtil.checkGranted(Permission.storage);
      if(!statusOne){
        await PermissionUtil.requestAll();
      }
      return statusOne;
    }
   }
}



class Utils {
  static void toast(String msg) {
    toa.Fluttertoast.showToast(
      msg: msg,
      toastLength: toa.Toast.LENGTH_SHORT,
      gravity: toa.ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
      backgroundColor: Colors.black,
    );
  }
}

class PermissionUtil {
  /// 安卓权限
  static List<Permission> androidPermissions = <Permission>[
    // 在这里添加需要的权限
    Permission.storage
  ];

  /// ios权限
  static List<Permission> iosPermissions = <Permission>[
    // 在这里添加需要的权限
    Permission.storage
  ];

  static Future<Map<Permission, PermissionStatus>> requestAll() async {
    if (Platform.isIOS) {
      return await iosPermissions.request();
    }
    return await androidPermissions.request();
  }

  static Future<Map<Permission, PermissionStatus>> request(
      Permission permission) async {
    final List<Permission> permissions = <Permission>[permission];
    return await permissions.request();
  }

  static bool isDenied(Map<Permission, PermissionStatus> result) {
    var isDenied = false;
    result.forEach((key, value) {
      if (value == PermissionStatus.denied) {
        isDenied = true;
        return;
      }
    });
    return isDenied;
  }

  static void showDeniedDialog(BuildContext context) {
    HDialog.show(
        context: context,
        title: '权限申请异常',
        content: '请在【应用信息】-【权限管理】中，开启全部所需权限，以正常使用惠爆单功能',
        options: <DialogAction>[
          DialogAction(text: '去设置', onPressed: () => openAppSettings())
        ]);
  }

  /// 检查权限
  static Future<bool> checkGranted(Permission permission) async {
    PermissionStatus storageStatus = await permission.status;
    if (storageStatus == PermissionStatus.granted) {
      //已授权
      return true;
    } else {
      //拒绝授权
      return false;
    }
  }
}
