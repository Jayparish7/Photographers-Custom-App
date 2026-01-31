import 'package:flutter/material.dart';
class BackGroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    var roundnessFactor = 50.0;
    var path = Path();
    path.moveTo(0, size.height * 0.33);
    path.lineTo(0, size.height - roundnessFactor);
    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - roundnessFactor,size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - roundnessFactor);

    path.lineTo(size.width , roundnessFactor * 2);

    path.quadraticBezierTo(
        size.width,0 ,size.width - roundnessFactor * 3,roundnessFactor * 2
    );
    path.lineTo(roundnessFactor * 0.6,size.height*0.33+ 30,);
    path.quadraticBezierTo(
        0 ,size.height * 0.33 + roundnessFactor ,0,size.height*0.33 +roundnessFactor * 2
    );
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
