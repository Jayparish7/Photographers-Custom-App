import 'dart:convert';

import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/design_properties_model.dart'
    as color;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart';

class TransporterPreference {
  static final TransporterPreference _instance =
      TransporterPreference._internal();

  factory TransporterPreference() => _instance;

  TransporterPreference._internal();

  /// Save Design Data in Preference
  Future<color.AppDesignKeys?> getColor() async {
    String colorString = await PreferenceHelper.getString("color");
    if (colorString.isEmpty) {
      return null;
    }
/*
    Map<String, dynamic> jsonMap =
        jsonDecode(colorString) */ /*as Map<String, dynamic>*/ /*;*/
    color.AppDesignKeys data =
        color.AppDesignKeys.fromJson(jsonDecode(colorString));

    return data;
  }

  Future<void> setColour({required Map<String, dynamic> colorDatum}) async {
    showLog('the color data where set ::${colorDatum}');
    return await PreferenceHelper.setString("color", jsonEncode(colorDatum));
    //return await PreferenceHelper.setString("color", colorData);
  }

  ///  set languages
 /* Future<List<color.StudioLanguage>?> getLanguages() async {
    String languageString = await PreferenceHelper.getString("language");
    if (languageString.isEmpty) {
      return null;
    }
    List<dynamic> jsonMap = jsonDecode(languageString);
    return jsonMap.map((data) {
      return color.StudioLanguage.fromJson(data);
    }).toList();
  }*/

  Future<void> setLanguages({required List<dynamic> languageData}) async {
    return await PreferenceHelper.setString(
        "language", jsonEncode(languageData));
  }

  /// Get Design Data From Preference

  Future<DesignData?> getDesignData() async {
    String designDataObject = await PreferenceHelper.getString(designDataKey);
    if (designDataObject.isEmpty) {
      return null;
    }
    Map<String, dynamic> jsonMap =
        jsonDecode(designDataObject) as Map<String, dynamic>;
    return DesignData.fromJson(jsonMap);
  }

  Future<void> setDesignData(DesignData designData) async {
    await PreferenceHelper.setString(
        designDataKey, jsonEncode(designData.toJson()));
  }

  Future<void> setAppConfigUserData(UserData userData) async {
    try {
      return await PreferenceHelper.setString(
          userDataKey, jsonEncode(userData.toJson()));
    } catch (e) {
      showLog('the set user data preference error where $e');
    }
  }

  Future<UserData?> getUserData() async {
    String customerObjectString = await PreferenceHelper.getString(userDataKey);
    if (customerObjectString.isEmpty) {
      return null;
    }
    Map<String, dynamic> jsonMap =
        jsonDecode(customerObjectString) as Map<String, dynamic>;
    return UserData.fromJson(jsonMap);
  }

  Future<void> setStudioData(TransportModel appConfigData) async {
    return await PreferenceHelper.setString(
        appConfigKey, jsonEncode(appConfigData.toJson()));
  }

  Future<TransportModel?> getAppConfig() async {
    String customerObjectString =
        await PreferenceHelper.getString(appConfigKey);
    if (customerObjectString.isEmpty) {
      return null;
    }
    Map<String, dynamic> jsonMap =
        jsonDecode(customerObjectString) as Map<String, dynamic>;
    return TransportModel.fromJson(jsonMap);
  }

  Future<void> updateCustomerName(String name) async {
    UserData? userData = await getUserData();
    if (userData != null) {
      if (name == "") {
        userData.userDataData!.accountData!.name = "";
      } else {
        userData.userDataData!.accountData!.name = name;
      }
      setAppConfigUserData(userData);
      return;
    }
    return;
  }
  Future<void> updateCustomerDOB(String dob) async {
    showLog('updateCustomerDOB $dob');

    UserData? userData = await getUserData();
    if (userData != null) {
      if (dob == "") {
        userData.userDataData!.accountData!.dateOfBirth = "";
      } else {
        showLog('updateCustomerDOB $dob');
        userData.userDataData!.accountData!.dateOfBirth = dob;
      }
      setAppConfigUserData(userData);
      return;
    }
    return;
  }
 Future<void> updateCustomerMaritalStatus(String maritalStatus,String anniversary) async {
    showLog('updateCustomerMaritalStatus $maritalStatus , $anniversary');

    UserData? userData = await getUserData();
    if (userData != null) {
      if (maritalStatus == "") {
        userData.userDataData!.accountData!.maritalStatus = 0;
      } else {
        showLog('updateCustomerMaritalStatus $maritalStatus');
        userData.userDataData!.accountData!.maritalStatus = int.parse(maritalStatus);
        userData.userDataData!.accountData!.anniversary = (maritalStatus== '1')?anniversary:'';
      }
      await setAppConfigUserData(userData);
      return;
    }
    return;
  }

