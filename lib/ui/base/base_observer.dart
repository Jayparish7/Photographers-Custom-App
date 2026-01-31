import 'package:photomall_flutter/core/services/network_aware/network_broadcast.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';

//class for observing internet availability to call api once connection back
abstract class BaseObserver extends BaseModel {

  NetworkBroadcast networkBroadcast = NetworkBroadcast();
  bool isNetworkFailed = false;
  bool started = false;//to avoid second time start to listen internet

  void startNetworkCheck() {
    if(started == false){
      started = true;
      networkBroadcast.start((hasConnection) async {
        if ((hasConnection == true) && (isNetworkFailed = true)) {
          print("hasConnection :: api $hasConnection");
          networkBroadcast.stop();
          onInternetConnectionBack();
        }
        print("hasConnection :: normal $hasConnection");
      });
    }
  }

  void onInternetConnectionBack();

  void destroy() {
    networkBroadcast.stop();
  }

}