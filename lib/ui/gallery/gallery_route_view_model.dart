import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/carousel_dao.dart';
import 'package:photomall_flutter/driftdb/dao/carousel_properties_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../core/constants/common_constants.dart';
import '../../core/constants/shared_preference_constants.dart';
import '../../core/services/api_helper.dart';
import '../../driftdb/dao/event_dao.dart';

class GalleryRouteViewModel extends BaseObserver {
  ApiHelper? apiHandler;
  BuildContext? context;
  List<CarouselViewModel> carouselList = [];
  List<CarouselViewModel> mobileCarouselList = [];
  int? interval;
  int carouselHeight = 0;
  int carouselWidth = 0;
  PhotomallApis? apiRepo;
  var documentDirectory;
  String? publicStoragePath;
  List<appDb.Event> galleryEvents = [];
  List<String> categoryNames = [];

  final ValueNotifier<String?> whatsappNumber = ValueNotifier<String?>('');
  String? privateStoragePath;
  ValueNotifier<bool> userLoading = ValueNotifier<bool>(false);
  EventModelDao eventModelDao = EventModelDao();
  var showCarousel = true.obs;

  GalleryRouteViewModel({this.context}) {
    setBusy(false);
    apiRepo = PhotomallApis(this.context);
  }

  getGalleryEventAlbums() async {
    setBusy(true);

    try {
      galleryEvents = await eventModelDao.getAllGalleryEvent();
      await getCategoryName();
      await getStoragePaths();
      await getWhatsappDetail();
      await getCarouselImage();
      await showLog("carousel length where ${carouselList.length}");
      await checkCarousel();
    } catch (e) {
      showLog("gallery view model error $e");
    }
    setBusy(false);
  }

  @override
  void onInternetConnectionBack() async {}

  Future<void> getCategoryName() async {
    for (appDb.Event event in galleryEvents) {
      categoryNames.add(event.categoryName);
    }
  }

  Future<void> getCarouselImage() async {
    CarouselDao carouselDao = CarouselDao();
    CarouselPropertiesDao carouselPropertiesDao = CarouselPropertiesDao();

    appDb.CarouselData? _carousel = await carouselDao.getCarousels();
    showLog('getCarouselsProperties1 $_carousel');

    if (_carousel != null) {
      interval = _carousel.interval;
      carouselHeight = _carousel.height;
      carouselWidth = _carousel.width;
    } else {
      // error exception
      interval = 0;
    }
    List<appDb.CarouselProperty>? files =
        await carouselPropertiesDao.getCarouselsProperties();
    showLog('getCarouselsProperties56 ${files}');

    if (files != null) {
      showLog('getCarouselsProperties78 ${files}');

      for (appDb.CarouselProperty file in files) {
        if (file.image != null) {
          showLog('getCarouselsProperties88 ${file.ableCode}');

          carouselList.add(CarouselViewModel(
              ableCode: file.ableCode,
              ableType: file.ableType,
              network: '${publicStoragePath}/${file.image}'));
        }
      }
    }
  }

  Future<void> getCarouselImages() async {
    CarouselDao carouselDao = CarouselDao();
    CarouselPropertiesDao carouselPropertiesDao = CarouselPropertiesDao();
    appDb.CarouselData? _carousel = await carouselDao.getCarousels();
    showLog('getCarouselsProperties1 $_carousel');

    if (_carousel != null) {
      interval = _carousel.interval;
      carouselHeight = _carousel.height;
      carouselWidth = _carousel.width;
    } else {
      // error exception
      interval = 0;
    }
    List<appDb.CarouselProperty>? files =
        await carouselPropertiesDao.getCarouselsProperties();
    if (files != null) {
      for (appDb.CarouselProperty file in files) {
        if (file.image != null) {
          carouselList.add(CarouselViewModel(
              ableCode: file.ableCode,
              ableType: file.ableType,
              network: '${publicStoragePath}/${file.image}'));
        }
      }
    }
  }

  Future<void> getHeightOfFirstImage(Uint8List file, String url) async {
    ImageProcessor imageProcessor = ImageProcessor();
    Size size = await imageProcessor.getSizeOfImage(file, url);
    carouselHeight = size.height;
    carouselWidth = size.width;
  }

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      showLog('getStoragePaths if');
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    } else {
      showLog('getStoragePaths else');
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    }
  }

  launchWhatsapp(BuildContext context) async {
    final link = WhatsAppUnilink(
      phoneNumber: whatsappNumber.value,
      text: S.of(context).helloIAmCurrentlyUsingYourMobileAppAndWould,
    );
    await launchUrl(Uri.parse(link.toString()));
  }

  getWhatsappDetail() async {
    var appConfig = TransporterPreference();
    appConf.TransportModel? studioDetails = await appConfig.getAppConfig();
    whatsappNumber.value = studioDetails?.studioData?.data?.whatsapp;
    var res = studioDetails?.studioData?.data?.events;
    showLog('getWhatsappDetail $res');
  }

  checkCarousel() async {
    if (carouselList.isNotEmpty) {
      await PreferenceHelper.setBool(carouselKey, true);
    } else {
      await PreferenceHelper.setBool(carouselKey, false);
    }
  }
}

class CarouselViewModel {
  CarouselViewModel({
    this.ableCode,
    this.ableType,
    this.network,
  });

  String? ableCode;
  String? ableType;
  String? network;
}

class Gallery {
  Gallery({
    this.file,
    this.video,
    this.media,
    this.fileConnector,
  });

  final appDb.MediaData? media;
  final appDb.Video? video;
  final appDb.JvtFile? file;
  final appDb.JvtFileConnector? fileConnector;
}

class Media {
  Media({
    this.file,
    this.fileConnector,
    this.media,
    this.event,
    this.videos,
    this.image,
    this.networkImage,
    this.videoUrl,
    this.albums,
  });

  appDb.JvtFile? file;
  appDb.JvtFileConnector? fileConnector;
  appDb.MediaData? media;
  appDb.Event? event;
  appDb.Video? videos;
  appDb.Album? albums;
  List<Image>? image;
  String? networkImage;
  String? videoUrl;
}
