import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import '../core/models/apiModels/transport_model/transport_model.dart';
import '../driftdb/dao/user_persons_dao.dart';

class UserPersonsController {
  Future<void> upsertUserPerson(
      {required List<UserPerson>? UserPersonData}) async {
    UserPersonsDao userPersonsDao = UserPersonsDao();
    List create = []; // insert this event
    List delete = []; // delete this event
    List update = []; // change update required as true
    List<String> apiUserPerson = [];
    List<String> notify = [];
    List<String> existingUserPerson = [];
    List<appDb.UserPersonsCompanion> UserPersonCompanionsInsertOrUpdate = [];
    showLog('UserPersonData $UserPersonData');

    if (UserPersonData != null && UserPersonData.isNotEmpty) {
      showLog('userData 1');

      for (UserPerson userData in UserPersonData) {
        List<UserPerson>? userPersonData = UserPersonData;
        showLog('userData $userData');

        //String eventCode = aIData.code!;
        if (userPersonData.isNotEmpty) {
          for (UserPerson user in userPersonData) {
            apiUserPerson.add(user.code!);
            showLog('api userData is ${apiUserPerson.length}');
          }
          if (apiUserPerson.isNotEmpty) {
            /// get local userData

            List<appDb.UserPerson> userPersons =
                await userPersonsDao.getUserPersons();
            showLog('local print $userPersons');
            if (userPersons.isNotEmpty) {
              userPersons.forEach((_print) {
                existingUserPerson.add(_print.code);
              });
            }
            for (int i = 0; i < apiUserPerson.length; i++) {
              if (existingUserPerson.contains(apiUserPerson[i])) {
                update.add(apiUserPerson[i]);
              }
              if (!existingUserPerson.contains(apiUserPerson[i])) {
                notify.add(apiUserPerson[i]);
                create.add(apiUserPerson[i]);
              }
            }
            for (int i = 0; i < existingUserPerson.length; i++) {
              if (!apiUserPerson.contains(existingUserPerson[i])) {
                delete.add(existingUserPerson[i]);
              }
            }

            /// INSERT New Folder
            if (create.isNotEmpty) {
              for (int i = 0; i < create.length; i++) {
                List<UserPerson?>? _newUserPersons = userPersonData
                    .where((obj) => obj.code == create[i])
                    .toList();
                if (_newUserPersons.isNotEmpty &&
                    _newUserPersons.first != null) {
                  UserPersonCompanionsInsertOrUpdate.add(
                      appDb.UserPersonsCompanion(
                    code: drift.Value(_newUserPersons.first!.code!),
                    name: drift.Value(_newUserPersons.first!.name ?? ''),
                    relationship:
                        drift.Value(_newUserPersons.first!.relationship!),
                    userOwnImage:
                        drift.Value(_newUserPersons.first!.userOwnImage!),
                    images:
                        drift.Value(json.encode(_newUserPersons.first!.images)),
                  ));
                  showLog(
                      'upsertUserPersonToString :  ${_newUserPersons.first!.images.toString()}');
                }
              }
            }

            /// UPDATE Existing Folder
            if (update.isNotEmpty) {
              for (int i = 0; i < update.length; i++) {
                List<UserPerson?>? _updateUserPersons = userPersonData
                    .where((obj) => obj.code == update[i])
                    .toList();

                // update all
                if (_updateUserPersons.isNotEmpty &&
                    _updateUserPersons.first != null) {
                  UserPersonCompanionsInsertOrUpdate.add(
                      appDb.UserPersonsCompanion(
                    code: drift.Value(_updateUserPersons.first!.code!),
                    name: drift.Value(_updateUserPersons.first!.name!),
                    relationship:
                        drift.Value(_updateUserPersons.first!.relationship!),
                    userOwnImage:
                        drift.Value(_updateUserPersons.first!.userOwnImage!),
                    images: drift.Value(
                        json.encode(_updateUserPersons.first!.images!)),
                  ));
                }
              }
            }

            /// DELETE Folder NEED TO BE DELETED
            if (delete.isNotEmpty) {
              for (int i = 0; i < delete.length; i++) {
                await userPersonsDao.deleteUserPersons(code: delete[i]);
              }
            }
          }
        }
      }
      if (UserPersonCompanionsInsertOrUpdate.isNotEmpty) {
        await userPersonsDao
            .insertUserPersons(UserPersonCompanionsInsertOrUpdate);
      }
      showLog('upsert UserPerson :  ${create.length}');
      showLog('upsertUserPerson11 :  ${update.length}');
      showLog('upsertUserPerson12 :  ${delete.length}');
      showLog(
          'upsertUserPerson:  ${UserPersonCompanionsInsertOrUpdate.length}');
    }
  }
}

/*
class UserPerson1 {
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
*/

class JvtFile {
  String? code;
  int? mode;
  String? name;
  int? size;
  String? extension;

  JvtFile({this.code, this.mode, this.name, this.size, this.extension});

  factory JvtFile.fromJson(Map<String, dynamic> json) {
    return JvtFile(
      code: json['code'],
      mode: json['mode'],
      name: json['name'],
      size: json['size'],
      extension: json['extension'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'mode': mode,
      'name': name,
      'size': size,
      'extension': extension,
    };
  }
}

class JvtFileConnectors {
  String? code;
  String? name;
  JvtFile? jvtFile;
  int? screenDisplay;

  JvtFileConnectors({
    this.code,
    this.name,
    this.jvtFile,
    this.screenDisplay,
  });

  factory JvtFileConnectors.fromJson(List<dynamic> json) {
    if (json.isEmpty)
      return JvtFileConnectors(); // Return an empty instance if the list is empty
    var data =
        json[0]; // Assuming the first element of the list contains the data
    return JvtFileConnectors(
      code: data["code"],
      name: data["name"],
      jvtFile:
          data["jvt_file"] != null ? JvtFile.fromJson(data["jvt_file"]) : null,
      screenDisplay: data["screen_display"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "name": name,
      "jvt_file": jvtFile != null ? jvtFile!.toJson() : null,
      "screen_display": screenDisplay,
    };
  }
}
