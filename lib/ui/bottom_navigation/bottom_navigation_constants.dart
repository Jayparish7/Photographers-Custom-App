import '../../core/constants/common_constants.dart';

class BottomNavigationConstants {
  //guest
  static const GuestHome = 0;
  static const GuestEvents = 1;
 // static const GuestPhotoSelection = 2;
  static const GuestEventBooking = 2;
  static const GuestLogin = 3;
  static const GuestRegister = 3;

  //customer
  static const CustomerHome = 0;
  static const CustomerEvents = (isPhotomallApp == true) ? 0 :1;
 // static const CustomerPhotoSelection = 2;
  static const CustomerEventBooking = 2;
  static const CustomerAccount = 3;

  //unavailable index
  static const UnAvailable = -1;
}
