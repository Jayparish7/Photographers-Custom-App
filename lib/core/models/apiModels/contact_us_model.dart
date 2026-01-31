// To parse this JSON data, do
//
//     final contactUsModel = contactUsModelFromJson(jsonString);

import 'dart:convert';

ContactUsModel contactUsModelFromJson(str) =>
    ContactUsModel.fromJson(json.decode(str));

String contactUsModelToJson(ContactUsModel data) => json.encode(data.toJson());

class ContactUsModel {
  String? status;
  int? action;
  int? lastUpdatedAt;
  ContactUsModelDetail? detail;

  ContactUsModel({
    this.status,
    this.action,
    this.lastUpdatedAt,
    this.detail,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) => ContactUsModel(
        status: json["status"] == null ? null : json["status"],
        action: json["action"] == null ? null : json["action"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
        detail: json["detail"] == null
            ? null
            : ContactUsModelDetail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "action": action == null ? null : action,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
        "detail": detail == null ? null : detail!.toJson(),
      };
}

class ContactUsModelDetail {
  List<Phone>? phones;
  List<EmailAddress>? emailAddresses;
  List<SocialProfile>? socialProfiles;
  List<Addresses>? addresses;
  DetailDetail? detail;

  ContactUsModelDetail({
    this.phones,
    this.emailAddresses,
    this.socialProfiles,
    this.addresses,
    this.detail,
  });

  factory ContactUsModelDetail.fromJson(Map<String, dynamic> json) =>
      ContactUsModelDetail(
        phones: json["phones"] == null
            ? null
            : List<Phone>.from(json["phones"].map((x) => Phone.fromJson(x))),
        emailAddresses: json["email_addresses"] == null
            ? null
            : List<EmailAddress>.from(
                json["email_addresses"].map((x) => EmailAddress.fromJson(x))),
        socialProfiles: json["social_profiles"] == null
            ? null
            : List<SocialProfile>.from(
                json["social_profiles"].map((x) => SocialProfile.fromJson(x))),
        addresses: json["addresses"] == null
            ? null
            : List<Addresses>.from(
                json["addresses"].map((x) => Addresses.fromJson(x))),
        detail: json["detail"] == null
            ? null
            : DetailDetail.fromJson(json["detail"]),
      );

  Map<String, dynamic> toJson() => {
        "phones": phones == null
            ? null
            : List<dynamic>.from(phones!.map((x) => x.toJson())),
        "email_addresses": emailAddresses == null
            ? null
            : List<dynamic>.from(emailAddresses!.map((x) => x.toJson())),
        "social_profiles": socialProfiles == null
            ? null
            : List<dynamic>.from(socialProfiles!.map((x) => x.toJson())),
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "detail": detail == null ? null : detail!.toJson(),
      };
}

class Addresses {
  int? id;
  int? updateStatus;
  AddressesData? data;

  Addresses({this.id, this.updateStatus, this.data});

  factory Addresses.fromJson(Map<String, dynamic> json) => Addresses(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data:
            json["data"] == null ? null : AddressesData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class AddressesData {
  int? id;
  String? street;
  String? locality;
  String? district;
  String? state;
  String? country;
  String? pincode;

  AddressesData({
    this.id,
    this.street,
    this.locality,
    this.district,
    this.state,
    this.country,
    this.pincode,
  });

  factory AddressesData.fromJson(Map<String, dynamic> json) => AddressesData(
        id: json["id"] == null ? null : json["id"],
        street: json["street"] == null ? null : json["street"],
        locality: json["locality"] == null ? null : json["locality"],
        district: json["district"] == null ? null : json["district"],
        state: json["state"] == null ? null : json["state"],
        country: json["country"] == null ? null : json["country"],
        pincode: json["pincode"] == null ? null : json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "street": street == null ? null : street,
        "locality": locality == null ? null : locality,
        "district": district == null ? null : district,
        "state": state == null ? null : state,
        "country": country == null ? null : country,
        "pincode": pincode == null ? null : pincode,
      };
}

class DetailDetail {
  int? id;
  int? updateStatus;
  DetailDetailData? data;

  DetailDetail({this.id, this.updateStatus, this.data});

  factory DetailDetail.fromJson(Map<String, dynamic> json) => DetailDetail(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null
            ? null
            : DetailDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class DetailDetailData {
  int? id;
  String? name;
  String? website;

  DetailDetailData({
    this.id,
    this.name,
    this.website,
  });

  factory DetailDetailData.fromJson(Map<String, dynamic> json) =>
      DetailDetailData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        website: json["website"] == null ? null : json["website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "website": website == null ? null : website,
      };
}

class EmailAddress {
  int? id;
  int? updateStatus;
  EmailAddressData? data;

  EmailAddress({this.id, this.updateStatus, this.data});

  factory EmailAddress.fromJson(Map<String, dynamic> json) => EmailAddress(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null
            ? null
            : EmailAddressData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class EmailAddressData {
  int? id;
  String? address;

  EmailAddressData({
    this.id,
    this.address,
  });

  factory EmailAddressData.fromJson(Map<String, dynamic> json) =>
      EmailAddressData(
        id: json["id"] == null ? null : json["id"],
        address: json["address"] == null ? null : json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "address": address == null ? null : address,
      };
}

class Phone {
  int? id;
  int? updateStatus;
  PhoneData? data;

  Phone({this.id, this.updateStatus, this.data});

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null ? null : PhoneData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class PhoneData {
  int? id;
  String? phoneNumber;

  PhoneData({
    this.id,
    this.phoneNumber,
  });

  factory PhoneData.fromJson(Map<String, dynamic> json) => PhoneData(
        id: json["id"] == null ? null : json["id"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "phone_number": phoneNumber == null ? null : phoneNumber,
      };
}

class SocialProfile {
  int? id;
  int? updateStatus;
  SocialProfileData? data;

  SocialProfile({this.id, this.updateStatus, this.data});

  factory SocialProfile.fromJson(Map<String, dynamic> json) => SocialProfile(
        id: json["id"] == null ? null : json["id"],
        updateStatus:
            json["update_status"] == null ? null : json["update_status"],
        data: json["data"] == null
            ? null
            : SocialProfileData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "update_status": updateStatus == null ? null : updateStatus,
        "data": data == null ? null : data!.toJson(),
      };
}

class SocialProfileData {
  int? id;
  int? type;
  String? url;

  SocialProfileData({
    this.id,
    this.type,
    this.url,
  });

  factory SocialProfileData.fromJson(Map<String, dynamic> json) =>
      SocialProfileData(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "url": url == null ? null : url,
      };
}
