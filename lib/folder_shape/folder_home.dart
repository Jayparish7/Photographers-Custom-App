import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'gradient_shadow.dart';

class FolderHomeWidget extends StatefulWidget {
  final String title;
  final Curve curve;
  final Function onTap;

  const FolderHomeWidget({
    Key? key,
    required this.title,
    required this.curve,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FolderHomeWidget> createState() => _FolderHomeWidgetState();
}

class _FolderHomeWidgetState extends State<FolderHomeWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _shadowAnimationController;
  late Animation<double> _shadowAnimation;

  final Duration animationDuration = Duration(milliseconds: 800);
  final Duration shadowAnimationDuration = Duration(milliseconds: 600);
  final double height = 80;
  final double width = 100;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    // Shadow animation controller
    _shadowAnimationController = AnimationController(
      vsync: this,
      duration: shadowAnimationDuration,
    );

    // Main animation tween
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    );

    // Shadow animation tween
    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shadowAnimationController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shadowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [

          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _animation,
                _shadowAnimation,
              ]),
              builder: (context, child) {
                return GestureDetector(
                  onTap: () async {
                    showLog("Widget tapped! isOpen: $isOpen");

                    if (isOpen) {
                      _animationController.reverse().orCancel;
                      _shadowAnimationController.reverse().orCancel;
                    } else {
                      _animationController.forward().orCancel;
                      await Future.delayed(Duration(milliseconds: 700));
                      _shadowAnimationController.forward().orCancel;

                      try {
                        await widget.onTap();
                      } catch (e) {
                        showLog("Error during onTap: $e");
                      }
                    }

                    isOpen = !isOpen;
                  },
                  child: buildAnimatedFolderStack(),
                );
              },
            ),
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
  double bottom = 10;
  // Helper method for the animated folder stack
  Stack buildAnimatedFolderStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: bottom,
          child: Image.asset(
            color: Color(0xFFEFB054),

            'assets/images/folder_backcover.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: bottom,
          child: CustomPaint(
            size: Size(width, height),
            painter: FolderBackCoverGradientPainter(_shadowAnimation),
          ),
        ),
        Positioned(
          bottom: bottom,
          child: getFolderFrontCover(),
        ),
      ],
    );
  }

  Transform getFolderFrontCover() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.003)
        ..rotateX(1.3 * _animation.value),
      alignment: FractionalOffset.bottomCenter,
      child: SizedBox(
        width: width,
        height: 65,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              color: Color(0xFFFFD554).withOpacity(.9),

              'assets/images/folder_frontcover.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
            Positioned.fill(child:  Icon(
              CupertinoIcons.photo_on_rectangle,
              size: 22,
              color: Colors.white,
            ),)
            /*ClipPath(
              clipper: LightningClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ReflectionWidget(_animation, _shadowAnimation),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
