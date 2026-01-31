import 'dart:convert';

import 'package:photomall_flutter/core/Utils/preference_helper.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/preference/preference_model/booking_model.dart';

class BookingHandler {
  Future<void> setBookingDetails(BookingDetail bookingData) async {
    return await PreferenceHelper.setString(
        bookingDetailsConstant, jsonEncode(bookingData.toJson()));
  }

  /// Get Design Data From Preference
  Future<BookingDetail?> getBookingDetails() async {
    String bookingDataObject =
        await PreferenceHelper.getString(bookingDetailsConstant);
    if (bookingDataObject.isEmpty) {
      return null;
    }
    showLog('designData $bookingDataObject');
    Map<String, dynamic> jsonMap =
        jsonDecode(bookingDataObject) as Map<String, dynamic>;
    return BookingDetail.fromJson(jsonMap);
  }
}
