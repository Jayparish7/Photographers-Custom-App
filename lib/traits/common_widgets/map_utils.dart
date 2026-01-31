import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:slugify_string/slugify_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporter;

class MapUtils {
  Future<void> openMapByAddress({required transporter.Address address}) async {
    String query;
    if (address.latitude != null && address.latitude != null) {
      showLog('the lat log given where ${address.latitude} //  ${address.longitude}');
      query = '${address.latitude},${address.longitude}';
      showLog('the lat log converted where $query');
    } else {
      query = generateAddress(address);
    }
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$query';
    showLog("the launching url where \n$googleUrl");
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=centurylink+field';
    if (await launchUrl(Uri.parse(googleUrl)) != '') {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  String generateAddress(transporter.Address address) {
    String space = " ";
    String locality =
        "${address.locality == null ? "" : (address.locality)! + space}";
    String street = "${address.street == null ? "" : (address.street)! + space}";
    String district =
        "${address.district == null ? "" : (address.district)! + space}";
    String pinCode =
        "${address.pincode == null ? "" : (address.pincode)! + space}";
    String state = "${address.state == null ? "" : (address.state)! + space}";
    // String country = "${address.country ?? ""}";
    return Slugify(
        '${'$locality $street $district $pinCode $state'.replaceAll(RegExp("\\p{P}", unicode: true), "")}',
        //'${'${locality}${street}${district}${pinCode}${state}'.replaceAll(RegExp(r"\p{P}", unicode: true), "")}',
        lowercase: false,
        delimiter: '+');
  }
/*   Future<void> openMapByLatLong(
      String latitude, String longitude, BuildContext context) async {
    Uri googleUrl =
    Uri.parse ('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      ToastUtil.showSnackBarAtCurrentState(S.of(context).mapNotOpening,seconds: 2);
     *//* ToastUtil toastUtil = ToastUtil();
      toastUtil.showShortToast(context, 'Map not opening');*//*
      //throw 'Could not open the map.';
    }
  }*/
}
