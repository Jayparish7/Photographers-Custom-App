// To parse this JSON data, do
//
//     final userDetailsShowModel = userDetailsShowModelFromJson(jsonString);

import 'dart:convert';

UserDetailsShowModel userDetailsShowModelFromJson(str) => UserDetailsShowModel.fromJson(json.decode(str));

String userDetailsShowModelToJson(UserDetailsShowModel data) => json.encode(data.toJson());

class UserDetailsShowModel {
  int? lastUpdatedAt;
  User ?user;

  UserDetailsShowModel({
    this.lastUpdatedAt,
    this.user,
  });

  factory UserDetailsShowModel.fromJson(Map<String, dynamic> json) => UserDetailsShowModel(
    lastUpdatedAt: json["last_updated_at"] == null ? null : json["last_updated_at"],
    user: json["data"] == null ? null : User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
    "user": user == null ? null : user!.toJson(),
  };
}

class User {
  String? name;
  String ?phoneNumber;
  Email ?email;
  int ?preDesignedAlbums;
  int ?completedAlbums;
  List<ProfileImage>? profileImage;
 /* int imageId;
  String imageName;
  String profileImage;*/

  User({
    this.name,
    this.phoneNumber,

    this.preDesignedAlbums,
    this.completedAlbums,
    this.profileImage,
    this.email,
   /* this.imageId,
    this.imageName,
    this.profileImage,*/
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"] == null ? null : json["name"],
    phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
    email: json["email"] == null ? null : Email.fromJson(json["email"]),
    preDesignedAlbums: json["pre_designed_albums"] == null ? null : json["pre_designed_albums"],
    completedAlbums: json["completed_albums"] == null ? null : json["completed_albums"],
    //imageId: json["image_id"] == null ? null : json["image_id"],
    //imageName: json["image_name"] == null ? null : json["image_name"],
    profileImage: json["profile_image"] == null ? null : new List<ProfileImage>.from(json["profile_image"].map((x) => ProfileImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "phone_number": phoneNumber == null ? null : phoneNumber,
    "email": email == null ? null : email!.toJson(),
    "pre_designed_albums": preDesignedAlbums == null ? null : preDesignedAlbums,
    "completed_albums": completedAlbums == null ? null : completedAlbums,
    //"image_id": imageId == null ? null : imageId,
    //"image_name": imageName == null ? null : imageName,
    "profile_image": profileImage == null ? null : new List<dynamic>.from(profileImage!.map((x) => x.toJson())),
  };
}

class ProfileImage {
  int ?imageId;
  int? updateStatus;
  ProfileImageData? data;

  ProfileImage({
    this.imageId,
    this.updateStatus,
    this.data,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    imageId: json["id"] == null ? null : json["id"],
    updateStatus: json["update_status"] == null ? null : json["update_status"],
    data: json["data"] == null ? null : ProfileImageData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": imageId == null ? null : imageId,
    "update_status": updateStatus == null ? null : updateStatus,
    "data": data == null ? null : data,
  };
}

class   ProfileImageData {
  int? id;
  String ?resAccessType;
  String ?imageOriginalUrl;
  int ?imageOriginalSize;

  ProfileImageData({
    this.id,
    this.resAccessType,
    this.imageOriginalUrl,
    this.imageOriginalSize,
  });

  factory ProfileImageData.fromJson(Map<String, dynamic> json) => ProfileImageData(
    id: json["id"] == null ? null : json["id"],
    resAccessType: json["access_type"] == null ? null : json["access_type"],
    imageOriginalUrl: json["image"] == null ? null : json["image"],
    imageOriginalSize: json["original_size"] == null ? null : json["original_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "access_type": resAccessType == null ? null : resAccessType,
    "image": imageOriginalUrl == null ? null : imageOriginalUrl,
    "original_size": imageOriginalSize == null ? null : imageOriginalSize,
  };

}


class Email {
  Email({
    this.token,
    this.address,
    this.verify,
  });

  String ?token;
  String ?address;
  int ?verify;

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
