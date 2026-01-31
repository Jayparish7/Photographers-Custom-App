import 'package:flutter/material.dart';

class CustomProgressionWidget extends StatefulWidget {
  final Widget childWidget;

  CustomProgressionWidget({Key? key, required this.childWidget})
      : super(key: key);

  @override
  State<CustomProgressionWidget> createState() =>
      _CustomProgressionWidgetState();
}

class _CustomProgressionWidgetState extends State<CustomProgressionWidget> {
  bool showSecondChild = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    delayMethod();
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 800),
      firstChild: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(),
        ),
      ),
      secondChild: widget.childWidget,
      crossFadeState: !showSecondChild
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }

  void delayMethod() {
    Future.delayed(Duration(milliseconds: 0), () {
      showSecondChild = true;
      setState(() {});
    });
  }
}
