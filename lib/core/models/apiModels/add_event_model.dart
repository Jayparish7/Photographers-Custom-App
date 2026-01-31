//change 09-01-2020

// To parse this JSON data, do
//
//     final addEventModel = addEventModelFromJson(jsonString);

import 'dart:convert';

import 'package:photomall_flutter/core/models/apiModels/user_details_show_model.dart';

AddEvent addEventModelFromJson(str) => AddEvent.fromJson(json.decode(str));

String addEventModelToJson(AddEvent data) => json.encode(data.toJson());

UserAndDemoEvent photomallEventModelFromJson(str) =>
    UserAndDemoEvent.fromJson(json.decode(str));

String photomallEventModelToJson(UserAndDemoEvent data) =>
    json.encode(data.toJson());

/*PhotomallEventData1 photomallEventData1FromJson(str) =>
    PhotomallEventData1.fromJson(json.decode(str));

String photomallEventData1ToJson(PhotomallEventData1 data) =>
    json.encode(data.toJson());*/

class UserAndDemoEvent {
  //demo, user(after login), device event(before login)
  List<PhotomallEvent>? photomallEvents;

  UserAndDemoEvent({
    this.photomallEvents,
  });

  factory UserAndDemoEvent.fromJson(Map<String, dynamic> json) =>
      UserAndDemoEvent(
        photomallEvents: json["photomall_events"] == null
            ? null
            : List<PhotomallEvent>.from(json["photomall_events"]
                .map((f) => PhotomallEvent.fromJson(f))),
      );

  Map<String, dynamic> toJson() => {
        "photomall_events": photomallEvents == null
            ? null
            : List<dynamic>.from(photomallEvents!.map((x) => x.toJson()))
      };
}

class AddEvent {
  //Only for Add event
  PhotomallEvent? photomallEvent;

  AddEvent({
    this.photomallEvent,
  });

  factory AddEvent.fromJson(Map<String, dynamic> json) => AddEvent(
        photomallEvent: json["photomall_event"] == null
            ? null
            : PhotomallEvent.fromJson(json["photomall_event"]),
      );

  Map<String, dynamic> toJson() => {
        "photomall_event":
            photomallEvent == null ? null : photomallEvent!.toJson(),
      };
}

class PhotomallEvent {
  String? code;
  String? name;
  String? eventCategoryName;

  //List<CoverImage> coverImage;
  CoverImage? coverImage;
  int? loginRequired;
  int? visibilityCount;
  Studio? studio;
  //UrlProtection urlProtection;
  String? photomallEventUrl;
  int? lastUpdatedAt;

  int? publish;

