import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;

  bool isDisposed = false;

  setBusy(bool value) {
    _busy = value;
    showLog("state: $_busy");
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    showLog('dispose :: base model');
    isDisposed = true;
    super.dispose();
  }
}
