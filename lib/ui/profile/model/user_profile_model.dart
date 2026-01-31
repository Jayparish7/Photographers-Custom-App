// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(str) =>
    UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.user,
  });

  UserData? user;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        user: json["user"] == null ? null : UserData.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user!.toJson(),
      };
}

UserCompaniesModel userCompaniesModelFromJson(str) =>
    UserCompaniesModel.fromJson(json.decode(str));

String companyDetailsModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserCompaniesModel {
  UserCompaniesModel({
    this.companies,
  });

  List<UserData>? companies;

  factory UserCompaniesModel.fromJson(Map<String, dynamic> json) =>
      UserCompaniesModel(
        companies: json["user_companies"] == null
            ? null
            : List<UserData>.from(
                json["user_companies"].map((x) => UserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        //"user_companies": companies == null ? null : companies.toJson(),
      };
}

class UserData {
  UserData({
    this.code,
    this.status,
    this.name,
    this.companyBindStatus,
    this.phones,
    this.emails,
    this.wallet,
    this.addresses,
    this.profileImage,
  });

  String? code;
  int? status;
  String? name;
  int? companyBindStatus;
  List<PhoneNumber>? phones;
  List<Email>? emails;
  Wallet? wallet;
  AccountAddress? addresses;
  ProfileImage? profileImage;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        name: json["name"] == null ? null : json["name"],
        companyBindStatus: json["company_bind_status"] == null
            ? null
            : json["company_bind_status"],
        phones: json["phones"] == null
            ? null
            : List<PhoneNumber>.from(
                json["phones"].map((x) => PhoneNumber.fromJson(x))),
        emails: json["emails"] == null
            ? null
            : List<Email>.from(json["emails"].map((x) => Email.fromJson(x))),
        wallet: json["wallet"] == null ? null : Wallet.fromJson(json["wallet"]),
        addresses: json["address"] == null
            ? null
            : AccountAddress.fromJson(json["address"]),
        profileImage: json["profile_image"] == null
            ? null
            : ProfileImage.fromJson(json["profile_image"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "name": name == null ? null : name,
        "company_bind_status":
            companyBindStatus == null ? null : companyBindStatus,
        "phones": phones == null
            ? null
            : List<dynamic>.from(phones!.map((x) => x.toJson())),
        "emails": emails == null
            ? null
            : List<dynamic>.from(emails!.map((x) => x.toJson())),
        "wallet": wallet == null ? null : wallet!.toJson(),
        "address": addresses == null ? null : addresses!.toJson(),
        "profile_image": profileImage == null ? null : profileImage!.toJson(),
      };
}

class PhoneNumber {
  PhoneNumber({
    this.token,
    this.number,
    this.verify,
    this.isProgress = false,
  });

  String? token;
  String? number;
  int? verify;
  bool? isProgress;

  factory PhoneNumber.fromJson(Map<String, dynamic> json) => PhoneNumber(
        token: json["token"] == null ? null : json["token"],
        number: json["number"] == null ? null : json["number"],
        verify: json["verify"] == null ? null : json["verify"],
      );

  Map<String, dynamic> toJson() => {
        "token": token == null ? null : token,
        "number": number == null ? null : number,
        "verify": verify == null ? null : verify,
      };
}

class Email {
  Email({
    this.token,
    this.address,
    this.verify,
    this.isProgress = false,
  });

  String? token;
  String? address;
  int? verify;
  bool? isProgress;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
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

class ProfileImage {
  ProfileImage({
    this.code,
    this.accessType,
    this.file,
  });

  String? code;
  String? accessType;
  String? file;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        code: json["code"] == null ? null : json["code"],
        accessType: json["access_type"] == null ? null : json["access_type"],
        file: json["file"] == null ? null : json["file"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "access_type": accessType == null ? null : accessType,
        "file": file == null ? null : file,
      };
}

class Wallet {
  Wallet({
    this.amount,
  });

  int? amount;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        amount: json["amount"] == null ? null : json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
      };
}

class AccountAddress {
  AccountAddress({
    this.code,
    this.street,
    this.locality,
    this.district,
    this.state,
    this.zip,
    this.tag,
    this.landmark,
  });

  String ?code;
  String ?street;
  String ?locality;
  String? district;
  String ?state;
  String ?zip;
  String? tag;
  String ?landmark;

  factory AccountAddress.fromJson(Map<String, dynamic> json) => AccountAddress(
        code: json["code"] == null ? null : json["code"],
        street: json["street"] == null ? null : json["street"],
        locality: json["locality"] == null ? null : json["locality"],
        district: json["district"] == null ? null : json["district"],
        state: json["province"] == null ? null : json["province"],
        zip: json["zip"] == null ? null : json["zip"],
        tag: json["tag"] == null ? null : json["tag"],
        landmark: json["landmark"] == null ? null : json["landmark"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "tag": tag == null ? null : tag,
        "street": street == null ? null : street,
        "locality": locality == null ? null : locality,
        "district": district == null ? null : district,
        "province": state == null ? null : state,
        "zip": zip == null ? null : zip,
      };
}
