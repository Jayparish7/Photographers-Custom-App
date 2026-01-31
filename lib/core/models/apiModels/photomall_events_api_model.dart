// To parse this JSON data, do
//
//     final photomallEvents = photomallEventsFromJson(jsonString);

import 'dart:convert';

PhotomallEvents photomallEventsFromJson(str) =>
    PhotomallEvents.fromJson(json.decode(str));

String photomallEventsToJson(PhotomallEvents data) =>
    json.encode(data.toJson());

class PhotomallEvents {
  Data? data;

  PhotomallEvents({
    this.data,
  });

  factory PhotomallEvents.fromJson(Map<String, dynamic> json) =>
      PhotomallEvents(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  List<PhotomallEvent>? photomallEvents;

  Data({
    this.photomallEvents,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        photomallEvents: List<PhotomallEvent>.from(
            json["photomall_events"].map((x) => PhotomallEvent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "photomall_events":
            List<dynamic>.from(photomallEvents!.map((x) => x.toJson())),
      };
}

//Change 09-01-2020

class PhotomallEvent {
  int ?id;
  int ?updateStatus;
  PhotomallEventData? data;

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
    "data": data!.toJson(),
  };
}

class PhotomallEventData {
  String? name;
  String? eventCategoryName;
  List<CoverImage> ?coverImage;
  int ?loginRequired;
  int ?visibilityCount;
  Studio ?studio;
  UrlProtection ?urlProtection;
  int? lastUpdatedAt;

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
    "cover_image": List<dynamic>.from(coverImage!.map((x) => x.toJson())),
    "login_required": loginRequired,
    "visibility_count": visibilityCount,
    "studio": studio!.toJson(),
    "url_protection": urlProtection!.toJson(),
    "last_updated_at": lastUpdatedAt,
  };
}

class CoverImage {
  int? id;
  String? name;
  String? image;
  int? originalSize;
  int? thumbSize;
  int? selectedStatus;

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
  int ?id;
  String ?name;
  String? district;
  Logo ?logo;
  String ?studioRandomId;

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
    "logo": logo!.toJson(),
    "studio_random_id": studioRandomId,
  };
}

class Logo {
  int ?id;
  String? name;
  String ?image;

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
  String ?photomallEventRandomId;
  int ?passcode;
  String ?url;

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
}

/*class PhotomallEvent {
  int id;
  String name;
  String categoryName;
  List<CoverImage> coverImage;
  int loginRequired;
  int visibilityCount;
  int alreadyViewCount;
  int eventDownloadAfterOrBeforeLogin;
  int eventNewTagVisible;
  int eventDeleteStatus;
  int photoSelectionStatus;
  Studio studio;
  UrlProtection urlProtection;
  int lastUpdatedAt;

  PhotomallEvent({
    this.id,
    this.name,
    this.categoryName,
    this.coverImage,
    this.loginRequired,
    this.visibilityCount,
    this.alreadyViewCount,
    this.eventDownloadAfterOrBeforeLogin,
    this.eventNewTagVisible,
    this.eventDeleteStatus,
    this.photoSelectionStatus,
    this.studio,
    this.urlProtection,
    this.lastUpdatedAt,
  });

  factory PhotomallEvent.fromJson(Map<String, dynamic> json) => PhotomallEvent(
        id: json["id"],
        name: json["name"],
        categoryName: json["event_category_name"],
        coverImage: List<CoverImage>.from(
            json["cover_image"].map((x) => CoverImage.fromJson(x))),
        loginRequired: json["login_required"],
        visibilityCount: json["visibility_count"],
        alreadyViewCount: json["already_viewed_count"],
        eventDownloadAfterOrBeforeLogin: json["download_after_or_before_login"],
        eventNewTagVisible: json["events_visible_status"],
        eventDeleteStatus: json["events_delete_status"],
        photoSelectionStatus: json["photo_selection_status"],
        studio: Studio.fromJson(json["studio"]),
        urlProtection: UrlProtection.fromJson(json["url_protection"]),
        lastUpdatedAt: json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "event_category_name": categoryName,
        "cover_image": List<dynamic>.from(coverImage.map((x) => x.toJson())),
        "login_required": loginRequired,
        "visibility_count": visibilityCount,
        "already_viewed_count": alreadyViewCount,
        "download_after_or_before_login": eventDownloadAfterOrBeforeLogin,
        "events_visible_status": eventNewTagVisible,
        "events_delete_status": eventDeleteStatus,
        "photo_selection_status": photoSelectionStatus,
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
  int selectedOrNot;
  int imageOrder;

  CoverImage({
    this.id,
    this.name,
    this.image,
    this.originalSize,
    this.thumbSize,
    this.selectedOrNot,
    this.imageOrder,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        originalSize: json["original_size"],
        thumbSize: json["thumb_size"],
        selectedOrNot: json["selected_or_not"],
        imageOrder: json["image_order"] == null ? null : json["image_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "original_size": originalSize,
        "thumb_size": thumbSize,
        "selected_or_not": selectedOrNot,
        "image_order": imageOrder == null ? null : imageOrder,
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
