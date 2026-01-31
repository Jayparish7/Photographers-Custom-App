import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';


class CurveLiner extends CustomPainter {

  BuildContext? context;

  CurveLiner({this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = AppColorData.bgIconColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
    //canvas.drawColor(Color(0), BlendMode.clear);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}






class FocusTopLeft extends CustomPainter {

  BuildContext? context;

  FocusTopLeft({this.context});

  @override
  void paint(Canvas canvas, Size size) {

    /*final p1 = Offset(20, 0);
    final p2 = Offset(20, 20);
    final p3 = Offset(40, 0);*/
    final p1 = Offset(0, 0);
    final p2 = Offset(0, 20);
    final p3 = Offset(20, 0);
    final paint = Paint()
      ..color = AppColorData.bgIconColor
      ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p1, p3, paint);
    /*final pointMode = .PointMode.;
    final points = [
      Offset(50, 100),
      Offset(150, 75),
      Offset(250, 250),
      Offset(130, 200),
      Offset(270, 100),
    ];
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.points, points, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class FocusTopRight extends CustomPainter {

  BuildContext? context;

  FocusTopRight({this.context});

  @override
  void paint(Canvas canvas, Size size) {

    /*final p1 = Offset(0, 0);
    final p2 = Offset(0, 20);
    final p3 = Offset(-20, 0);*/
    final p1 = Offset(40, 0);
    final p2 = Offset(40, 20);
    final p3 = Offset(20, 0);
    final paint = Paint()
      ..color = AppColorData.bgIconColor
      ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p1, p3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class FocusBottomLeft extends CustomPainter {

  BuildContext? context;

  FocusBottomLeft({this.context});

  @override
  void paint(Canvas canvas, Size size) {

    /*final p1 = Offset(0, 0);
    final p2 = Offset(0, 20);
    final p3 = Offset(20, 20);*/
    final p1 = Offset(0, 20);
    final p2 = Offset(0, 40);
    final p3 = Offset(20, 40);
    final paint = Paint()
      ..color = AppColorData.bgIconColor
      ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FocusBottomRight extends CustomPainter {

  BuildContext? context;

  FocusBottomRight({this.context});

  @override
  void paint(Canvas canvas, Size size) {

    /*final p1 = Offset(40, 0);
    final p2 = Offset(40, 20);
    final p3 = Offset(20, 20);*/
    final p1 = Offset(40, 20);
    final p2 = Offset(40, 40);
    final p3 = Offset(20, 40);
    final paint = Paint()
      ..color = AppColorData.bgIconColor
      ..strokeWidth = 3;
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


