part of 'transport_model.dart';

class PhotoSelectionModel {
  PhotoSelectionModel({
    this.code,
    this.updateRequired,
    this.lastUpdatedAt,
    this.data,
  });

  String? code;
  int? updateRequired;
  int? lastUpdatedAt;

//  PhotoSelectionData data;
  Map<String, dynamic>? data;

  factory PhotoSelectionModel.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionModel(
        code: json["code"] == null ? null : json["code"],
        updateRequired:
            json["update_required"] == null ? null : json["update_required"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        data: json["data"] == null ? null : json["data"],
        //   data: json["data"] == null ? null : PhotoSelectionData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "update_required": updateRequired == null ? null : updateRequired,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "data": data == null ? null : data,
        //  "data": data == null ? null : data.toJson(),
      };
}

class PhotoSelectionData {
  PhotoSelectionData({
    this.code,
    this.name,
    this.type,
    this.folders,
    this.publish,
    this.categoryName,
    this.loginRequired,
    this.lastUpdatedAt,
    this.jvtFileConnectors,
    this.photoselection,
    this.downloadable,
    this.downloadWithIcon,
    this.downloadWithWatermark,
    this.persons,
    this.realPersons,
    this.imageWithoutPerson,
  });

  String? code;
  String? name;
  int? type;
  List<FolderData>? folders;
  bool? publish;
  String? categoryName;
  bool? loginRequired;
  int? lastUpdatedAt;
  List<JvtFileConnectors>? jvtFileConnectors;
  Photoselection? photoselection;
  int? downloadWithIcon;
  int? downloadWithWatermark;
  int? downloadable;
  List<Person>? persons;
  List<RealPerson>? realPersons;
  List<String>? imageWithoutPerson;

  factory PhotoSelectionData.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionData(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        folders: json["folders"] == null
            ? null
            : List<FolderData>.from(
                json["folders"].map((x) => FolderData.fromJson(x))),
        publish: json["published"] == null
            ? null
            : (json["published"] == 1 ? true : false),
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        //loginRequired: json["login_required"] == null ? null : json["login_required"],
        loginRequired: json["login_required"] == null
            ? null
            : (json["login_required"] == 1 ? true : false),
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
        photoselection: json["photoselection"] == null
            ? null
            : Photoselection.fromJson(json["photoselection"]),
        downloadWithWatermark: json["download_with_watermark"] == null
            ? null
            : json["download_with_watermark"],
        downloadWithIcon: json["download_with_icon"] == null
            ? null
            : json["download_with_icon"],
        downloadable:
            json["downloadable"] == null ? null : json["downloadable"],
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
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "folders": folders == null
            ? null
            : List<dynamic>.from(folders!.map((x) => x.toJson())),
        "published": publish == null ? null : publish,
        "category_name": categoryName == null ? null : categoryName,
        "login_required": loginRequired == null ? null : loginRequired,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x)),
        "photoselection":
            photoselection == null ? null : photoselection!.toJson(),
        "downloadable": downloadable == null ? null : downloadable,
        "download_with_icon":
            downloadWithIcon == null ? null : downloadWithIcon,
        "download_with_watermark":
            downloadWithWatermark == null ? null : downloadWithWatermark,
        "persons": persons == null
            ? []
            : List<dynamic>.from(persons!.map((x) => x.toJson())),
    "image_without_person":  imageWithoutPerson == null
        ? []
        : List<dynamic>.from(imageWithoutPerson!.map((x) => x)),
      };
}

class FolderData {
  FolderData({
    this.code,
    this.name,
    this.rule,
    this.publish,
    this.parentCode,
    this.lastUpdatedAt,
    this.photoSelectionImages,
  });

  String? code;
  String? name;
  Rules? rule;
  bool? publish;
  String? parentCode;
  int? lastUpdatedAt;
  List<PhotoSelectionImageData>? photoSelectionImages;

