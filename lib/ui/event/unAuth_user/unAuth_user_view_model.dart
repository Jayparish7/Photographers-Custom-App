import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';

import '../../../controllers/login_controller.dart';
import '../../../core/Utils/toast_util.dart';
import '../../../core/constants/shared_preference_constants.dart';
import '../../../core/models/apiModels/un_auth_user_store_api_response_model.dart';
import '../../../media/my_photos_route.dart';
import '../../base/base_observer.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as country;

class UnAuthUserViewModel extends BaseObserver {
  final BuildContext context;

  UnAuthUserViewModel(this.context);

  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  PhotomallApis api = PhotomallApis(null);
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final FocusNode mobileFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode designFocus = FocusNode();
  final ValueNotifier<country.Country> dropDownValue = ValueNotifier<
          country.Country>(
      country.Country(id: 108, shortCode: "IN", name: "india", code: "+91"));
  LoginController loginController = LoginController();
  bool isLoading = false;
  int isCorporateEvent = 1;

  getInitialValues(String eventCode) async {
    isCorporateEvent =
        await PreferenceHelper.getValueForKey(eventCode, corporateEventKey);
    showLog("getInitialValues _$isCorporateEvent");
    notifyListeners();
  }

  getUnAuthUserCode(String eventCode) async {
    isLoading = true;
    notifyListeners();

    try {
      UnAuthUserStoreApiResponseModel? response =
          await api.unAuthUserEventsStoreApi(
              eventCode: eventCode,
              phoneNumber:
                  mobileController.text != "" ? mobileController.text : "",
              email: emailController.text,
              name: nameController.text,
              designation: designationController.text,
              countryId: dropDownValue.value.id.toString());
      if (response != null &&
          response.unauthUser != null &&
          response.unauthUser?.code != null) {
        showLog("response :");
        Map<String, dynamic> map = {eventCode: response.unauthUser?.code};
        await PreferenceHelper.saveMapToPrefs(map, unAuthUserKey);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyPhotosRoute(
                      eventCode: eventCode,
                      appBarTitle: "My Photos",
                      personCode: response.unauthUser?.code ?? "",
                      isFromUnAuth: true,
                    ),
                //myPhotosGrid(myPhotos),
                maintainState: false));
      } else {
        await ToastUtil.showSnackBarAtCurrentState("Failed!.Please try again");
      }
    } catch (e) {
      showLog("exception in getUnAuthUserCode $e");
      await ToastUtil.showSnackBarAtCurrentState("Failed!.Please try again");
    }
    isLoading = false;
    notifyListeners();
  }
}
