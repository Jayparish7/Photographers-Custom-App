import 'dart:math';

import 'package:flutter/material.dart';

class CustomFlipper extends StatefulWidget {
  const CustomFlipper({Key? key}) : super(key: key);

  @override
  State<CustomFlipper> createState() => _CustomFlipperState();
}

class _CustomFlipperState extends State<CustomFlipper> {
  bool _showFrontSide = true;
  @override
  void initState() {
    Future.delayed( Duration(milliseconds: 2000), () {
      setState(() {
        _showFrontSide = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return __transitionBuilder(
      AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        child: _showFrontSide
            ? Card(color: Colors.blue,child: SizedBox(height:200,width: 200,),)
            : Card(color:Colors.red,child: SizedBox(height:200,width: 200,),),
      ),AlwaysStoppedAnimation<double>(200)
    );
  }
  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        return Transform(
          transform: Matrix4.rotationY(200),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }
}
