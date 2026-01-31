import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class TutorialOverlay extends ModalRoute<void> {
  final dynamic downloadedImageFile;

  TutorialOverlay(this.downloadedImageFile);

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _setSizedBox(context),
          _setCancel(context),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  _setSizedBox(BuildContext context) {
    return (downloadedImageFile == 1)
    ?  SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PhotoView(
        imageProvider:
            AssetImage("assets/images/user_profile.png"),

      ) ) :
        SizedBox(
        height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: PhotoView(
    imageProvider:
    FileImage(downloadedImageFile),
    ),
    );
  }

  Widget _setCancel(BuildContext context) {
    return Positioned(
      right: 5,
      top: 5,
      child: InkWell(
        onTap: () => Navigator.pop(context),

        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.cancel,

            size: 30,
          ),
        ),
      ),
    );
  }
}

/*class TestPage extends StatelessWidget {
  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(TutorialOverlay());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: InkWell(
            onTap: () => _showOverlay(context),
            child: PhotoView(
              imageProvider: AssetImage('assets/images/1.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}*/
