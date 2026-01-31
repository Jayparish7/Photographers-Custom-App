import '../../core/constants/common_constants.dart';

class SideDrawerConstants {
  //guest
  static const GuestHome = 0;
  static const GuestEvents = (isPhotomallApp == true) ? 0:1;

  //photomall
  static const PhotomallEvents = 0;
  static const PhotomallLogin = 1;
  static const PhotomallSetting = 2;
  static const PhotomallProfile = 1;

  // static const GuestPhotoSelection = 2;
  static const GuestEventBooking = 2;
  static const GuestLogin =  3;
  static const GuestRegister = 3;
  static const GuestSettings = 5;
  static const GuestContactUs = 6;
  static const GuestAddEvents = 7;
  static const GuestPackages = 8;

  //customer
  static const CustomerHome = 0;
  static const CustomerEvents = (isPhotomallApp == true) ? 0 : 1;

  // static const CustomerPhotoSelection = 2;
  static const CustomerEventBooking = 2;
  static const CustomerContactUs = 6;
  static const CustomerAddEvents = 7;
  static const CustomerProfile = 3;
  static const PhotomallCustomerProfile = 1;
  static const CustomerSettings = 5;

  //unavailable index
  static const UnAvailable = -1;
}
