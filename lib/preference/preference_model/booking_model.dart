// To parse this JSON data, do
//
//     final bookingDetail = bookingDetailFromJson(jsonString);

import 'dart:convert';

BookingDetail bookingDetailFromJson(String str) =>
    BookingDetail.fromJson(json.decode(str));

String bookingDetailToJson(BookingDetail data) => json.encode(data.toJson());

class BookingDetail {
  BookingDetail({
    this.bookingDetail,
  });

  BookingDetailClass? bookingDetail;

  factory BookingDetail.fromJson(Map<String, dynamic> json) => BookingDetail(
        bookingDetail: json["booking_detail"] == null
            ? null
            : BookingDetailClass.fromJson(json["booking_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "booking_detail":
            bookingDetail == null ? null : bookingDetail!.toJson(),
      };
}

class BookingDetailClass {
  BookingDetailClass(
      {this.eventTypesCategoriesCode,
      this.date,
      this.remarks,
      this.packageCode});

  String? eventTypesCategoriesCode;
  String? date;
  String? remarks;
  String? packageCode;

  factory BookingDetailClass.fromJson(Map<String, dynamic> json) =>
      BookingDetailClass(
        eventTypesCategoriesCode: json["eventTypesCategoriesCode"] == null
            ? null
            : json["eventTypesCategoriesCode"],
        date: json["date"] == null ? null : json["date"],
        remarks: json["remarks"] == null ? null : json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "eventTypesCategoriesCode":
            eventTypesCategoriesCode == null ? null : eventTypesCategoriesCode,
        "date": date == null ? null : date,
        "remarks": remarks == null ? null : remarks,
      };
}
