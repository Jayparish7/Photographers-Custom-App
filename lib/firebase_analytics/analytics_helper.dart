
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticHelper {
  static final AnalyticHelper singleton = AnalyticHelper._internal();
  AnalyticHelper._internal();

  static AnalyticHelper get shared => singleton;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  static eventLog(String eventName, ) async {
    analytics.logEvent(
      name: eventName,

    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  }

}