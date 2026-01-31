import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/carousel_controller.dart' as cc;
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/controllers/package_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/controllers/upsert_events.dart';
import 'package:photomall_flutter/controllers/upsert_photoSelections.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/carousel_dao.dart';
import 'package:photomall_flutter/driftdb/dao/carousel_properties_dao.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/driftdb/dao/jvt_file_connector_dao.dart';
import 'package:photomall_flutter/driftdb/dao/transporter_dao.dart'
    as transporter;
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/screen_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/app_config_request_model.dart'
    as transporterInputModel;

import '../core/constants/shared_preference_constants.dart';
import '../core/models/apiModels/transport_model/transport_model.dart' as tr;

class StudioDataController {
  cc.CarouselController _carouselController = cc.CarouselController();
  PhotomallApis apiCall = PhotomallApis(null);
  transporter.TransporterDao transporterDao = transporter.TransporterDao();
  JvtFileConnectorModelDao fileConnectorModelDao = JvtFileConnectorModelDao();
  FileModelDao fileModelDao = FileModelDao();
  CarouselPropertiesDao carouselDao = CarouselPropertiesDao();
  var appConfig = TransporterPreference();

  ///Studio Name
  Future<String> getStudioName() async {
    if (appStudioName != null) {
      showLog("appStudioName get in storage utils ");
      return appStudioName!;
    } else {
      showLog("appStudioName get in getStudioName");
      var appConfig = TransporterPreference();
      transporterModel.TransportModel? studioDetails =
          await appConfig.getAppConfig();
      return studioDetails!.studioData!.data!.name!;
    }
  }

  Future<String?> getWebLink() async {
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    return studioDetails!.studioData!.data?.website;
  }

  Future<String?> getWebLinkTwo() async {
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    return studioDetails!.studioData!.data?.shortUrl;
  }

  Future<String?> getPtmlDomin() async {
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    return studioDetails!.studioData!.data?.ptmlDomain;
  }

  Future<String?> getShortUrl() async {
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    return studioDetails!.studioData!.data?.shortUrl;
  }

  Widget getStudioLogo(BuildContext context,
      {required String publicStoragePath, required String documentPath}) {
    ImageProcessor imageProcessor = ImageProcessor();

    return FutureBuilder<appDb.JvtFile?>(
        future: fileModelDao.getStudioLogo(),
        builder: (ctx, snapShot) {
          if (!snapShot.hasData || snapShot.hasError) {
            return SizedBox();
          }
          DownloadFilesController downloadFilesController =
              DownloadFilesController();

          return imageProcessor.getImageView(
            documentPath: documentPath,
            file: snapShot.data!,
            publicStoragePath: publicStoragePath,
            onTap: () {
              showLog("Logo Taped");
            },
            errorWidget: Image.asset(
              "assets/images/splash_logo.png",
            ),
          );
        });
  }

  Widget getStudioBanner(BuildContext context,
      {required String publicStoragePath, String? documentPath}) {
    ImageProcessor imageProcessor = ImageProcessor();
    return FutureBuilder<appDb.JvtFile?>(
        future: fileModelDao.getStudioBanner(),
        builder: (ctx, snapShot) {
          if (!snapShot.hasData || snapShot.hasError) {
            return SizedBox();
          }
          return imageProcessor.getImageView(
              documentPath: documentPath,
              file: snapShot.data!,
              publicStoragePath: publicStoragePath,
              privateStoragePath: null,
              errorWidget: SizedBox(),
              onTap: () {});
        });
  }

