library common_constants;

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
const isDeveloperMode =true;
const isPhotomallApp = false;

 // 1=>User Events,2=>Gallery Event,3=>UseSr Requested Event

const int resendOTPDelay = 60;

// change also in intl languages file for  message correction

const int otpLength = 4;

const photoSelectionImageSelectedStatus = 1;

const photoSelectionImageRejectedStatus = 2;

const photoSelectionImageWaitingStatus = 3;

const demoPhotoSelectionAlbumType = 5;

const photoSelectionAlbumType = 1;

const albumImageType = 1;

const eventCoverImageType = 0;

const completedAlbumImageType = 1;

const photoSelectionImageType = 2;

const invitationImageType = 3;

const profileImageType = 4;

const insertStatus = 1;

const updateStatus = 2;

const deleteStatus = 3;

const insufficientStorage =
    "Insufficient storage for download your events data";

const addressMapUrl = "https://www.google.com/maps/search/?api=1&query=";

const demoEvent = 6;

const userEvent = 1;

const studioGalleyEvent = 2;

/// new
const packages = 7;

const studioUtils = 8;

const studioCarousel = 9;

const folderType = 10;

const userAlbum = 11;

const albumCover = 12;

/// new

const photos = 5;
const invitationAlbum = 4;

const itemTransitionDuration = 500;

const itemTransitionDelay = 50;

const pageTransitionDuration = 300;

const pageReversTransitionDuration = 300;

const List<String> loadingQuotes = [
  'Welcome to the safest photo-viewing platform!'
      'Simple Photo Selection Process'
      'Swipe to Select/Reject the photos'
      'View your digital album'
      'Share the album with your friends & family'
      'Enjoy unlimited sharing'
      'Can’t take a screenshot'
      'Can’t take a screen record'
      'Can’t download the album'
      'Share your precious moments with a single click!'
];

showLog(message) {
  if (isDeveloperMode) {
    print(message);
  } else {}
}

const PUBLISHED = 1;
const UNPUBLISHED = 0;
const IMAGE_PUBLIC_ACCESS = 1;
const IMAGE_PRIVATE_ACCESS = 0;

const ASSET_STUDIO_IMAGE = 'assets/images/studio_logo.png';
const ASSET_STUDIO_TRANSPARENT_IMAGE =
    '"assets/images/photomall_logo_transparent.png"';

getPublicType(String type) {
  return 'public' == type ? 1 : 0;
}

isPublished(dynamic publish) {
  return (publish == null || publish == PUBLISHED);
}

class ImageType {
  static const albumImage = 1;

  static const eventCoverImage = 0;

  static const completedAlbumImage = 1;

  static const photoSelectionImage = 2;

  static const invitationImage = 3;

  static const profileImage = 4;

  static const studioCover = 'studio-cover';

  static const studioLogo = 'studio-logo';

  static const studioIcon = 'studio-icon';
  static const waterMarkIcon = 'watermark-icon';
  static const qrCode = 'qr-code';
}

class TransportDataKeys {
  static const studioUserData = 'studio_user_data';
  static const studiosData = 'studios_data'; // photomall app
  static const userEventData = 'user_event_data'; // photomall app
  static const userData = 'user_data';

  static const users = 'users';

  static const studioData = 'studio_data';

  static const photoSelectionData = 'photo_selection_data';

  //static const deviceData = 'device_app_data';
  static const designData = 'design_data';
  static const eventData = 'event_data';
  static const aiData = 'event_ai_data';
  static const videos = 'videos';
  static const albums = 'albums';
  static const orders = 'orders';
  static const folders = 'folders';
  static const photoSelectionImages = 'photo_selection_images';

  static const originalImage = 'original';
  static const albumCover = 'album-cover';
  static const albumMusic = 'album-music';
  static const eventCover = 'event-cover';
  static const events = 'events';
  static const carousel = 'carousel';
  static const mobileCarousel = 'carousel-1024';
  static const webCarousel = 'carousel-1920';
  static const packagesValues = 'packages-values';
  static const packages = 'packages';
  static const DuplicateRemoved = 'duplicate_removed';
}

class TransportPreferenceKeys {}
ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(15)),
);
SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
EdgeInsets padding = const EdgeInsets.all(8);

SnakeShape snakeShape = SnakeShape.circle;
final RegExp emailRegularExpression = RegExp(
    "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");
final RegExp onlyDigits = RegExp(r'^\d+$');
final RegExp mobileRegEx = RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)');

String publicPath =  "https://cdn.photomall.in/photomall/";