  PhotomallEvent({
    this.code,
    this.name,
    this.eventCategoryName,
    this.coverImage,
    this.loginRequired,
    this.visibilityCount,
    this.studio,
    //this.urlProtection,
    this.photomallEventUrl,
    this.lastUpdatedAt,
    this.publish
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
        code: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        eventCategoryName: json["event_category_name"] == null
            ? null
            : json["event_category_name"],
        /* coverImage: json["cover_image"] == null
            ? null
            : List<CoverImage>.from(
                json["cover_image"].map((x) => CoverImage.fromJson(x))),*/
        coverImage: json["cover_image"] == null
            ? null
            : CoverImage.fromJson(json["cover_image"]),
        loginRequired:
            json["login_required"] == null ? null : json["login_required"],
        visibilityCount:
            json["visibility_count"] == null ? null : json["visibility_count"],
        studio: json["studio"] == null ? null : Studio.fromJson(json["studio"]),
        // urlProtection: json["url_protection"] == null
        //     ? null
        //     : UrlProtection.fromJson(json["url_protection"]),
    photomallEventUrl: json["photomall_event_url"] == null ? null : json["photomall_event_url"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
    publish:
    json["publish"] == null ? null : json["publish"],
      );

  Map<String, dynamic> toJson() => {
        "id": code == null ? null : code,
        "name": name == null ? null : name,
        "event_category_name":
            eventCategoryName == null ? null : eventCategoryName,
        /*"cover_image": coverImage == null
            ? null
            : List<dynamic>.from(coverImage.map((x) => x.toJson())),*/
        "cover_image": coverImage == null ? null : coverImage!.toJson(),
        "login_required": loginRequired == null ? null : loginRequired,
        "visibility_count": visibilityCount == null ? null : visibilityCount,
        "studio": studio == null ? null : studio!.toJson(),
        //"url_protection": urlProtection == null ? null : urlProtection.toJson(),
     "photomall_event_url": photomallEventUrl == null ? null : photomallEventUrl,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "publish": publish == null ? null : publish,
      };
}

class CoverImage {
  int? id;
  String? name;

  /*String image;
  int originalSize;
  int thumbSize;
  int selectedStatus;*/
  CoverImageData? data;

  CoverImage({
    this.id,
    this.name,
    this.data,
    /* this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedStatus,*/
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        data:
            json["data"] == null ? null : CoverImageData.fromJson(json["data"]),
        /* image: json["image"] == null ? null : json["image"],
        originalSize:
            json["original_size"] == null ? null : json["original_size"],
        thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
        selectedStatus:
            json["selected_status"] == null ? null : json["selected_status"],*/
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "data": data == null ? null : data!.toJson(),
        /*"image": image == null ? null : image,
        "original_size": originalSize == null ? null : originalSize,
        "thumb_size": thumbSize == null ? null : thumbSize,
        "selected_status": selectedStatus == null ? null : selectedStatus,*/
      };
}

class CoverImageData {
  CoverImageData({
    this.id,
    this.accessType,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.imageOrder,
  });

  int? id;
  String? accessType;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? imageOrder;

  factory CoverImageData.fromJson(Map<String, dynamic> json) => CoverImageData(
        id: json["id"] == null ? null : json["id"],
        accessType: json["access_type"] == null ? null : json["access_type"],
        image: json["image"] == null ? null : json["image"],
        originalSize:
            json["original_size"] == null ? null : json["original_size"],
        thumbSize: json["thumb_size"] == null ? null : json["thumb_size"],
        imageOrder: json["image_order"] == null ? null : json["image_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "access_type": accessType == null ? null : accessType,
        "image": image == null ? null : image,
        "original_size": originalSize == null ? null : originalSize,
        "thumb_size": thumbSize == null ? null : thumbSize,
        "image_order": imageOrder == null ? null : imageOrder,
      };
}

class Studio {
  int? id;
  String? name;
  String? district;
  Logo? logo;
  String? randomUrl;
  String? studioRandomId;

  Studio({
    this.id,
    this.name,
    this.district,
    this.logo,
    this.randomUrl,
    this.studioRandomId,
  });

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        district: json["district"] == null ? null : json["district"],
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
        randomUrl: json["random_url"] == null ? null : json["random_url"],
        studioRandomId:
            json["studio_random_id"] == null ? null : json["studio_random_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "district": district == null ? null : district,
        "logo": logo == null ? null : logo!.toJson(),
        "random_url": randomUrl == null ? null : randomUrl,
        "studio_random_id": studioRandomId == null ? null : studioRandomId,
      };
}

class Logo {
  int? id;
  String? name;
  String? image;

  Logo({
    this.id,
    this.name,
    this.image,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}

class UrlProtection {
  String? photomallEventRandomId;
  int? passcode;
  String? url;

  UrlProtection({
    this.photomallEventRandomId,
    this.passcode,
    this.url,
  });

  factory UrlProtection.fromJson(Map<String, dynamic> json) => UrlProtection(
        photomallEventRandomId: json["photomall_event_random_id"] == null
            ? null
            : json["photomall_event_random_id"],
        passcode: json["passcode"] == null ? null : json["passcode"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "photomall_event_random_id":
            photomallEventRandomId == null ? null : photomallEventRandomId,
        "passcode": passcode == null ? null : passcode,
        "url": url == null ? null : url,
      };
}

//Change 09-01-2020
/*class AddEventModel {
  AddEventModelData data;

  AddEventModel({
    this.data,
  });

  factory AddEventModel.fromJson(Map<String, dynamic> json) => AddEventModel(
    data: AddEventModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class AddEventModelData {
  PhotomallEvent photomallEvent;

  AddEventModelData({
    this.photomallEvent,
  });

  factory AddEventModelData.fromJson(Map<String, dynamic> json) => AddEventModelData(
    photomallEvent: PhotomallEvent.fromJson(json["photomall_event"]),
  );

  Map<String, dynamic> toJson() => {
    "photomall_event": photomallEvent.toJson(),
  };
}

class PhotomallEvent {
  int id;
  int updateStatus;
  PhotomallEventData data;

  PhotomallEvent({
    this.id,
    this.updateStatus,
    this.data,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
    id: json["id"],
    updateStatus: json["update_status"],
    data: PhotomallEventData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "update_status": updateStatus,
    "data": data.toJson(),
  };
}

class PhotomallEventData {
  String name;
  String eventCategoryName;
  List<CoverImage> coverImage;
  int loginRequired;
  int visibilityCount;
  Studio studio;
  UrlProtection urlProtection;
  int lastUpdatedAt;

  PhotomallEventData({
    this.name,
    this.eventCategoryName,
    this.coverImage,
    this.loginRequired,
    this.visibilityCount,
    this.studio,
    this.urlProtection,
    this.lastUpdatedAt,
  });

  factory PhotomallEventData.fromJson(Map<String, dynamic> json) => PhotomallEventData(
    name: json["name"],
    eventCategoryName: json["event_category_name"],
    coverImage: List<CoverImage>.from(json["cover_image"].map((x) => CoverImage.fromJson(x))),
    loginRequired: json["login_required"],
    visibilityCount: json["visibility_count"],
    studio: Studio.fromJson(json["studio"]),
    urlProtection: UrlProtection.fromJson(json["url_protection"]),
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "event_category_name": eventCategoryName,
    "cover_image": List<dynamic>.from(coverImage.map((x) => x.toJson())),
    "login_required": loginRequired,
    "visibility_count": visibilityCount,
    "studio": studio.toJson(),
    "url_protection": urlProtection.toJson(),
    "last_updated_at": lastUpdatedAt,
  };
}

class CoverImage {
  int id;
  String name;
  String image;
  int originalSize;
  int thumbSize;
  int selectedStatus;

  CoverImage({
    this.id,
    this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedStatus,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    originalSize: json["original_size"],
    thumbSize: json["thumb_size"],
    selectedStatus: json["selected_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "original_size": originalSize,
    "thumb_size": thumbSize,
    "selected_status": selectedStatus,
  };
}

class Studio {
  int id;
  String name;
  String district;
  Logo logo;
  String studioRandomId;

  Studio({
    this.id,
    this.name,
    this.district,
    this.logo,
    this.studioRandomId,
  });

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
    id: json["id"],
    name: json["name"],
    district: json["district"],
    logo: Logo.fromJson(json["logo"]),
    studioRandomId: json["studio_random_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "district": district,
    "logo": logo.toJson(),
    "studio_random_id": studioRandomId,
  };
}

class Logo {
  int id;
  String name;
  String image;

  Logo({
    this.id,
    this.name,
    this.image,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class UrlProtection {
  String photomallEventRandomId;
  int passcode;
  String url;

  UrlProtection({
    this.photomallEventRandomId,
    this.passcode,
    this.url,
  });

  factory UrlProtection.fromJson(Map<String, dynamic> json) => UrlProtection(
    photomallEventRandomId: json["photomall_event_random_id"],
    passcode: json["passcode"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "photomall_event_random_id": photomallEventRandomId,
    "passcode": passcode,
    "url": url,
  };
}*/

//Old
/*class AddEventModel {
  Data data;

  AddEventModel({
    this.data,
  });

  factory AddEventModel.fromJson(Map<String, dynamic> json) => AddEventModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  PhotomallEvent photomallEvent;

  Data({
    this.photomallEvent,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    photomallEvent: PhotomallEvent.fromJson(json["photomall_event"]),
  );

  Map<String, dynamic> toJson() => {
    "photomall_event": photomallEvent.toJson(),
  };
}

class PhotomallEvent {
  int id;
  String name;
  List< CoverImage> coverImage;
  String categoryName;
  int loginRequired;
  int visibilityCount;
  int alreadyViewCount;
  Studio studio;
  UrlProtection urlProtection;
  int lastUpdatedAt;
  int eventDownloadAfterOrBeforeLogin;
  int eventNewTagVisible;
  int eventDeleteStatus;
  int photoSelectionStatus;
  PhotomallEvent({
    this.id,
    this.name,
    this.coverImage,
    this.categoryName,
    this.loginRequired,
    this.visibilityCount,
    this.alreadyViewCount,
    this.studio,
    this.urlProtection,
    this.lastUpdatedAt,
    this.eventDownloadAfterOrBeforeLogin,
    this.eventNewTagVisible,
    this.eventDeleteStatus,
    this.photoSelectionStatus
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
    id: json["id"],
    name: json["name"],
    coverImage: List<CoverImage>.from(json["cover_image"].map((x) => CoverImage.fromJson(x))),
    categoryName: json["event_category_name"],
    loginRequired: json["login_required"],
    visibilityCount: json["visibility_count"],
    alreadyViewCount: json["already_view_count"],
    studio: Studio.fromJson(json["studio"]),
    urlProtection: UrlProtection.fromJson(json["url_protection"]),
    eventDownloadAfterOrBeforeLogin: json["download_after_or_before_login"],
    eventNewTagVisible: json["events_visible_status"],
    eventDeleteStatus: json["events_delete_status"],
    photoSelectionStatus: json["photo_selection_status"],
    lastUpdatedAt: json["last_updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cover_image": List<dynamic>.from(coverImage.map((x) => x.toJson())),
    "event_category_name" : categoryName,
    "login_required": loginRequired,
    "visibility_count": visibilityCount,
    "already_view_count" : alreadyViewCount,
    "studio": studio.toJson(),
    "url_protection": urlProtection.toJson(),
    "download_after_or_before_login" : eventDownloadAfterOrBeforeLogin,
    "events_visible_status" : eventNewTagVisible,
    "events_delete_status" : eventDeleteStatus,
    "photo_selection_status" : photoSelectionStatus,
    "last_updated_at": lastUpdatedAt,
  };
}

class CoverImage {
  int id;
  String name;
  String image;
  int originalSize;
  int thumbSize;
  int selectedOrNot;

  CoverImage({
    this.id,
    this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedOrNot,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    originalSize: json["original_size"],
    thumbSize: json["thumb_size"],
    selectedOrNot: json["selected_or_not"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "original_size": originalSize,
    "thumb_size": thumbSize,
    "selected_or_not": selectedOrNot,
  };
}

class Studio {
  int id;
  String name;
  String description;
  Address address;
  CoverImage logo;
  String randomUrl;
  String studioRandomId;

  Studio({
    this.id,
    this.name,
    this.description,
    this.address,
    this.logo,
    this.randomUrl,
    this.studioRandomId,
  });

  factory Studio.fromJson(Map<String, dynamic> json) => Studio(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    address: Address.fromJson(json["address"]),
    logo: CoverImage.fromJson(json["logo"]),
    randomUrl: json["random_url"],
    studioRandomId: json["studio_random_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "address": address.toJson(),
    "logo": logo.toJson(),
    "random_url": randomUrl,
    "studio_random_id": studioRandomId,
  };
}

class Address {
  int id;
  String street;
  String locality;
  String city;
  String district;
  String state;
  String country;
  int pincode;

  Address({
    this.id,
    this.street,
    this.locality,
    this.city,
    this.district,
    this.state,
    this.country,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    street: json["street"],
    locality: json["locality"],
    city: json["city"],
    district: json["district"],
    state: json["state"],
    country: json["country"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "street": street,
    "locality": locality,
    "city": city,
    "district": district,
    "state": state,
    "country": country,
    "pincode": pincode,
  };
}

class UrlProtection {
  String photomallEventRandomId;
  int passcode;
  String url;

  UrlProtection({
    this.photomallEventRandomId,
    this.passcode,
    this.url,
  });

  factory UrlProtection.fromJson(Map<String, dynamic> json) => UrlProtection(
    photomallEventRandomId: json["photomall_event_random_id"],
    passcode: json["passcode"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "photomall_event_random_id": photomallEventRandomId,
    "passcode": passcode,
    "url": url,
  };
}*/