  Future<void> getStudioData() async {
    appDb.TransportDataData? transportDataData =
        await transporterDao.getSingleTransporterWhereTagAndUpdateRequired(
            TransportDataKeys.studioData, 1);

    if (transportDataData != null) {
      List<transporterInputModel.InputData> inputData = [];
      inputData.add(transporterInputModel.InputData(
          key: TransportDataKeys.studioData,
          lastUpdatedAt: transportDataData.lastUpdatedAt));

      transporterModel.TransportModel? transporterResponse =
          await apiCall.callAppConfiguration(null, inputData: inputData);

      /// UPDATE STUDIO DATA
      if (transporterResponse != null &&
          transporterResponse.studioData != null &&
          transporterResponse.studioData!.updateRequired == 1 &&
          transporterResponse.studioData!.data != null) {
        await fillStudioResources(transporterResponse);
      } else {
        appDb.TransportDataCompanion _studioEntity =
            appDb.TransportDataCompanion(
          tag: drift.Value(TransportDataKeys.studioData),
          updateRequired: drift.Value(0),
          lastUpdatedAt: drift.Value(
              transporterResponse!.studioData!.data!.lastUpdatedAt!),
          code: drift.Value(transportDataData.code),
        );
        await transporterDao.updateTransporterWhereTag(
            _studioEntity, TransportDataKeys.studioData);
      }
    }
  }

