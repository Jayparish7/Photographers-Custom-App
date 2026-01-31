//import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
part of 'transport_model.dart';

class StudioData {
  StudioData({
    this.updateRequired,
    this.data,
    this.lastUpdatedAt,
  });

  int? updateRequired;
  int? lastUpdatedAt;
  StudiosDatas? data;

  factory StudioData.fromJson(Map<String, dynamic> json) => StudioData(
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        updateRequired:
            json["update_required"] == null ? null : json["update_required"],
        data: json["data"] == null ? null : StudiosDatas.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "update_required": updateRequired == null ? null : updateRequired,
        "data": data == null ? null : data!.toJson(),
      };
}

class StudiosDatas {
  StudiosDatas({
    this.photoselections,
    this.code,
    this.shortUrl,
    this.name,
    this.images,
    this.website,
    this.carousel,
    this.description,
    this.ptmlDomain,
    this.contactPoints,
    this.events,
    this.lastUpdatedAt,
    this.socialProfiles,
    this.publicStoragePath,
    this.privateStoragePath,
    this.eventCategories,
    this.jvtFileConnectors,
    this.maximumScreenDisplay,
    this.packages,
    this.playStoreURL,
    this.whatsapp,
    this.type,
    this.defaultCountry,
    this.usersAllowedPerAccountInFaceRecognition,
    this.showPhotosAsRoundedEdge,
    this.appTour,
    this.trueCaller,
    this.ownPlayStore,
    this.googleReviews,
    this.relationship,
  });

  List<String>? photoselections;
  List<EventCategory>? eventCategories;
  String? code;
  String? shortUrl;
  String? name;
  List<Image>? images;
  String? website;
  String? whatsapp;
  Carousel? carousel;
  String? description;
  String? ptmlDomain;
  List<ContactPoint>? contactPoints;
  List<String>? events;
  int? lastUpdatedAt;
  List<SocialProfile>? socialProfiles;
  String? publicStoragePath;
  String? privateStoragePath;
  List<JvtFileConnectors>? jvtFileConnectors;
  int? maximumScreenDisplay;
  List<Package>? packages;
  String? playStoreURL;
  Type? type;
  DefaultCountry? defaultCountry;
  int? usersAllowedPerAccountInFaceRecognition;
  int? showPhotosAsRoundedEdge;
  int? appTour;
  int? trueCaller;
  int? ownPlayStore;
  List<GoogleReview>? googleReviews;
  List<EventCategory>? relationship;