  Future updateProfileImageJvtFileConnector(
      List<JvtFileConnectors> jvtFileConnectors) async {
    UserData? _user = await getUserData();
    if (jvtFileConnectors.isNotEmpty) {
      _user!.userDataData!.accountData!.jvtFileConnectors = jvtFileConnectors;
      setAppConfigUserData(_user);
    }
  }

  Future updateCustomerPhoneNumber(String phoneNumber) async {
    TransportModel? appConfig = await getAppConfig();
    if (appConfig != null) {
      if (phoneNumber == "") {
        appConfig.userData!.userDataData!.accountData!.phoneNumber = "";
      } else {
        appConfig.userData!.userDataData!.accountData!.phoneNumber =
            phoneNumber;
      }
      setStudioData(appConfig);
    }
  }

  Future updateCustomerImageDownloadStatus(int status) async {
    TransportModel? appConfig = await getAppConfig();
    if (appConfig != null) {
      if (status == "") {
        //   appConfig.userData.data.jvtFileConnectors[0].downloadStatus =0;
      } else {
        // appConfig.userData.data.jvtFileConnectors[0].data.downloadStatus = status;
      }
      setStudioData(appConfig);
    }
  }

  Future updateCustomerEmail(String email, String code, int verify) async {
    UserData? userData = await getUserData();
    if (userData!.userDataData!.accountData!.emails!.isNotEmpty) {
      if (email == "") {
        userData.userDataData!.accountData!.emails = [
          DataEmail(address: "", token: code, verify: verify)
        ];
      } else {
        userData.userDataData!.accountData!.emails = [
          DataEmail(address: email, token: code, verify: verify)
        ];
      }
      setAppConfigUserData(userData);
    } else {
      userData.userDataData!.accountData!.emails = [
        DataEmail(verify: verify, token: code, address: email)
      ];
      await setAppConfigUserData(userData);
    }
  }

