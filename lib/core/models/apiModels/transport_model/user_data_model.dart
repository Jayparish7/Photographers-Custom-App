//import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';
part of 'transport_model.dart';

class UserData {
  UserData({
    this.updateRequired,
    this.lastUpdatedAt,
    this.userDataData,
  });

  int? updateRequired;
  int? lastUpdatedAt;
  UserDataData? userDataData;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        updateRequired:
            json["update_required"] == null ? null : json["update_required"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        userDataData:
            json["data"] == null ? null : UserDataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "update_required": updateRequired == null ? null : updateRequired,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "data": userDataData == null ? null : userDataData!.toJson(),
      };
}

class UserDataData {
  UserDataData({
    this.accountData,
    this.studioUserData,
  });

  AccountData? accountData;
  StudioUserData? studioUserData;

  factory UserDataData.fromJson(Map<String, dynamic> json) => UserDataData(
        accountData: json["account_data"] == null
            ? null
            : AccountData.fromJson(json["account_data"]),
        studioUserData: json["studio_user_data"] == null
            ? null
            : StudioUserData.fromJson(json["studio_user_data"]),
      );

  Map<String, dynamic> toJson() => {
        "account_data": accountData == null ? null : accountData!.toJson(),
        "studio_user_data":
            studioUserData == null ? null : studioUserData!.toJson(),
      };
}

class AccountData {
  AccountData({
    this.code,
    this.name,
    this.emails,
    this.language,
    this.phoneNumber,
    this.lastUpdatedAt,
    this.jvtFileConnectors,
    this.userPersons,
    this.dateOfBirth,
    this.maritalStatus,
    this.anniversary,
  });

  String? code;
  String? name;
  List<DataEmail>? emails;
  Language? language;
  String? phoneNumber;
  String? dateOfBirth;
  int? maritalStatus;
  String? anniversary;
  int? lastUpdatedAt;
  List<JvtFileConnectors>? jvtFileConnectors;
  List<UserPerson>? userPersons;

  factory AccountData.fromJson(Map<String, dynamic> json) => AccountData(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        emails: json["emails"] == null
            ? null
            : List<DataEmail>.from(
                json["emails"].map((x) => DataEmail.fromJson(x))),
        language: json["language"] == null
            ? null
            : Language.fromJson(json["language"]),
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        dateOfBirth: json["date_of_birth"] == null ? null : json["date_of_birth"],
        maritalStatus: json["marital_status"] == null ? null : json["marital_status"],
        anniversary: json["anniversary"] == null ? null : json["anniversary"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        jvtFileConnectors: json["jvt_file_connectors"] == null
            ? null
            : List<JvtFileConnectors>.from(json["jvt_file_connectors"]
                .map((x) => JvtFileConnectors.fromJson(x))),
        userPersons: json["user_persons"] == null
            ? []
            : List<UserPerson>.from(
                json["user_persons"]!.map((x) => UserPerson.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "emails": emails == null
            ? null
            : List<dynamic>.from(emails!.map((x) => x.toJson())),
        "language": language == null ? null : language!.toJson(),
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "date_of_birth": dateOfBirth == null ? null : dateOfBirth,
        "marital_status": maritalStatus == null ? null : maritalStatus,
        "anniversary": anniversary == null ? null : anniversary,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "jvt_file_connectors": jvtFileConnectors == null
            ? null
            : List<dynamic>.from(jvtFileConnectors!.map((x) => x.toJson())),
        "user_persons": userPersons == null
            ? []
            : List<dynamic>.from(userPersons!.map((x) => x.toJson())),
      };
}

class UserPerson {
  String? code;
  String? name;
  int? userOwnImage;
  String? relationship;
  List<JvtFileConnectors>? images;

  UserPerson({
    this.code,
    this.name,
    this.userOwnImage,
    this.relationship,
    this.images,
  });

  factory UserPerson.fromJson(Map<String, dynamic> json) => UserPerson(
        code: json["code"],
        name: json["name"],
        userOwnImage: json["user_own_image"],
        relationship: json["relationship"],
        images: json["images"] == null
            ? []
            : List<JvtFileConnectors>.from(
                json["images"]!.map((x) => JvtFileConnectors.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "user_own_image": userOwnImage,
        "relationship": relationship,
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Language {
  Language({
    this.code,
    this.font,
    this.name,
    this.symbol,
    this.lastUpdatedAt,
  });

  String? code;
  String? font;
  String? name;
  String? symbol;
  int? lastUpdatedAt;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json["code"] == null ? null : json["code"],
        font: json["font"] == null ? null : json["font"],
        name: json["name"] == null ? null : json["name"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "font": font == null ? null : font,
        "name": name == null ? null : name,
        "symbol": symbol == null ? null : symbol,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class StudioUserData {
  StudioUserData({
    this.studioUserDataDetail,
    this.lastUpdatedAt,
    this.updateRequired,
  });

  StudioUserDataDetail? studioUserDataDetail;
  int? lastUpdatedAt;
  int? updateRequired;

  factory StudioUserData.fromJson(Map<String, dynamic> json) => StudioUserData(
        studioUserDataDetail: json["data"] == null
            ? null
            : StudioUserDataDetail.fromJson(json["data"]),
        updateRequired:
            json["update_required"] == null ? null : json["update_required"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "data": studioUserDataDetail == null
            ? null
            : studioUserDataDetail!.toJson(),
        "update_required": updateRequired == null ? null : updateRequired,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}

class StudioUserDataDetail {
  StudioUserDataDetail({
    this.events,
    this.archivedEvents,
    this.photoSelections,
    this.deletion,
  });

  List<String>? events;
  List<String>? archivedEvents;
  List<String>? photoSelections;
  Deletion? deletion;

  factory StudioUserDataDetail.fromJson(Map<String, dynamic> json) =>
      StudioUserDataDetail(
        events: json["events"] == null
            ? null
            : List<String>.from(json["events"].map((x) => x)),
        archivedEvents: json["archived_events"] == null
            ? null
            : List<String>.from(json["archived_events"].map((x) => x)),
        photoSelections: json["photo_selections"] == null
            ? null
            : List<String>.from(json["photo_selections"].map((x) => x)),
        deletion: json.containsKey("deletion")
            ? json["deletion"] == null
                ? null
                : Deletion.fromJson(json["deletion"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "events":
            events == null ? null : List<dynamic>.from(events!.map((x) => x)),
        "archived_events": archivedEvents == null
            ? null
            : List<dynamic>.from(archivedEvents!.map((x) => x)),
        "photo_selections": photoSelections == null
            ? null
            : List<dynamic>.from(photoSelections!.map((x) => x)),
        "deletion": deletion == null ? null : deletion!.toJson(),
      };
}

class Deletion {
  String code;
  int daysCount;
  int createdAt;

  Deletion({
    required this.code,
    required this.daysCount,
    required this.createdAt,
  });

  factory Deletion.fromJson(Map<String, dynamic> json) => Deletion(
        code: json["code"],
        daysCount: json["days_count"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "days_count": daysCount,
        "created_at": createdAt,
      };
}

class DataEmail {
  DataEmail({
    this.token,
    this.address,
    this.verify,
  });

  String? token;
  String? address;
  int? verify;

  factory DataEmail.fromJson(Map<String, dynamic> json) => DataEmail(
        token: json["token"] == null ? null : json["token"],
        address: json["address"] == null ? null : json["address"],
        verify: json["verify"] == null ? null : json["verify"],
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "address": address == null ? null : address,
        "verify": verify == null ? null : verify,
      };
}
