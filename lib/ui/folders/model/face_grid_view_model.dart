import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_album_dao.dart';
import 'package:photomall_flutter/driftdb/dao/person_photo_selection_dao.dart';
import 'package:photomall_flutter/media/order_model.dart' as order;
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';

import '../../gallery/gallery_route_view_model.dart';

class FaceGridViewModel extends BaseObserver {
  FaceGridViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  bool isLoading = false;
  ValueNotifier<List<Media>> localMedia = ValueNotifier<List<Media>>([]);
  final ValueNotifier<List<PersonView>> personsListForView =
      ValueNotifier<List<PersonView>>([]);
  List<PersonView> personsList = [];
  String? publicPath;
  List personImages = [];
  ScrollController scrollController = ScrollController();
  List<String> publishedImages = [];
  List<String> allImages = [];

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  initialFaceListMethod(String eventCode, int type) async {
    isLoading = true;
    setBusy(false);
    await getFacesPublished(eventCode);
    await getPersonsList(eventCode, type);
    getPath();
    int comparison = personsList.length >= 20 ? 20 : personsList.length;
    for (int i = 0; i < comparison; i++) {
      personsListForView.value.add(personsList[i]);
    }
    scrollController.addListener(() {
      showLog('scrolling...');
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        showLog("End of list");
        addPerson();
      }
    });
    setBusy(false);
    isLoading = false;
  }

  getPersonsList(String eventCode, int type) async {
    if (type == 1) {
      PersonPhotoSelectionDao faceModelDao = PersonPhotoSelectionDao();
      List<appDb.PersonsPhotoSelection> _personsList =
          await faceModelDao.getFacesByEvent(
        eventCode: eventCode,
      );
      for (appDb.PersonsPhotoSelection person in _personsList) {
        personsList.add(PersonView(person.code, person.image, person.images));
      }
    } else {
      PersonAlbumDao faceModelDao = PersonAlbumDao();
      List<appDb.PersonsAlbum> _personsList =
          await faceModelDao.getFacesByEvent(eventCode: eventCode);
      for (appDb.PersonsAlbum person in _personsList) {
        showLog('person ${person.images.split(',').last} ');
        if (!personsList.contains(PersonView)) {
          if (publishedImages.contains(person.images.split(',').first)) {
            personsList
                .add(PersonView(person.code, person.image, person.images));
            allImages.add(person.images);
            //showLog('allImages order Code pub dev${person.images}');
          }
        }
      }
      // return;
    }
  }

  getFacesPublished(eventCode) async {
    AlbumModelDao albumModelDao = AlbumModelDao();

    List<appDb.Album>? albums =
        await albumModelDao.getAlbumsWhereEventCode(eventCode);
    for (appDb.Album album in albums!) {
      String? data = album.orders;
      showLog('albums ${album.code}');
      if (data != null) {
        List<transporterModel.Order> orders = (order.orderFromJson(data));
        for (transporterModel.Order order in orders) {
          publishedImages.add(order.code!);
          showLog('Code');
        }
      }
    }
    showLog('order Code pub dev${publishedImages}');
  }

  void addPerson() {
    int previousLength = personsListForView.value.length;
    int counter = 0;
    if (personsList.isNotEmpty) {
      for (PersonView? photos in personsList) {
        if (counter == 5) {
          break;
        }
        if (!personsListForView.value.contains(photos)) {
          personsListForView.value.add(photos!);
          counter++;
        }
      }
      if (previousLength < personsListForView.value.length) {
        showLog("more image added..");
        setBusy(false);
      }
    }
  }

  Future<void> getPath() async {
    if (studioPublicPath == null) {
      EssentialUtils essentialUtils = EssentialUtils();
      await essentialUtils.loadAppEssentialData();
    }
    publicPath = studioPublicPath;
  }
}

class PersonView {
  String code;
  String image;
  String images;

  PersonView(this.code, this.image, this.images);
}