  /// ///////////////////////////////////////////////////////////////
  static String menuTextColor =
      '225c99'; //BOTTOM NAV bar,tab bar,side drawer  SELECTED COLOR
  static String secondary =
      'ffffff'; // used to appbar icon and text color,used to tab bar, bottom nav bar and icon unselected colors
  static String PrimaryColor =
      '225c99'; //only used in appbar,tab bar and bottom nav bar bg colors
  static String AccentColor = '000000'; // used  for Unselect side drawer color,
  static String primaryColor1 =
      '225c99'; // button_properties bg color ,circular progress bg
  static String MenuBackgroundColor =
      'ffffff'; //side drawer bg, bg icon color,Elevated_button_color
  static String MenuSelectedColor =
      '225c99'; // all properties selected and highlighted text colors
  var colorData = '''{
  "app_icon":{
    "background":"ffffff"
  },

	"app": {
		"background": [
			"ffffff",
			"ffffff"
		],
		"background_end": 3,
		"background_begin": 5,
		"background_stops": [
			0.1,
			0.9
		]
	},
	"app_bar": {
		"icon": "$secondary",
		"background": [
			"$PrimaryColor",
			"$PrimaryColor"
		],
		"title_text": "$secondary",
		"background_end": 5,
		"background_begin": 3,
		"background_stops": [
			0.1,
			0.9
		]
	},
	"tab_bar": {
		"background": [
			"$PrimaryColor",
			"$PrimaryColor"
		],
		"background_end": 8,
		"indicator_color": "$MenuSelectedColor",
		"background_begin": 3,
		"background_stops": [
			0.1,
			0.9
		],
		"un_selected_label": "$secondary",
		"selected_label_color": "$MenuSelectedColor"
	},
	"material": {
		"divider": "bdbdbd"
	},
	"side_drawer": {
		"clip_path": 0,
		"background": [
			"$MenuBackgroundColor",
			"$MenuBackgroundColor"

		],
		"selected_icon": "$menuTextColor",
		"selected_text": "$menuTextColor",
		"background_end": 5,
		"unselected_icon": "$AccentColor",
		"unselected_text": "$AccentColor",
		"background_begin": 3,
		"background_stops": [
			0.1,
			0.9
		]
	},
	"alert_dialog": {
		"alert_dialog_icon": "ffffff",
		"alert_dialog_title": "000000",
		"alert_dialog_content": "000000",
		"alert_dialog_background": "ffffff" 
	},
	"background_icon": {
		"background": [
			"ffffff",
			"ffffff"
		],
		"icon_color": "$primaryColor1",
		"background_end": 5,
		"background_begin": 3,
		"background_stops": [
			0.1,
			0.9
		]
	},
	"card_properties": {
		"margin": 5,
		"shadow": "000000",
		"elevation": 5,
		"background": "ffffff",
		"selected_background": "$PrimaryColor"
	},
	"icon_properties": {
		"selected": "$primaryColor1",
		"unselected": "7a7a79"
	},
	"text_form_field": {
		"date_text": "000000",
		"date_selected_text": "000000",
		"text_form_field_cursor": "000000",
		"text_form_field_margin": 5,
		"text_form_field_shadow": "000000",
		"date_heading_background": "BDBDBD",
		"date_selected_background": "BDBDBD",
		"text_form_field_elevation": 5,
		"text_form_field_hint_text": "5c5b5b",
		"text_form_field_background": "ffffff",
		"text_form_field_borderSide": "000000",
		"text_form_field_label_text": "$primaryColor1"
	},
	"text_properties": {
		"head_line_six": "173d27",
		"help_text_color": "7a7a79",
		"button_text_color": "$primaryColor1",
		"body_large_text_color": "000000",
		"body_small_text_color": "000000",
		"body_medium_text_color": "000000",
		"label_large_text_color": "000000",
		"title_large_text_color": "000000",
		"label_medium_text_color": "ff000d",
		"title_medium_text_color": "000000",
		"head_line_small_text_color": "$MenuSelectedColor"
	},
	"bottom_navigation": {
		"background": [
			"$PrimaryColor",
			"$PrimaryColor"
		],
		"selected_icon": "$MenuSelectedColor",
		"selected_text": "$MenuSelectedColor",
		"background_end": 5,
		"unselected_icon": "$secondary",
		"unselected_text": "$secondary",
		"background_begin": 6,
		"background_stops": [
			0.1,
			0.9
		]
	},
	"button_properties": {
		"shadow": "000000",
		"elevation": 5,
		"background": [
			"$primaryColor1",
			"$primaryColor1"
		],
		"text_color": "000000",
		"background_end": 8,
		"background_begin": 6,
		"background_stops": [
			0.1,
			0.9
		],
		"elevated_button_color": "$MenuBackgroundColor",
		"text_button_color": "000000",
		"out_line_button_border": "$MenuSelectedColor"
	},
	"progress_indicator": {
		"stroke_width": 4,
		"circular_color": "$MenuSelectedColor",
		"circular_background": "7a7a79"
	},
	"transitionEffects": {
			"itemTransition": 0,
			"pageTransition": 1
		},
	"highlight_text_color": {
		"label_Large_text": "000000",
		"title_medium_text": "000000",
		"head_line_small_text": "000000"
	},
	"selection_status_card": {
		"background": [
			"ffffff",
			"ffffff"
		],
		"rejected_card": "ffc0b9",
		"rejected_text": "f44336",
		"selected_card": "efffc9",
		"selected_text": "8fce00",
		"undecided_card": "ffecbc",
		"undecided_text": "fdc126",
		"background_end": 5,
		"background_begin": 6,
		"background_stops": [
			0.1,
			0.9
		]
	}
}''';
}

/// model class
UserData userModelFromJson(str) => UserData.fromJson(json.decode(str));

String companyDetailsModelToJson(UserData data) => json.encode(data.toJson());