  Future<void> fillStudioResources(
      transporterModel.TransportModel transporterResponse) async {
    ScreenUtil screenUtil = ScreenUtil();
    if (transporterResponse.studioData != null &&
        transporterResponse.studioData!.data != null &&
        transporterResponse.studioData?.data?.events != null &&
        transporterResponse.studioData?.data!.events!.isNotEmpty == true) {
      showLog('transporterResponse transporterResponse res '
          ' ${transporterResponse.studioData?.data!.events?.length} '
          '${transporterResponse.studioData?.data?.events}');
      // await PreferenceHelper.setBool(galleryKey, true);
    } else {
      //await PreferenceHelper.setBool(galleryKey, false);
    }

    /// set response in preference
    await appConfig.setStudioData(transporterResponse);

    /// set storage in static variable
    EssentialUtils storageUtils = EssentialUtils();
    await storageUtils.loadAppEssentialData();

    /// set studio max screen in preference
    await screenUtil.setStudioScreenAtPreference(
        transporterResponse.studioData!.data!.maximumScreenDisplay ?? 2);

    showLog(
        'studioDatatype  ${transporterResponse.studioData?.data?.defaultCountry?.code}');

    /// get screen in top level variable
    await screenUtil.setScreenSize();

    if ((!isPhotomallApp)) {
      if (transporterResponse.studioData?.data!= null) {
        List<String> country = [];
        await PreferenceHelper.setString(studioTypeKey,
            '${transporterResponse.studioData!.data!.type!.name}');
        country.add(
            (transporterResponse.studioData?.data?.defaultCountry?.code) ?? '');
        country.add(
            (transporterResponse.studioData?.data?.defaultCountry?.name) ?? '');
        country.add(
            (transporterResponse.studioData?.data?.defaultCountry?.shortCode) ??
                '');
        country.add((transporterResponse.studioData?.data?.defaultCountry?.id
                .toString()) ??
            '');
        await PreferenceHelper.setStringList(countryKey, country);
        await PreferenceHelper.setString(addPersonKey,
            '${transporterResponse.studioData!.data!.usersAllowedPerAccountInFaceRecognition}');
        await PreferenceHelper.setString(isSharpEdges,
            '${transporterResponse.studioData!.data!.showPhotosAsRoundedEdge}');
        showLog('app tour ${transporterResponse.studioData!.data!.appTour}');
        bool tutorKey = await PreferenceHelper.getBool("$tutorialKey");
        tutorKey == false
            ? await PreferenceHelper.setBool(
                tutorialKey,
                (transporterResponse.studioData!.data!.appTour == 0)
                    ? true
                    : false)
            : null;
        await PreferenceHelper.setString(trueCallerKey,
            '${transporterResponse.studioData!.data!.trueCaller}');
        await PreferenceHelper.setString(ownPlayStoreKey,
            '${transporterResponse.studioData!.data!.ownPlayStore}');
        await PreferenceHelper.setString(googleReviewsKey,
            jsonEncode(transporterResponse.studioData!.data!.googleReviews));

        var map = await getMapFromStudioData(
            transporterResponse.studioData!.data!.relationship);
        await PreferenceHelper.saveMapToPrefs(map, relationShipMap);
      }

      /// insert photo selection data for studio event
      if (transporterResponse.studioData!.data!.photoselections != null) {
        UpsertPhotoSelectionEvent upsertPhotoSelectionEvent =
            UpsertPhotoSelectionEvent();
        await upsertPhotoSelectionEvent.upsertPhotoSelections(
            isUser: false,
            apiEvents: transporterResponse.studioData!.data!.photoselections!);
      }

      /// packages
      if (transporterResponse.studioData!.data!.packages != null) {
        PackageController packageController = PackageController();
        await packageController
            .upsertPackages(transporterResponse.studioData!.data!.packages!);
      }
      if (transporterResponse.studioData!.data!.events != null) {
        UpsertEvent updateEvents = UpsertEvent();
        await updateEvents.upsertEventInDatabase(
          eventType: studioGalleyEvent,
          apiEvents: transporterResponse.studioData!.data!.events,
          transporterTag: TransportDataKeys.studioData,
        );
      }
    }

    if (transporterResponse.studioData!.data!.jvtFileConnectors != null &&
        transporterResponse.studioData!.data!.jvtFileConnectors!.isNotEmpty) {
      await fileConnectorModelDao.insertJvtFilesConnectors(
          eventType: studioUtils,
          ableCode: transporterResponse.studioData!.data!.code,
          ableType: TransportDataKeys.users,
          jvtFileConnectors:
              transporterResponse.studioData!.data!.jvtFileConnectors!);
    }
    if (transporterResponse.studioData!.data!.carousel != null) {
      DateTime apiDate;
      DateTime availableDate;

      apiDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(transporterResponse
                  .studioData!.data!.carousel!.lastUpdatedAt
                  .toString()) *
              1000,
          isUtc: true);

      CarouselDao carouselDao = CarouselDao();
      // get carousel
      appDb.CarouselData? _carousel = await carouselDao.getCarousels();

      if (_carousel != null) {
        availableDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(_carousel.lastUpdatedAt.toString()) * 1000,
            isUtc: true);
        showLog("the time condition ${availableDate.isBefore(apiDate)}");
        if (availableDate.isBefore(apiDate)) {
          await carouselDao
              .insertCarousel(transporterResponse.studioData!.data!.carousel!);

          if (transporterResponse
                  .studioData!.data!.carousel!.carouselProperties!.isNotEmpty &&
              apiDate.isBefore(DateTime.now())) {
            await _carouselController.upsertCarousel(
                carouselProperties: transporterResponse
                    .studioData!.data!.carousel!.carouselProperties!);
          }
        }
      } else {
        await carouselDao
            .insertCarousel(transporterResponse.studioData!.data!.carousel!);
        if (transporterResponse
                .studioData!.data!.carousel!.carouselProperties!.isNotEmpty &&
            apiDate.isBefore(DateTime.now())) {
          await _carouselController.upsertCarousel(
              carouselProperties: transporterResponse
                  .studioData!.data!.carousel!.carouselProperties!);
        }
      }
    }

    appDb.TransportDataCompanion _studioEntity = appDb.TransportDataCompanion(
      tag: drift.Value(TransportDataKeys.studioData),
      updateRequired: drift.Value(0),
      lastUpdatedAt:
          drift.Value(transporterResponse.studioData!.lastUpdatedAt!),
      code: drift.Value(transporterResponse.studioData!.data!.code!),
    );
    await transporterDao.updateTransporterWhereTag(
        _studioEntity, TransportDataKeys.studioData);
    /*  appDb.JvtFile file = await fileModelDao.getStudioLogo();
      CacheUtil cacheUtil = CacheUtil();
    DownloadFilesController downloadFilesController = DownloadFilesController();
    cacheUtil.getCacheFile(
      name:file.name ,
      extension: file.extension,
      url:  downloadFilesController.createUrl(
        temporaryUrl: null,
        file: file,
        publicPath: studioPublicPath
      )
    );*/
  }

  getMapFromStudioData(List<tr.EventCategory>? relationship) async {
    Map<String, dynamic>? map = {};
    if (relationship != null) {
      for (int i = 0; i < relationship!.length; i++) {
        map?[relationship[i].name!] = '${relationship[i].code}';
      }
    }
    return map;
  }
}
