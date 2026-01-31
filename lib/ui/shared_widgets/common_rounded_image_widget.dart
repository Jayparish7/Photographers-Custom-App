import 'package:flutter/material.dart';

class CommonRoundedImageWidget extends StatelessWidget {
  final String image;
  final Size size;

  const CommonRoundedImageWidget({super.key, required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(image),
                alignment: FractionalOffset.center,
                fit: BoxFit.cover)),
      ),
    );
  }
}
