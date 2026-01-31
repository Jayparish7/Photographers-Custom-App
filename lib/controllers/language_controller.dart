import 'package:photomall_flutter/core/models/apiModels/transport_model/design_properties_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/controllers/profile_controller.dart';

//List<StudioLanguage>? languages;

class AppLanguage {
  appConf.DesignData? apiLanguages;

  Future<appConf.DesignData?> getLanguages() async {
    var appConfig = TransporterPreference();
  //  languages = await appConfig.getLanguages();
    return apiLanguages;
  }
}

var languageJson = [
  {
    "code": "",
    "name": "English",
    "first_letter": "A",
    "symbol": "en",
    "font": null,
    "last_updated_at": 1689679571
  },
  {
    "code": "",
    "name": "Tamil",
    "first_letter": "அ",
    "symbol": "ta",
    "font": null,
    "last_updated_at": 1689679569
  },
  {
    "code": "",
    "name": "Hindi",
    "first_letter": "अ",
    "symbol": "hi",
    "font": null,
    "last_updated_at": 1689679639
  },
  {
    "code": "",
    "name": "Telugu",
    "first_letter": "అ",
    "symbol": "te",
    "font": null,
    "last_updated_at": 1693050420
  },
  {
    "code": "",
    "name": "Malayalam",
    "first_letter": "ക",
    "symbol": "ml",
    "font": null,
    "last_updated_at": 1693050423
  },
  {
    "code": "",
    "name": "Kannada",
    "first_letter": "ಅ",
    "symbol": "kn",
    "font": null,
    "last_updated_at": 1689679633
  },
  {
    "code": "",
    "name": "Bengali",
    "first_letter": "ক",
    "symbol": "bn",
    "font": null,
    "last_updated_at": 1673680187
  },
  {
    "code": "",
    "name": "French",
    "first_letter": "Â",
    "symbol": "fr",
    "font": null,
    "last_updated_at": 1673680187
  },
  {
    "code": "",
    "name": "Gujarati",
    "first_letter": "અ",
    "symbol": "gu",
    "font": null,
    "last_updated_at": 1673680187
  },
  {
    "code": "",
    "name": "Marathi",
    "first_letter": "अ",
    "symbol": "mr",
    "font": null,
    "last_updated_at": 1673680187
  },
  {
    "code": "",
    "name": "Malay",
    "first_letter": "M",
    "symbol": "ms",
    "font": null,
    "last_updated_at": 1719466784
  }
];

// Convert JSON to List<StudioLanguage>
//List<StudioLanguage>? studioLanguages =
   // languageJson.map((json) => StudioLanguage.fromJson(json)).toList();
