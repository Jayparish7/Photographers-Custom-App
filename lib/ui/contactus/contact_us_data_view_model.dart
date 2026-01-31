import 'package:flutter/widgets.dart';
import 'package:photomall_flutter/controllers/PhotomallController/photomall_studio_data_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/utils/storage_utils.dart';
import 'package:photomall_flutter/ui/base/base_model.dart';


class ContactUsDataViewModel extends BaseModel {
  var documentDirectory;
  String? publicStoragePath;
  String? privateStoragePath;
  ApiHelper? apiHandler;
  BuildContext? context;

  /* String address = "";
  String phoneNumber = "";
  List<EmailElement> emailId = [];
  String websiteUrl = "";*/
  ContactUsDataViewModel({this.apiHandler, this.context});

  String? studioName = "";
  List<String> phoneNumber = [];

  List<String> email = [];

  var facebookUrl = ""; // type 1
  var twitterUrl = ""; // type 2
  var instagramUrl = ""; // type 4
  var youtubeUrl = ""; // type 5
  var linkedIn = ""; // type 6
  String? whatsappNumber= "";
  var googlePlusUrl = "";
  String studioLogo = "";

  /// new
  List<appConf.ContactPoint>? contactPoints;

  List<appConf.SocialProfile>? socialProfile = [];

  var website;

  getContactUsDetails({String? studioCode}) async {
    getStoragePaths();
    var appConfig = TransporterPreference();

    showLog("inside ContactUsDataViewModel");
    if (isPhotomallApp) {
      StudioDataGetModel? studioDataGetModel =
          await getStudioDetails(studioCode!);
      studioLogo = studioDataGetModel?.image ?? "";
      if (studioDataGetModel != null &&
          studioDataGetModel.studioData != null &&
          studioDataGetModel.studioData!.data != null) {
        if (studioDataGetModel.studioData!.data!.socialProfiles != null &&
            studioDataGetModel.studioData!.data!.socialProfiles!.isNotEmpty) {
          socialProfile = studioDataGetModel.studioData!.data!.socialProfiles;
        }
        if (studioDataGetModel.studioData!.data!.contactPoints != null &&
            studioDataGetModel.studioData!.data!.contactPoints!.isNotEmpty) {
          contactPoints = studioDataGetModel.studioData!.data!.contactPoints;
        }
        if (studioDataGetModel.studioData!.data!.website != null &&
            studioDataGetModel.studioData!.data!.website!.isNotEmpty) {
          website = studioDataGetModel.studioData!.data!.website;
        }
        studioName = studioDataGetModel.studioData!.data!.name;
      }
    } else {
      appConf.TransportModel? studioDetails = await appConfig.getAppConfig();
      socialProfile = studioDetails?.studioData?.data?.socialProfiles;
      contactPoints = studioDetails?.studioData?.data?.contactPoints;
      studioName = studioDetails?.studioData?.data?.name;
      website = "${studioDetails?.studioData?.data?.website}";


      whatsappNumber= studioDetails?.studioData?.data?.whatsapp;
    }

    contactPoints?.forEach((element) {
      showLog("contactPoints${element.name}");
      element.emails?.forEach((element1) {
        showLog("email ${element1.address}");
      });
    });

    /// new
    for (int i = 0; i < socialProfile!.length; i++) {
      if (socialProfile?[i].type == 1) {
        facebookUrl =
            '${socialProfile?[i].baseUrl}${socialProfile?[i].url}'; // type 1
      }
      if (socialProfile?[i].type == 2) {
        twitterUrl =
            '${socialProfile?[i].baseUrl}${socialProfile?[i].url}'; // type 2
      }
      if (socialProfile?[i].type == 4) {
        instagramUrl =
            '${socialProfile?[i].baseUrl}${socialProfile?[i].url}'; // type 4
      }
      if (socialProfile?[i].type == 5) {
        youtubeUrl =
            '${socialProfile?[i].baseUrl}${socialProfile?[i].url}'; // type 5
      }
      if (socialProfile?[i].type == 6) {
        linkedIn =
            '${socialProfile?[i].baseUrl}${socialProfile?[i].url}'; // type 6
      }
      if(socialProfile?[i].type== 100){
        website = socialProfile?[i].url;
        showLog('WEBSITE IS $website');
        
      }
    }

    /* var lastUpdatedAt;
    lastUpdatedAt = await dbHelper.getLastUpdatedAt(contactUsUrl);

    //check
    //lastUpdatedAt = 0;

    showLog("Last Updated At -> $lastUpdatedAt");
    if (lastUpdatedAt != 0) {
      await showContactDetail();
    }
    await CountryAndContactApi(context).callCountryAndContactUsApi(
        context, false); //status => false, no call country code api
    await showContactDetail();*/

    setBusy(false);
  }

  bool hasValue(String value) {
    return ( value.toString().isNotEmpty);
  }

  //previous working method

  Future<void> getStoragePaths() async {
    if (studioPublicPath != null &&
        appDocumentDirectoryPath != null &&
        studioPrivatePath != null) {
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    } else {
      EssentialUtils essentialUtils = EssentialUtils();
      essentialUtils.loadAppEssentialData();
      publicStoragePath = studioPublicPath;
      documentDirectory = appDocumentDirectoryPath;
      privateStoragePath = studioPrivatePath;
    }
  }

  Future<StudioDataGetModel?> getStudioDetails(String _studioCode) async {
    PhotomallStudioDataController photomallStudioDataController =
        PhotomallStudioDataController();
    StudioDataGetModel? studioDataGetModel =
        await photomallStudioDataController.getStudioRow(_studioCode);
    showLog("the studio data1 ${studioDataGetModel?.studioName}");
    return studioDataGetModel;
  }

//previous working method
}
