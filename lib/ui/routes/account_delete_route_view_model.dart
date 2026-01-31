import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import '../../api/repository/photomall_apis.dart';
import '../../core/constants/common_constants.dart';
import '../../core/services/api_helper.dart';
import '../base/base_observer.dart';

class DeleteRouteViewModel extends BaseObserver {
  DeleteRouteViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  @override
  void onInternetConnectionBack() async {
    showLog('event_list_route :: onInternetConnectionBack :: called');
  }

  @override
  BuildContext? context;
  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  bool isLoading = false;

  String? daysCount;

  getInitialData() {
    setBusy(true);

    setBusy(false);
  }

  accountDeletionApiCall() async {
    String encodedMap = await PreferenceHelper.getString(isDeletedDataKey);
    Map<String, dynamic> decodedMap = json.decode(encodedMap);

    var response =
        await PhotomallApis(context).deletionApi(code: decodedMap.keys.first);

    showLog('accountDeletionApiCall${response?.status}');
  }

  accountDeletionStoreApiCall() async {
    setBusy(true);
    //isLoading = true;
    var response = await PhotomallApis(context).deletionStoreApi();
    //isLoading = false;

    showLog('accountDeletionStoreApiCall${response?.data.code}');
    setBusy(false);
  }

  accountDeletionData() async {
    String encodedMap = await PreferenceHelper.getString(isDeletedDataKey);
    Map<String, dynamic> decodedMap = json.decode(encodedMap);
    daysCount = decodedMap.values.first;
  }
}
