import 'package:flutter/material.dart';

class BlinkingWidget extends StatefulWidget {
  final Color? color;

  final Widget? child;

  BlinkingWidget({Key? key, this.color, required this.child}) : super(key: key);

  @override
  _BlinkingWidgetState createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    _animationController!.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: _animationController!,
        child: Container(
          color: widget.color ?? Colors.transparent,
          child: widget.child,
        ));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
