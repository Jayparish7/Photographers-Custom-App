import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PhotomallProgress extends StatelessWidget {

  const PhotomallProgress({Key? key, this.value}) : super(key: key);
  final double? value;
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/splash_logo.png',)
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: const Color(0xFFfec832))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad));
  }
}