  factory FolderData.fromJson(Map<String, dynamic> json) => FolderData(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        rule: json["rule"] == null ? null : Rules.fromJson(json["rule"]),
        publish: json["publish"] == null
            ? null
            : (json["publish"] == 1 ? true : false),
        parentCode: json["parent_code"] == null ? null : json["parent_code"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        photoSelectionImages: json["photo_selection_images"] == null
            ? null
            : List<PhotoSelectionImageData>.from(json["photo_selection_images"]
                .map((x) => PhotoSelectionImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "rule": rule == null ? null : rule!.toJson(),
        "publish": publish == null ? null : publish,
        "parent_code": parentCode == null ? null : parentCode,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "photo_selection_images": photoSelectionImages == null
            ? null
            : List<dynamic>.from(photoSelectionImages!.map((x) => x.toJson())),
      };
}
class RealPerson {
  RealPerson({
    this.code,
    this.image,
    this.score,
    this.realPersons,
  });

  String? code;
  String? image;
  int? score;
  List<String>? realPersons;

  factory RealPerson.fromJson(Map<String, dynamic> json) => RealPerson(
    code: json["code"],
    image: json["image_name"],
    score: json["score"],
    realPersons: json["persons"] == null
        ? []
        : List<String>.from(json["persons"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "image_name": image,
    "score": score,
    "persons":
    realPersons == null ? [] : List<dynamic>.from(realPersons!.map((x) => x)),
  };
}
class Person {
  Person({
    this.code,
    this.image,
    this.score,
    this.images,
  });

  String? code;
  String? image;
  int? score;
  List<String>? images;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        code: json["code"],
        image: json["image_name"],
        score: json["score"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "image_name": image,
        "score": score,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
      };
}

class PhotoSelectionImageData {
  PhotoSelectionImageData({
    this.code,
    this.originalFileName,
    this.jvtFileConnectors,
  });

  String? code;
  String? originalFileName;
  List<JvtFileConnectors>? jvtFileConnectors;

  factory PhotoSelectionImageData.fromJson(Map<String, dynamic> json) =>
      PhotoSelectionImageData(
        code: json["code"] == null ? null : json["code"],
        originalFileName: json["original_file_name"] == null
            ? null
            : json["original_file_name"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "original_file_name":
            originalFileName == null ? null : originalFileName,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
      };
}

class JvtFileConnectors {
  JvtFileConnectors({
    this.code,
    this.name,
    this.jvtFile,
    this.screenDisplay,
  });

  String? code;
  String? name;
  JvtFile? jvtFile;
  int? screenDisplay;

  factory JvtFileConnectors.fromJson(Map<String, dynamic> json) =>
      JvtFileConnectors(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        jvtFile: json["jvt_file"] == null
            ? null
            : JvtFile.fromJson(json["jvt_file"]),
        screenDisplay:
            json["screen_display"] == null ? null : json["screen_display"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "jvt_file": jvtFile == null ? null : jvtFile!.toJson(),
        "screen_display": screenDisplay == null ? null : screenDisplay,
      };
}

class JvtFile {
  JvtFile({
    this.code,
    this.mode,
    this.name,
    this.size,
    this.extension,
  });

  String? code;
  int? mode;
  String? name;
  int? size;
  String? extension;

  factory JvtFile.fromJson(Map<String, dynamic> json) => JvtFile(
        code: json["code"] == null ? null : json["code"],
        mode: json["mode"] == null ? null : json["mode"],
        name: json["name"] == null ? null : json["name"],
        size: json["size"] == null ? null : json["size"],
        extension: json["extension"] == null ? null : json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "mode": mode == null ? null : mode,
        "name": name == null ? null : name,
        "size": size == null ? null : size,
        "extension": extension == null ? null : extension,
      };
}

class Rules {
  Rules({
    this.code,
    this.maximumSelectionImages,
    this.minimumSelectionImages,
  });

  String? code;
  int? maximumSelectionImages;
  int? minimumSelectionImages;

  factory Rules.fromJson(Map<String, dynamic> json) => Rules(
        code: json["code"] == null ? null : json["code"],
        maximumSelectionImages: json["maximum_selection_images"] == null
            ? null
            : json["maximum_selection_images"],
        minimumSelectionImages: json["minimum_selection_images"] == null
            ? null
            : json["minimum_selection_images"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "maximum_selection_images":
            maximumSelectionImages == null ? null : maximumSelectionImages,
        "minimum_selection_images":
            minimumSelectionImages == null ? null : minimumSelectionImages,
      };
}

class Photoselection {
  Photoselection({
    this.code,
    this.published,
  });

  String? code;
  int? published;

  factory Photoselection.fromJson(Map<String, dynamic> json) => Photoselection(
        code: json["code"] == null ? null : json["code"],
        published: json["published"] == null ? null : json["published"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "published": published == null ? null : published,
      };
}


UpdateProfileResponseModel updateProfileResponseModelFromJson( str) => UpdateProfileResponseModel.fromJson(json.decode(str));

String updateProfileResponseModelToJson(UpdateProfileResponseModel data) => json.encode(data.toJson());

class UpdateProfileResponseModel {
  int? status;
  JvtFileConnectors? jvtFileConnector;

  UpdateProfileResponseModel({
    this.status,
    this.jvtFileConnector,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) => UpdateProfileResponseModel(
    status: json["status"],
    jvtFileConnector: json["jvt_file_connector"] == null ? null : JvtFileConnectors.fromJson(json["jvt_file_connector"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "jvt_file_connector": jvtFileConnector?.toJson(),
  };
}

