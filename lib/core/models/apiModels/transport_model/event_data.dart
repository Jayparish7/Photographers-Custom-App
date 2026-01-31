part of 'transport_model.dart';

class EventData {
  EventData({
    this.code,
    this.updateRequired,
    this.lastUpdatedAt,
    this.eventDetailedData,
  });

  int? lastUpdatedAt;
  String? code;
  Map<String, dynamic>? eventDetailedData;

  // EventDetailedData data;
  int? updateRequired;

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        updateRequired:
            json["update_required"] == null ? null : json["update_required"],
        code: json["code"] == null ? null : json["code"],
        eventDetailedData: json["data"] == null ? null : json["data"],
        /* data: json["data"] == null
            ? null
            : EventDetailedData.fromJson(json["data"]),*/
      );

  Map<String, dynamic> toJson() => {
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "update_required": updateRequired == null ? null : updateRequired,
        "code": code == null ? null : code,
        "data": eventDetailedData == null ? null : eventDetailedData,
        //  "data": data == null ? null : data.toJson(),
      };
}

class EventDetailedData {
  EventDetailedData(
      {this.priorityScore,
      this.code,
      this.name,
      this.type,
      this.medias,
      this.published,
      this.duration,
      this.categoryName,
      this.loginRequired,
      this.lastUpdatedAt,
      this.jvtFileConnectors,
      this.subevents,
      this.address,
      this.downloadable,
      this.downloadWithIcon,
      this.downloadWithWatermark,
      this.personStatus,
      this.persons,
      this.realPersons,
      this.imageWithoutPerson,
      this.albumDownloadable,
      this.studioCode,
      this.myPhotosDownloadable,
      this.hideMedia,
      this.printStatus,
      this.waterMarkPosition,
      this.waterMarkOpacity,
      this.waterMarkSize,
      this.clientEvents,
      this.aiEmbeddingMethod,
      this.corporateEvent,
      this.eventPrivateKey,
      this.photoselection});

  int? priorityScore;
  Address? address;
  String? code;
  String? name;
  int? type;
  List<Media>? medias;
  int? published;
  EventDuration? duration;
  String? categoryName;
  int? loginRequired;
  int? lastUpdatedAt;
  List<Subevent>? subevents;
  List<JvtFileConnectors>? jvtFileConnectors;
  int? downloadWithIcon;
  int? downloadWithWatermark;
  int? downloadable;
  bool? personStatus;
  List<Person>? persons;
  List<RealPerson>? realPersons;
  List<String>? imageWithoutPerson;
  int? albumDownloadable;
  String? studioCode;
  int? myPhotosDownloadable;
  int? hideMedia;
  int? printStatus;
  String? waterMarkPosition;
  int? waterMarkOpacity;
  int? waterMarkSize;
  List<ClientEvent>? clientEvents;
  int? aiEmbeddingMethod;
  int? corporateEvent;
  String? eventPrivateKey;
  Photoselection? photoselection;

