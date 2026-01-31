import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/after_login_book_me_model.dart';
import 'package:photomall_flutter/core/models/apiModels/before_login_book_me_model.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConf;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/packages_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class BookMeRouteModel extends BaseObserver {
  ApiHelper? apiHandler;
  BuildContext? context;

  List<appDb.StudioPackageData> eventPackageList = [];
  List<appConf.EventCategory> eventCategories = [];

  int? clientId = 0;
  String? otpSignature = "";
  List<Country> countriesList = [];
  List<String> countries = [];
  List<String> phoneNumber = [];
  List<DropdownMenuItem> countriesDropDown = [];
  String selectedCountry = "India";
  var countryCodeId = 108;
  PhotomallApis? apiRepo;

  var lastUpdatedAt;

  final ValueNotifier<String?> whatsappNumber = ValueNotifier<String?>('');

  BookMeRouteModel({this.apiHandler, this.context}) {
    this.apiRepo = PhotomallApis(this.context);
  }

  Future<bool> getPhoneNumbers() async {
    ///Get Phone Numbers Details from phone_numbers table

    phoneNumber.clear();

    setBusy(false);
    return (phoneNumber.length > 0);
  }

  getEventTypes() async {
    PackagesModelDao packagesModelDao = PackagesModelDao();
    setBusy(true);
    //   getDataFromDb();
    // get event types from preference
    var appConfig = TransporterPreference();
    appConf.TransportModel? studioDetails = await appConfig.getAppConfig();
    if (studioDetails != null &&
        studioDetails.studioData != null &&
        studioDetails.studioData?.data != null) {
      eventCategories = studioDetails.studioData!.data!.eventCategories!;
      whatsappNumber.value = studioDetails.studioData?.data?.whatsapp;
    }

    eventPackageList = await packagesModelDao.getPackages();

    setBusy(false);
  }

  Future<void> _getCountriesList() async {
    /* _countryCodeApiCall().then((response) {
      countriesList.clear();
      countries.clear();
      for (int i = 0; i < response.data.countries.length; i++) {
        showLog(response.data.countries[i].country);
        countriesList.add(Country(
            id: response.data.countries[i].id,
            country: response.data.countries[i].country,
            countryCode: response.data.countries[i].countryCode));
        countries.add(response.data.countries[i].country);
      }
    });*/
    /* try {
    CountryCodeModel response = await apiRepo.countryCodeApiCall();
    _parseCountryCode(response);
    } on OfflineException catch (e) {
      isNetworkFailed = true;
      startNetworkCheck();
      setBusy(false);
    } catch (e) {
      setBusy(false);
    }*/
  }

  @override
  void onInternetConnectionBack() async {
    await _getCountriesList();
    // await _getEventTypes();
  }

  Future<AfterLoginBookMeModel?> afterLoginBookMeApiCall(
      String eventTypeCategoryId,
      String eventDate,
      String remarks,
      String? package) async {
    AfterLoginBookMeModel? response;
    try {
      setBusy(true);
      response = await apiRepo!.afterLoginBookMeApiCall(
          eventTypeCategoryId, eventDate, remarks, package);

      setBusy(false);
    } on OfflineException catch (e) {
      showLog('book_me_rout_model->${e.toString()}');

      setBusy(false);
      ToastUtil.showInternetRequired(context!);
    } catch (e) {
      setBusy(false);
      showLog('book_me_rout_model->${e.toString()}');
    }
    return response;
  }

  Future<BeforeLoginBookMeModel?> beforeLoginBookMeApiCall(
      String name,
      String mobileNumber,
      String countryCode,
      String otpSignature,
      String clientId,
      String emailId,
      String eventTypeCategoryId,
      String eventDate) async {
    BeforeLoginBookMeModel? response;
    try {
      setBusy(true);
      response = await apiRepo!.beforeLoginBookMeApiCall(
          name,
          mobileNumber,
          countryCode,
          otpSignature,
          clientId,
          emailId,
          eventTypeCategoryId,
          eventDate);
      setBusy(false);
    } on OfflineException catch (e) {
      showLog('book_me_rout_model->${e.toString()}');

      setBusy(false);
      ToastUtil.showInternetRequired(context!);
    } catch (e) {
      setBusy(false);
    }
    return response;
  }

  Future<void> getDataFromDb() async {
    var pref = await SharedPreferences.getInstance();
    bool loggedIn = await pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
    if (loggedIn) {
      LoginController loginController = LoginController();
      loginController.setUpLoginData();
    }
  }

  launchWhatsapp(BuildContext context) async {
    final link = WhatsAppUnilink(
      phoneNumber: whatsappNumber.value,
      text: S.of(context).helloIAmCurrentlyUsingYourMobileAppAndWould,
    );
    await launchUrl(Uri.parse(link.toString()));
  }
}

class Country {
  int? id;
  String? country;
  String? countryCode;
  String? countryShortCode;

  Country({
    this.id,
    this.country,
    this.countryCode,
    this.countryShortCode,
  });
}
