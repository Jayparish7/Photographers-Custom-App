import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ken_burns_slideshow/ken_burns_slideshow.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/ui/gallery/gallery_route_view_model.dart';
import '../../controllers/album_controller.dart';
import 'cached_network_image_widget.dart';

class CarouselWidget extends StatefulWidget {
  final List<CarouselViewModel> carouselList;
  final double aspectRatio;
  final int initialPage;

  const CarouselWidget({
    Key? key,
    required this.carouselList,
    required this.aspectRatio,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<String>? images = [];
  bool isLandScape = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    showLog("message >> ccc${widget.aspectRatio}");
    addImagesForCarousel(widget.carouselList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.carouselList.isNotEmpty && widget.carouselList.isNotEmpty) {
      showLog('isLandScape $isLandScape');
      return Column(
          // alignment: Alignment.topCenter,
          children: [
            SizedBox(
                height: MediaQuery.sizeOf(context).height * .35,
                child: AutoScrollCarousel(
                  images: images!,
                )),
          ]);
    } else {
      return SizedBox();
    }
  }

  addImagesForCarousel(List<CarouselViewModel> carouselList) async {
    for (int i = 0; i < carouselList.length; i++) {
      images!.add(carouselList[i].network!);
    }
    showLog('addImagesForCarousel $images');
  }
}

class CarouselWidgetForEvent extends StatefulWidget {
  final List<String> carouselListForEvent;
  final double aspectRatio;
  final int initialPage;

  const CarouselWidgetForEvent({
    Key? key,
    required this.carouselListForEvent,
    required this.aspectRatio,
    required this.initialPage,
  }) : super(key: key);

  @override
  State<CarouselWidgetForEvent> createState() => _CarouselWidgetForEventState();
}

class _CarouselWidgetForEventState extends State<CarouselWidgetForEvent> {
  final ValueNotifier<double> currentIndexPage = ValueNotifier<double>(0);
  List<String>? images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLog("message >> ${widget.aspectRatio}");
    // addImagesForCarousel(widget.carouselListForEvent);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.carouselListForEvent.isNotEmpty) {
      return Column(
          // alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .50,
              child: KenBurnsSlideshow.network(
                  animationSequence: [
                    KenBurnsAnimation(
                      scaleBegin: 1,
                      scaleEnd: 1.3,
                      translateXBegin: 0,
                      translateXEnd: 0.15,
                    )
                  ],
                  background: Colors.transparent,
                  foreground: Colors.transparent,
                  images: widget.carouselListForEvent),
            ),
          ]);
    } else {
      return SizedBox();
    }
  }

  addImagesForCarousel(List<ImagesViewModel> carouselList) async {
    for (int i = 0; i < carouselList.length; i++) {
      images!.add(carouselList[i].url!);
    }
    showLog('addImagesForCarousel $images');
    setState(() {});
  }
}

class AutoScrollCarousel extends StatefulWidget {
  final List<String> images;

  const AutoScrollCarousel({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  _AutoScrollCarouselState createState() => _AutoScrollCarouselState();
}

class _AutoScrollCarouselState extends State<AutoScrollCarousel> {
  final CarouselController carouselController =
      CarouselController(initialItem: 1);
  Timer? _timer;
  Timer? _resumeScrollTimer;
  int _currentIndex = 0;
  double itemWidth = 0;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  @override
  void dispose() {
    stopAutoScroll();
    carouselController.dispose();
    _timer?.cancel();
    _resumeScrollTimer?.cancel();
    super.dispose();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isUserScrolling) {
        if (_currentIndex < widget.images.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0; // Loop back to the first item
        }

        // Calculate the offset for the current index
        double offset = _currentIndex * itemWidth;

        // Animate to the new offset
        carouselController.animateTo(
          offset,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
    _resumeScrollTimer?.cancel();
  }

  void onUserScroll() {
    // Cancel any pending resume timer
    _resumeScrollTimer?.cancel();

    // Set flag to indicate user is scrolling
    setState(() {
      _isUserScrolling = true;
    });

    // Restart auto-scroll after a delay (e.g., 5 seconds)
    _resumeScrollTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        _isUserScrolling = false;
      });
    });
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    showLog("onHorizontalDragStart");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        itemWidth = constraints.maxWidth / 1;
        return CarouselView(
          enableSplash: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //consumeMaxWeight: true,
          onTap: (value) {
            onUserScroll(); // User started scrolling
          },
          key: UniqueKey(),
          controller: carouselController,
          //flexWeights: [1, 8, 1],
          itemExtent: double.infinity,
          itemSnapping: true,
          children: widget.images
              .map((e) => GestureDetector(
                    onHorizontalDragStart: _onHorizontalDragStart,
                    child:CustomCachedNetworkImageWidget(
                      url :e,fitSize: BoxFit.cover,
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
