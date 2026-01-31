import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart' as appConfig;

class AddressUtils{
  static String getAddress(appConfig.Address address) {
    String separator = ", ";
    String separator2 = " - ";
    String state = "${address.state == null ? "" : address.state!+separator}";
    String district = "${address.district == null ? "" :address.district!+separator2}";
    String street = "${address.street == null ? "" : address.street!+separator}";
    String locality = "${address.locality== null ? "" :address.locality!+separator}";
    String pinCode = "${address.pincode== null ? "" :address.pincode!+separator}";
    String country = "${address.country ?? ""}";
    return "${street}${locality}${district}${pinCode}${state}${country}";
  }  static String getAddressForInfo(appConfig.Address address,int index) {
    String separator = ", ";
    String separator2 = " - ";
    String state = "${address.state == null ? "" : address.state!+separator}";
    String district = "${address.district == null ? "" :address.district!+separator2}";
    String street = "${address.street == null ? "" : address.street!+separator}";
    String locality = "${address.locality== null ? "" :address.locality!+separator}";
    String pinCode = "${address.pincode== null ? "" :address.pincode!+separator}";
    String country = "${address.country ?? ""}";
    List<String>infoAddress =[
      "${street}",
      "${locality}${district}${pinCode}",
      "${state}${country}"
    ];
    return infoAddress[index];
  }
}