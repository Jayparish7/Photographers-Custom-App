import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:toast/toast.dart';

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();

  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();

  Stream get myStream => _controller.stream;

  void initialise() async {
    var result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(var result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  Future<bool> checkInternetStatus() async {
    InternetConnectionStatus status =
        await InternetConnectionChecker.instance.connectionStatus;
    if (status == InternetConnectionStatus.connected) {
      return true;
    } else {
      return false;
    }
  }

  void disposeStream() => _controller.close();
}

class InternetChecker {
  bool hasInternet = false;

  InternetChecker();

  networkChecker(
      {required Function onTap, required BuildContext context}) async {
    hasInternet = await InternetConnectionChecker.instance.hasConnection;
    if (hasInternet) {
      showLog("Internet permission granted to archived $hasInternet");
      onTap();
    } else {
      showLog("Internet permission denied");
      ToastUtil toast = ToastUtil();
      ToastContext().init(context);
      toast.showShortToast(context, S.of(context).yourOffline);
      return;
    }
  }

  Future<bool> checkConnectivity() async {
    hasInternet = await InternetConnectionChecker.instance.hasConnection;
    if (hasInternet) {
      return true;
    } else {
      return false;
    }
  }
}
