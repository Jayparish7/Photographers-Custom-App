import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/ui/contactus/contact_us_data_view.dart';

class ContactUsRoute extends StatefulWidget {
  final bool isFromBookingRoute;
  final ContactUs? arguments;

  const ContactUsRoute(
      {Key? key, this.isFromBookingRoute = false, this.arguments})
      : super(key: key);

  @override
  State<ContactUsRoute> createState() => _ContactUsRouteState();
}

class _ContactUsRouteState extends State<ContactUsRoute> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors,
              stops: AppColorData.appBackgroundStops)),
      child: Scaffold(
        //appBar: CommonAppBar(title: S.of(context).contactUs),
        backgroundColor: Colors.transparent,

        body: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: <Widget>[
                _setContactUsCardView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setContactUsCardView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            ContactUsDataView(studioCode: widget.arguments?.studioCode),
          ],
        ),
      ),
    );
  }
}