  factory StudiosDatas.fromJson(Map<String, dynamic> json) => StudiosDatas(
        packages: json["packages"] == null
            ? null
            : List<Package>.from(
                json["packages"].map((x) => Package.fromJson(x))),
        photoselections: json["photoselections"] == null
            ? null
            : List<String>.from(json["photoselections"].map((x) => x)),
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
        shortUrl: json["short_url"] == null ? null : json["short_url"],
        eventCategories: json["event_categories"] == null
            ? null
            : List<EventCategory>.from(
                json["event_categories"].map((x) => EventCategory.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        website: json["website"] == null ? null : json["website"],
        carousel: json["carousel"] == null
            ? null
            : Carousel.fromJson(json["carousel"]),
        description: json["description"] == null ? null : json["description"],
        ptmlDomain: json["ptml_domain"],
        contactPoints: json["contact_points"] == null
            ? null
            : List<ContactPoint>.from(
                json["contact_points"].map((x) => ContactPoint.fromJson(x))),
        events: json["events"] == null
            ? null
            : List<String>.from(json["events"].map((x) => x)),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        socialProfiles: json["social_profiles"] == null
            ? null
            : List<SocialProfile>.from(
                json["social_profiles"].map((x) => SocialProfile.fromJson(x))),
        publicStoragePath: json["public_storage_path"] == null
            ? null
            : json["public_storage_path"],
        privateStoragePath: json["private_storage_path"] == null
            ? null
            : json["private_storage_path"],
        maximumScreenDisplay: json["maximum_screen_display"] == null
            ? null
            : json["maximum_screen_display"],
        playStoreURL:
            json["play_store_url"] == null ? null : json["play_store_url"],
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
        type: json["type"] == null ? null : Type.fromJson(json["type"]),
        defaultCountry: json["country"] == null
            ? null
            : DefaultCountry.fromJson(json["country"]),
        usersAllowedPerAccountInFaceRecognition:
            json.containsKey("face_recognition_users_allowed_per_account")
                ? json["face_recognition_users_allowed_per_account"] == null
                    ? null
                    : json["face_recognition_users_allowed_per_account"]
                : null,
        showPhotosAsRoundedEdge: json.containsKey("show_photos_as_rounded_edge")
            ? json["show_photos_as_rounded_edge"] == null
                ? null
                : json["show_photos_as_rounded_edge"]
            : null,
    appTour: json.containsKey("app_tour")
            ? json["app_tour"] == null
                ? null
                : json["app_tour"]
            : null,
        trueCaller: json.containsKey("true_caller")
            ? json["true_caller"] == null
                ? null
                : json["true_caller"]
            : null,
        ownPlayStore: json.containsKey("own_play_store")
            ? json["own_play_store"] == null
                ? null
                : json["own_play_store"]
            : null,
        relationship: json["relationship"] == null
            ? []
            : List<EventCategory>.from(
                json["relationship"]!.map((x) => EventCategory.fromJson(x))),

        googleReviews: json.containsKey("google_reviews")? json["google_reviews"] == null
            ? []
            : List<GoogleReview>.from(
                json["google_reviews"]!.map((x) => GoogleReview.fromJson(x))):null,
      );

  Map<String, dynamic> toJson() => {
        "packages": packages == null
            ? null
            : List<dynamic>.from(packages!.map((x) => x.toJson())),
        "photoselections": photoselections == null
            ? null
            : List<dynamic>.from(photoselections!.map((x) => x)),
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
        "code": code == null ? null : code,
        "short_url": shortUrl == null ? null : shortUrl,
        "event_categories": eventCategories == null
            ? null
            : List<dynamic>.from(eventCategories!.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "website": website == null ? null : website,
        "carousel": carousel == null ? null : carousel!.toJson(),
        "description": description == null ? null : description,
        "ptml_domain": ptmlDomain,
        "contact_points": contactPoints == null
            ? null
            : List<dynamic>.from(contactPoints!.map((x) => x.toJson())),
        "events":
            events == null ? null : List<dynamic>.from(events!.map((x) => x)),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "social_profiles": socialProfiles == null
            ? null
            : List<dynamic>.from(socialProfiles!.map((x) => x.toJson())),
        "public_storage_path":
            publicStoragePath == null ? null : publicStoragePath,
        "private_storage_path":
            privateStoragePath == null ? null : privateStoragePath,
        "maximum_screen_display":
            maximumScreenDisplay == null ? null : maximumScreenDisplay,
        "play_store_url": playStoreURL == null ? null : playStoreURL,
        "whatsapp": whatsapp == null ? null : whatsapp,
        "type": type == null ? null : type!.toJson(),
        "country": defaultCountry == null ? null : defaultCountry?.toJson(),
        "face_recognition_users_allowed_per_account":
            usersAllowedPerAccountInFaceRecognition,
        "show_photos_as_rounded_edge": showPhotosAsRoundedEdge,
        "app_tour": appTour,
        "true_caller": trueCaller,
        "own_play_store": ownPlayStore,
        "google_reviews": googleReviews == null
            ? []
            : List<dynamic>.from(googleReviews!.map((x) => x.toJson())),
        "relationship": relationship == null
            ? []
            : List<dynamic>.from(relationship!.map((x) => x.toJson())),
      };
}

class ContactPoint {
  ContactPoint({
    this.name,
    this.emails,
    this.phones,
    this.address,
  });

  String? name;
  List<Email>? emails;
  List<Phone>? phones;
  Address? address;

  factory ContactPoint.fromJson(Map<String, dynamic> json) => ContactPoint(
        name: json["name"] == null ? null : json["name"],
        emails: json["emails"] == null
            ? null
            : List<Email>.from(json["emails"].map((x) => Email.fromJson(x))),
        phones: json["phones"] == null
            ? null
            : List<Phone>.from(json["phones"].map((x) => Phone.fromJson(x))),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "emails": emails == null
            ? null
            : List<dynamic>.from(emails!.map((x) => x.toJson())),
        "phones": phones == null
            ? null
            : List<dynamic>.from(phones!.map((x) => x.toJson())),
        "address": address == null ? null : address!.toJson(),
      };
}

class Address {
  Address({
    this.code,
    this.locality,
    this.street,
    this.district,
    this.pincode,
    this.state,
    this.country,
    this.longitude,
    this.latitude,
  });

  String? code;
  String? locality;
  String? street;
  String? district;
  String? pincode;
  String? state;
  String? country;
  dynamic longitude;
  dynamic latitude;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        code: json["code"] == null ? null : json["code"],
        state: json["state"] == null ? null : json["state"],
        street: json["street"] == null ? null : json["street"],
        country: json["country"] == null ? null : json["country"],
        pincode: json["pincode"] == null ? null : json["pincode"],
        district: json["district"] == null ? null : json["district"],
        latitude: json["latitude"],
        locality: json["locality"] == null ? null : json["locality"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "state": state == null ? null : state,
        "street": street == null ? null : street,
        "country": country == null ? null : country,
        "pincode": pincode == null ? null : pincode,
        "district": district == null ? null : district,
        "latitude": latitude,
        "locality": locality == null ? null : locality,
        "longitude": longitude,
      };
}

class Email {
  Email({
    this.id,
    this.address,
  });

  int? id;
  String? address;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        id: json["id"] == null ? null : json["id"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "address": address == null ? null : address,
      };
}

class Phone {
  Phone({
    this.id,
    this.phoneNumber,
  });

  int? id;
  String? phoneNumber;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        id: json["id"] == null ? null : json["id"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "phone_number": phoneNumber == null ? null : phoneNumber,
      };
}

class Image {
  Image({
    this.mode,
    this.name,
    this.size,
  });

  String? mode;
  String? name;
  int? size;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        mode: json["mode"] == null ? null : json["mode"],
        name: json["name"] == null ? null : json["name"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "mode": mode == null ? null : mode,
        "name": name == null ? null : name,
        "size": size == null ? null : size,
      };
}

class SocialProfile {
  SocialProfile({
    this.url,
    this.code,
    this.type,
    this.baseUrl,
  });

  String? url;
  String? code;
  int? type;
  String? baseUrl;

  factory SocialProfile.fromJson(Map<String, dynamic> json) => SocialProfile(
        url: json["url"] == null ? null : json["url"],
        code: json["code"] == null ? null : json["code"],
        type: json["type"] == null ? null : json["type"],
        baseUrl: json["base_url"] == null ? null : json["base_url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "code": code == null ? null : code,
        "type": type == null ? null : type,
        "base_url": baseUrl == null ? null : baseUrl,
      };
}

class EventCategory {
  EventCategory({
    this.code,
    this.name,
  });

  String? code;
  String? name;

  factory EventCategory.fromJson(Map<String, dynamic> json) => EventCategory(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name == null ? null : name,
      };
}

class Carousel {
  Carousel({
    this.code,
    this.interval,
    this.carouselProperties,
    this.lastUpdatedAt,
    this.resolutions,
  });

  String? code;
  int? interval;
  int? lastUpdatedAt;
  List<CarouselProperty>? carouselProperties;
  List<Resolution>? resolutions;

  factory Carousel.fromJson(Map<String, dynamic> json) => Carousel(
        code: json["code"] == null ? null : json["code"],
        interval: json["interval"] == null ? null : json["interval"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        carouselProperties: json["carousel_properties"] == null
            ? null
            : List<CarouselProperty>.from(json["carousel_properties"]
                .map((x) => CarouselProperty.fromJson(x))),
        resolutions: json["resolutions"] == null
            ? []
            : List<Resolution>.from(
                json["resolutions"].map((x) => Resolution.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "interval": interval == null ? null : interval,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "carousel_properties": carouselProperties == null
            ? null
            : List<dynamic>.from(carouselProperties!.map((x) => x.toJson())),
        "resolutions": resolutions == null
            ? []
            : List<dynamic>.from(resolutions!.map((x) => x.toJson())),
      };
}

class CarouselProperty {
  CarouselProperty({
    this.code,
    this.priority,
    this.ableCode,
    this.ableType,
    this.jvtFileConnectors,
  });

  String? code;
  int? priority;
  dynamic ableCode;
  dynamic ableType;
  List<dynamic>? jvtFileConnectors;

  factory CarouselProperty.fromJson(Map<String, dynamic> json) =>
      CarouselProperty(
        code: json["code"] == null ? null : json["code"],
        priority: json["priority"] == null ? null : json["priority"],
        ableCode: json["able_code"],
        ableType: json["able_type"],
        /* jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),*/
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : json["jvt_file_connectors"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "priority": priority == null ? null : priority,
        "able_code": ableCode,
        "able_type": ableType,
        "jvt_file_connectors":
            jvtFileConnectors == null ? null : jvtFileConnectors,
        /*"jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors.map((x) => x.toJson())),*/
      };
}

class GoogleReview {
  String? code;
  String? phone;
  int? rating;
  List<Review>? reviews;

  GoogleReview({
    this.code,
    this.phone,
    this.rating,
    this.reviews,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) => GoogleReview(
        code: json["code"],
        phone: json["phone"],
        rating: json["rating"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "phone": phone,
        "rating": rating,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}


class Review {
  String? code;
  String? authorName;
  String? authorUrl;
  String? profilePhotoUrl;
  int? rating;
  DateTime? time;
  String? review;

  Review({
    this.code,
    this.authorName,
    this.authorUrl,
    this.profilePhotoUrl,
    this.rating,
    this.time,
    this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    code: json["code"],
    authorName: json["author_name"],
    authorUrl: json["author_url"],
    profilePhotoUrl: json["profile_photo_url"],
    rating: json["rating"],
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "author_name": authorName,
    "author_url": authorUrl,
    "profile_photo_url": profilePhotoUrl,
    "rating": rating,
    "time": time?.toIso8601String(),
    "review": review,
  };
}


class Package {
  Package({
    this.code,
    this.name,
    this.description,
    this.price,
    this.discount,
    this.packageValues,
    this.jvtFileConnectors,
    this.published,
  });

  String? code;
  String? name;
  String? description;
  int? price;
  Discount? discount;
  List<PackageValue>? packageValues;
  List<JvtFileConnectors>? jvtFileConnectors;
  int? published;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        price: json["price"] == null ? null : json["price"],
        published: json["published"] == null ? null : json["published"],
        discount: json["discount"] == null
            ? null
            : Discount.fromJson(json["discount"]),
        packageValues: json["package_values"] == null
            ? null
            : List<PackageValue>.from(
                json["package_values"].map((x) => PackageValue.fromJson(x))),
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "price": price == null ? null : price,
        "discount": discount == null ? null : discount!.toJson(),
        "published": published == null ? null : published,
        "package_values": packageValues == null
            ? null
            : List<dynamic>.from(packageValues!.map((x) => x.toJson())),
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}

class Type {
  String? name;
  int? status;
  String? code;

  Type({
    this.name,
    this.status,
    this.code,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "status": status == null ? null : status,
        "code": code == null ? null : code,
      };
}

class Discount {
  Discount({
    this.value,
    this.termsOf,
  });

  int? value;
  int? termsOf;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        value: json["value"] == null ? null : json["value"],
        termsOf: json["terms_of"] == null ? null : json["terms_of"],
      );

  Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "terms_of": termsOf == null ? null : termsOf,
      };
}

class PackageValue {
  PackageValue({
    this.key,
    this.code,
    this.value,
    this.jvtFileConnectors,
  });

  String? key;
  String? code;
  String? value;
  List<JvtFileConnectors>? jvtFileConnectors;

  factory PackageValue.fromJson(Map<String, dynamic> json) => PackageValue(
        key: json["key"] == null ? null : json["key"],
        code: json["code"] == null ? null : json["code"],
        value: json["value"] == null ? null : json["value"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "key": key == null ? null : key,
        "code": code == null ? null : code,
        "value": value == null ? null : value,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}

class Resolution {
  Resolution({
    this.screenDisplay,
    this.height,
    this.width,
  });

  int? screenDisplay;
  int? height;
  int? width;

  factory Resolution.fromJson(Map<String, dynamic> json) => Resolution(
        screenDisplay: json["screen_display"],
        height: json["height"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "screen_display": screenDisplay,
        "height": height,
        "width": width,
      };
}

class DefaultCountry {
  int? id;
  String? name;
  String? code;
  String? shortCode;

  DefaultCountry({
    this.id,
    this.name,
    this.code,
    this.shortCode,
  });

  factory DefaultCountry.fromJson(Map<String, dynamic> json) => DefaultCountry(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        shortCode: json["short_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "short_code": shortCode,
      };
}