  factory EventDetailedData.fromJson(Map<String, dynamic> json) =>
      EventDetailedData(
        studioCode: json["studio_code"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        subevents: json["subevents"] == null
            ? null
            : List<Subevent>.from(
                json["subevents"].map((x) => Subevent.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        clientEvents: json.containsKey("client_events")
            ? json["client_events"] == null
                ? []
                : List<ClientEvent>.from(
                    json["client_events"]!.map((x) => ClientEvent.fromJson(x)))
            : null,
        type: json["type"] == null ? null : json["type"],
        medias: json["medias"] == null
            ? null
            : List<Media>.from(json["medias"].map((x) => Media.fromJson(x))),
        published: json["published"] == null ? null : json["published"],
        duration: json["duration"] == null
            ? null
            : EventDuration.fromJson(json["duration"]),
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        loginRequired:
            json["login_required"] == null ? null : json["login_required"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
        downloadWithWatermark: json["download_with_watermark"] == null
            ? null
            : json["download_with_watermark"],
        downloadWithIcon: json["download_with_icon"] == null
            ? null
            : json["download_with_icon"],
        downloadable:
            json["downloadable"] == null ? null : json["downloadable"],
        priorityScore:
            json["priority_score"] == null ? null : json["priority_score"],
        personStatus: json["person_status"],
        persons: json["persons"] == null
            ? []
            : List<Person>.from(
                json["persons"]!.map((x) => Person.fromJson(x))),
        realPersons: json["real_persons"] == null
            ? []
            : List<RealPerson>.from(
                json["real_persons"]!.map((x) => RealPerson.fromJson(x))),
        imageWithoutPerson: json["image_without_person"] == null
            ? []
            : List<String>.from(json["image_without_person"].map((x) => x)),
        albumDownloadable: json["album_downloadable"] == null
            ? null
            : json["album_downloadable"],
        myPhotosDownloadable: json["my_photos_downloadable"] == null
            ? null
            : json["my_photos_downloadable"],
        hideMedia:
            json["media_photo_hide"] == null ? null : json["media_photo_hide"],
        printStatus: json.containsKey("photos_print_status")
            ? json["photos_print_status"] == null
                ? null
                : json["photos_print_status"]
            : null,
        waterMarkPosition: json.containsKey("watermark_position")
            ? json["watermark_position"] == null
                ? null
                : json["watermark_position"]
            : null,
        waterMarkSize: json.containsKey("watermark_size")
            ? json["watermark_size"] == null
                ? null
                : json["watermark_size"]
            : null,
        waterMarkOpacity: json.containsKey("watermark_opacity")
            ? json["watermark_opacity"] == null
                ? null
                : json["watermark_opacity"]
            : null,
        aiEmbeddingMethod: json.containsKey("ai_embedding_method")
            ? json["ai_embedding_method"] == null
                ? null
                : json["ai_embedding_method"]
            : null,
        corporateEvent: json.containsKey("corporate_event")
            ? json["corporate_event"] == null
                ? null
                : json["corporate_event"]
            : null,
        eventPrivateKey: json.containsKey("private_key")
            ? json["private_key"] == null
                ? null
                : json["private_key"]
            : null,
        photoselection: json["photoselection"] == null
            ? null
            : Photoselection.fromJson(json["photoselection"]),
      );

  Map<String, dynamic> toJson() => {
        "studio_code": studioCode,
        "address": address!.toJson(),
        "subevents": List<dynamic>.from(subevents!.map((x) => x.toJson())),
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "client_events": clientEvents == null
            ? []
            : List<dynamic>.from(clientEvents!.map((x) => x.toJson())),
        "type": type == null ? null : type,
        "medias": List<dynamic>.from(medias!.map((x) => x.toJson())),
        "published": published == null ? null : published,
        "duration": duration!.toJson(),
        "category_name": categoryName == null ? null : categoryName,
        "login_required": loginRequired == null ? null : loginRequired,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
        "downloadable": downloadable == null ? null : downloadable,
        "download_with_icon":
            downloadWithIcon == null ? null : downloadWithIcon,
        "download_with_watermark":
            downloadWithWatermark == null ? null : downloadWithWatermark,
        "priority_score": priorityScore == null ? null : priorityScore,
        "person_status": personStatus,
        "persons": persons == null
            ? []
            : List<dynamic>.from(persons!.map((x) => x.toJson())),
        "real_persons": realPersons == null
            ? []
            : List<dynamic>.from(realPersons!.map((x) => x.toJson())),
        "image_without_person": imageWithoutPerson == null
            ? []
            : List<dynamic>.from(imageWithoutPerson!.map((x) => x)),
        "album_downloadable":
            albumDownloadable == null ? null : albumDownloadable,
        "my_photos_downloadable":
            myPhotosDownloadable == null ? null : myPhotosDownloadable,
        "media_photo_hide": hideMedia == null ? null : hideMedia,
        "photos_print_status": printStatus == null ? null : printStatus,
        "watermark_position":
            waterMarkPosition == null ? null : waterMarkPosition,
        "watermark_opacity": waterMarkOpacity == null ? null : waterMarkOpacity,
        "watermark_size": waterMarkSize == null ? null : waterMarkSize,
        "ai_embedding_method":
            aiEmbeddingMethod == null ? null : aiEmbeddingMethod,
        "corporate_event": corporateEvent == null ? null : corporateEvent,
        "private_key": eventPrivateKey == null ? null : eventPrivateKey,
        "photoselection":
            photoselection == null ? null : photoselection!.toJson(),
      };
}

class ClientEvent {
  String? userRandomID;

  ClientEvent({
    this.userRandomID,
  });

  factory ClientEvent.fromJson(Map<String, dynamic> json) => ClientEvent(
        userRandomID: json["user_random_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_random_id": userRandomID,
      };
}

class Media {
  Media({
    this.code,
    this.mediable,
    this.mediableType,
    this.priorityScore,
    this.published,
    this.lastUpdatedAt,
  });

  String? code;
  Mediable? mediable;
  String? mediableType;
  int? priorityScore;
  int? published;
  int? lastUpdatedAt;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        code: json["code"] == null ? null : json["code"],
        mediable: json["mediable"] == null
            ? null
            : Mediable.fromJson(json["mediable"]),
        published: json["published"] == null ? null : json["published"],
        mediableType:
            json["mediable_type"] == null ? null : json["mediable_type"],
        priorityScore:
            json["priority_score"] == null ? null : json["priority_score"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "mediable": mediable == null ? null : mediable!.toJson(),
        "published": published == null ? null : published,
        "mediable_type": mediableType == null ? null : mediableType,
        "priority_score": priorityScore == null ? null : priorityScore,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class Mediable {
  Mediable({
    this.code,
    this.name,
    this.orders,
    this.albumSize,
    this.albumType,
    this.priorityScore,
    this.jvtFileConnectors,
    this.albumCoverImage,
    this.url,
    this.baseUrl,
  });

  String? code;
  String? name;
  List<dynamic>? orders;

  // List<Order> orders;
  AlbumSize? albumSize;
  int? albumType;
  int? priorityScore;

  // List<JvtFileConnectors> jvtFileConnectors;
  List<dynamic>? jvtFileConnectors;
  AlbumCoverImage? albumCoverImage;
  String? url;
  String? baseUrl;

  factory Mediable.fromJson(Map<String, dynamic> json) => Mediable(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        orders: json["orders"] == null ? null : json["orders"],
        // orders: json["orders"] == null ? null : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        albumSize: json["album_size"] == null
            ? null
            : AlbumSize.fromJson(json["album_size"]),
        albumType: json["album_type"] == null ? null : json["album_type"],
        priorityScore:
            json["priority_score"] == null ? null : json["priority_score"],
        /*jvtFileConnectors: json["jvt_file_connectors"] == null ? null :
    List<JvtFileConnectors>.from(json["jvt_file_connectors"].map((x) => JvtFileConnectors.fromJson(x))),*/
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : json["jvt_file_connectors"],
        url: json["url"] == null ? null : json["url"],
        baseUrl: json["base_url"] == null ? null : json["base_url"],
        albumCoverImage: json["album_cover_image"] == null
            ? null
            : AlbumCoverImage.fromJson(json["album_cover_image"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "album_cover_image": albumCoverImage?.toJson(),
        "orders": orders == null ? null : orders,
        //  "orders": orders == null ? null : List<dynamic>.from(orders.map((x) => x.toJson())),
        "album_size": albumSize == null ? null : albumSize!.toJson(),
        "album_type": albumType == null ? null : albumType,
        "priority_score": priorityScore == null ? null : priorityScore,
        //  "jvt_file_connectors": jvtFileConnectors == null ? null : List<dynamic>.from(jvtFileConnectors.map((x) => x.toJson())),
        "jvt_file_connectors":
            jvtFileConnectors == null ? null : jvtFileConnectors,
        "url": url == null ? null : url,
        "base_url": baseUrl == null ? null : baseUrl,
      };
}

class AlbumCoverImage {
  List<JvtFileConnectors>? jvtFileConnectors;

  AlbumCoverImage({
    this.jvtFileConnectors,
  });

  factory AlbumCoverImage.fromJson(Map<String, dynamic> json) =>
      AlbumCoverImage(
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? []
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]!
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jvt_file_connectors": jvtFileConnectors == null
            ? []
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}

class Album {
  Album({
    this.code,
    this.name,
    this.orders,
    this.published,
    this.albumSize,
    this.type,
    this.priorityScore,
    this.lastUpdatedAt,
    this.jvtFileConnectors,
  });

  String? code;
  String? name;
  List<Order>? orders;
  int? published;
  AlbumSize? albumSize;
  int? type;
  int? priorityScore;
  int? lastUpdatedAt;
  List<JvtFileConnectors>? jvtFileConnectors;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        orders: json["orders"] == null
            ? null
            : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        published: json["publish"] == null ? null : json["publish"],
        albumSize: json["album_size"] == null
            ? null
            : AlbumSize.fromJson(json["album_size"]),
        type: json["album_type"] == null ? null : json["album_type"],
        priorityScore:
            json["priority_score"] == null ? null : json["priority_score"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "orders": orders == null
            ? null
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "publish": published == null ? null : published,
        "album_size": albumSize == null ? null : albumSize!.toJson(),
        "album_type": type == null ? null : type,
        "priority_score": priorityScore == null ? null : priorityScore,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}

class AlbumSize {
  AlbumSize({
    this.type,
    this.size,
  });

  String? type;
  String? size;

  factory AlbumSize.fromJson(Map<String, dynamic> json) => AlbumSize(
        type: json["type"] == null ? null : json["type"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "size": size == null ? null : size,
      };
}

class CoverImage {
  CoverImage({
    this.id,
    this.name,
    this.mode,
    this.size,
  });

  int? id;
  String? name;
  String? mode;
  int? size;

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        mode: json["mode"] == null ? null : json["mode"],
        size: json["size"] == null ? null : json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "mode": mode == null ? null : mode,
        "size": size == null ? null : size,
      };
}

class Video {
  Video({
    this.url,
    this.code,
    this.name,
    this.publish,
    this.priorityScore,
    this.lastUpdatedAt,
  });

  String? url;
  String? code;
  String? name;
  int? publish;
  int? priorityScore;
  int? lastUpdatedAt;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        url: json["url"] == null ? null : json["url"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        publish: json["publish"] == null ? null : json["publish"],
        priorityScore:
            json["priority_score"] == null ? null : json["priority_score"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "publish": publish == null ? null : publish,
        "priority_score": priorityScore == null ? null : priorityScore,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class Order {
  Order(
      {this.code,
      this.priority,
      this.imageType,
      this.jvtFileConnectors,
      this.lastUpdatedAt,
      this.originalFileName});

  String? code;
  int? priority;
  int? imageType;
  List<JvtFileConnectors>? jvtFileConnectors;
  int? lastUpdatedAt;
  String? originalFileName;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        code: json["code"] == null ? null : json["code"],
        priority: json["priority"] == null ? null : json["priority"],
        imageType: json["image_type"] == null ? null : json["image_type"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        originalFileName: json["original_file_name"] == null
            ? null
            : json["original_file_name"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "priority": priority == null ? null : priority,
        "image_type": imageType == null ? null : imageType,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "original_file_name":
            originalFileName == null ? null : originalFileName,
      };
}

/*class EventDuration {
  EventDuration({
    this.endTime,
    this.startTime,
  });

  String endTime;
  String startTime;

  factory EventDuration.fromJson(Map<String, dynamic> json) => EventDuration(
    endTime: json["end_time"],
    startTime: json["start_time"],
  );

  Map<String, dynamic> toJson() => {
    "end_time": endTime.toString(),
    "start_time": startTime.toString(),
  };
}*/
class EventDuration {
  EventDuration({
    this.endTime,
    this.startTime,
  });

  String? endTime;
  String? startTime;

  factory EventDuration.fromJson(Map<String, dynamic> json) => EventDuration(
        endTime: json["end_time"] == null ? null : json["end_time"],
        startTime: json["start_time"] == null ? null : json["start_time"],
      );

  Map<String, dynamic> toJson() => {
        "end_time": endTime == null ? null : endTime.toString(),
        "start_time": startTime == null ? null : startTime.toString(),
      };
}

class Subevent {
  Subevent({
    this.name,
    this.address,
    this.duration,
  });

  String? name;
  Address? address;
  EventDuration? duration;

  factory Subevent.fromJson(Map<String, dynamic> json) => Subevent(
        name: json["name"],
        address: Address.fromJson(json["address"]),
        duration: EventDuration.fromJson(json["duration"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address!.toJson(),
        "duration": duration!.toJson(),
      };
}
