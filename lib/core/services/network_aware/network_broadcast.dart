import 'dart:async';



class NetworkBroadcast {
  var listener;

  Future<void> start(Function(bool) callback) async {/*
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          {
            callback(true);
          }
          break;
        case DataConnectionStatus.disconnected:
          callback(false);
          break;
      }
    });
  */}
  void stop() {
    if (listener != null) {
      listener.cancel();
    }
  }
}

