import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';


class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T model;
  final Widget? child;
  final Function(T) onModelReady;

  BaseWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    required this.onModelReady,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T? model;

  @override
  void initState() {
    model = widget.model;

    widget.onModelReady(model!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return ChangeNotifierProvider<T>(
    //create: (context) => model,
    return ChangeNotifierProvider<T>.value(
      value: model!,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
