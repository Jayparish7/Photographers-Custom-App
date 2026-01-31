import 'package:collection/collection.dart';
import 'package:photomall_flutter/controllers/download_files_controller.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/without_face_album_dao.dart';
import 'package:photomall_flutter/media/order_model.dart' as order;
import 'package:photomall_flutter/traits/utils/cache_manager_utils.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';

class AlbumController {
  Future<List<ImagesViewModel?>?> getAlbumImages(String? data) async {
    List<ImagesViewModel> images = [];
    DownloadPath path;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }
    DownloadFilesController downloadFilesController = DownloadFilesController();
    try {
      if (data != null) {
        List<transporterModel.Order> orders = (order.orderFromJson(data));
        for (transporterModel.Order order in orders) {
          if (order.jvtFileConnectors!.isNotEmpty) {
            images.add(ImagesViewModel(
                extension: order.jvtFileConnectors![0].jvtFile!.extension,
                originalName: order.originalFileName,
                url: downloadFilesController.createUrl(
                    publicPath: path.public!,
                    privatePath: path.private!,
                    file: appDb.JvtFile(
                        code: order.jvtFileConnectors![0].jvtFile!.code!,
                        mode: order.jvtFileConnectors![0].jvtFile!.mode!,
                        priority: 0,
                        downloaded: 0,
                        extension:
                            order.jvtFileConnectors![0].jvtFile!.extension!,
                        size: order.jvtFileConnectors![0].jvtFile!.size!,
                        attempt: 0,
                        name: order.jvtFileConnectors![0].jvtFile!.name!,
                        isNetworkImage: true)),
                orderCode: order.code!));
            showLog("getAlbumImages before sorted: ${order.originalFileName}");
          }

        }
      }
      // ✅ Natural sort before return
      images.sort((a, b) => compareNatural(
        a.originalName ?? '',
        b.originalName ?? '',
      ));
      // ✅ Log sorted names
      // for (final image in images) {
      //   showLog("Sorted originalName: ${image.originalName}");
      // }
      return images;
    } catch (e) {
      print("the  order where $e");
      return null;
    }
  }

  Future<List<ImagesViewModel?>?> getAlbumPersonImages(
      String personCode, String eventCode) async {
    List<ImagesViewModel> images = [];
    DownloadPath path;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }
    PersonAlbumDao faceModelDao = PersonAlbumDao();
    DownloadFilesController downloadFilesController = DownloadFilesController();
    appDb.PersonsAlbum? person =
        await faceModelDao.getFacesByCode(code: personCode);
    AlbumModelDao albumModelDao = AlbumModelDao();
    if (person != null) {
      List<String> personOrders = person.images.split(',');
      showLog('the persons are ${personOrders}');
      List<appDb.Album>? albums =
          await albumModelDao.getAlbumsWhereEventCode(eventCode);

      if (albums != null) {
        showLog('album length: ${albums.length}');

        for (appDb.Album album in albums) {
          showLog('album code: ${album.code}');

          String? data = album.orders;

          if (data != null) {
            List<transporterModel.Order> orders = (order.orderFromJson(data));

            for (transporterModel.Order order in orders) {
              showLog('transporterModel orders ${order.code}');

              if (order.jvtFileConnectors!.isNotEmpty) {
                showLog('jvtFileConnectors orders ${order.originalFileName}');
                if (personOrders.contains(order.code)) {
                  images.add(ImagesViewModel(
                      extension: order.jvtFileConnectors![0].jvtFile!.extension,
                      originalName: order.originalFileName,
                      url: downloadFilesController.createUrl(
                          publicPath: path.public!,
                          privatePath: path.private!,
                          file: appDb.JvtFile(
                              code: order.jvtFileConnectors![0].jvtFile!.code!,
                              mode: order.jvtFileConnectors![0].jvtFile!.mode!,
                              priority: 0,
                              downloaded: 0,
                              extension: order
                                  .jvtFileConnectors![0].jvtFile!.extension!,
                              size: order.jvtFileConnectors![0].jvtFile!.size!,
                              attempt: 0,
                              name: order.jvtFileConnectors![0].jvtFile!.name!,
                              isNetworkImage: true)),
                      orderCode: order.code!));
                  showLog(
                      'transporterModel images ::::${order.code} $images ${orders}');
                }
              }
            }
          }
        }
      }
    }
    showLog("person image where ${images}");
    return images;
  }

  Future<List<ImagesViewModel?>?> getAlbumWithoutPersonImages(
      String eventCode) async {
    List<ImagesViewModel> images = [];
    DownloadPath path;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }

    WithoutPersonAlbumDao withoutFaceModelDao = WithoutPersonAlbumDao();
    DownloadFilesController downloadFilesController = DownloadFilesController();
    appDb.WithOutPersonsAlbum? withoutPerson =
        await withoutFaceModelDao.getWithoutFacesByCode(eventCode: eventCode);
    AlbumModelDao albumModelDao = AlbumModelDao();
    if (withoutPerson != null) {
      List<String> personOrders = withoutPerson.images.split(',');
      showLog('the persons are ${personOrders}');
      List<appDb.Album>? albums =
          await albumModelDao.getAlbumsWhereEventCode(eventCode);
      if (albums != null) {
        for (appDb.Album album in albums) {
          String? data = album.orders;

          if (data != null) {
            List<transporterModel.Order> orders = (order.orderFromJson(data));

            for (transporterModel.Order order in orders) {
              if (order.jvtFileConnectors!.isNotEmpty) {
                if (personOrders.contains(order.code)) {
                  images.add(ImagesViewModel(
                      extension: order.jvtFileConnectors![0].jvtFile!.extension,
                      originalName: order.originalFileName,
                      url: downloadFilesController.createUrl(
                          publicPath: path.public!,
                          privatePath: path.private!,
                          file: appDb.JvtFile(
                              code: order.jvtFileConnectors![0].jvtFile!.code!,
                              mode: order.jvtFileConnectors![0].jvtFile!.mode!,
                              priority: 0,
                              downloaded: 0,
                              extension: order
                                  .jvtFileConnectors![0].jvtFile!.extension!,
                              size: order.jvtFileConnectors![0].jvtFile!.size!,
                              attempt: 0,
                              name: order.jvtFileConnectors![0].jvtFile!.name!,
                              isNetworkImage: true)),
                      orderCode: order.code!));
                }
              }
            }
          }
        }
      }
    }
    showLog("person image where ${images}");
    return images;
  }

  Future<bool> downloadFirstImageOfThisAlbum(String data) async {
    DownloadPath path;
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      path = DownloadPath(
        DocumentPath: appDocumentDirectoryPath,
        public: studioPublicPath,
        private: studioPrivatePath,
      );
    }
    CacheUtil cacheUtil = CacheUtil();
    DownloadFilesController downloadFilesController = DownloadFilesController();
    try {
      List<transporterModel.Order> orders = (order.orderFromJson(data));
      if (orders.isNotEmpty) {
        appDb.JvtFile? file = appDb.JvtFile(
            code: orders[0].jvtFileConnectors![0].jvtFile!.code!,
            extension: orders[0].jvtFileConnectors![0].jvtFile!.extension!,
            name: orders[0].jvtFileConnectors![0].jvtFile!.name!,
            attempt: 0,
            size: orders[0].jvtFileConnectors![0].jvtFile!.size!,
            downloaded: 0,
            priority: 0,
            mode: orders[0].jvtFileConnectors![0].jvtFile!.mode!,
            isNetworkImage: false);
        await cacheUtil.getCacheFile(
          url: downloadFilesController.createUrl(
            publicPath: path.public!,
            privatePath: path.private!,
            file: file,
          ),
          /* name: orders[0].jvtFileConnectors![0].jvtFile!.name!,
            extension: orders[0].jvtFileConnectors![0].jvtFile!.extension!*/
        );
      }

      return true;
      // return  await orderModelDao.getAlbumImages(albumCode);
    } catch (e) {
      print("the  order where $e");
      return false;
    }
  }
}

class ImagesViewModel {
  ImagesViewModel({
    this.orderCode,
    this.url,
    this.extension,
    this.originalName,
  });

  final String? url;
  final String? orderCode;
  final String? extension;
  final String? originalName;
}
