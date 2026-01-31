import 'package:flutter/material.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';

class CountryAndContactApi {
  BuildContext? context;

  PhotomallApis? apiRepo;

  CountryAndContactApi(this.context) {
    apiRepo = PhotomallApis(this.context);
  }
}
