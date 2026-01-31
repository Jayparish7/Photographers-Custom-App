import 'package:audioplayers/audioplayers.dart';
import 'package:bookfx/bookfx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../controllers/album_controller.dart';
import '../../core/constants/common_constants.dart';

/// 自定义
class CustomWidget extends StatefulWidget {
  final List<ImagesViewModel?> images;
  final List<String?> mp3;
  final String? publicPath;
  final String? privatePath;

  const CustomWidget({
    Key? key,
    required this.images,
    required this.mp3,
    required this.publicPath,
    required this.privatePath,
  }) : super(key: key);

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  AudioPlayer audioPlayer = AudioPlayer();
  List<String> urls = [];
  var mp3url = '';
  bool isPressed = false;
  bool isPlayed = false;
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  int index = 1;

  @override
  void initState() {
    getUrl(widget.images, widget.mp3);
    showLog("url video page url ${widget.privatePath}/$mp3url ");
    audioPlayer.play(UrlSource('${widget.privatePath}/$mp3url'));
    setState(() {
      // Toggle the state of the button
      isPlayed = true;
    });
    _overlayController.toggle();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five]);
    });

    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  @override
  void dispose() {
    // ytController.dispose();
    audioPlayer.stop();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookController bookController = BookController();

    return Stack(children: [
      BookFx(
        key: GlobalKey(),
        duration: Duration(seconds: 2),
        size: Size(1200, 450),
        /* size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),*/
        pageCount: widget.images.length,
        currentPage: (index) {
          return Image.network(
              width: double.infinity,
              height: double.infinity,
              widget.images[index]!.url!, errorBuilder: (BuildContext context,
                  Object exception, StackTrace? stackTrace) {
            return const Text('ð¢');
          });
        },
        lastCallBack: (indexes) {
          index = (indexes == 0) ? 1 : indexes;
          showLog('indexes  $index');
        },
        nextCallBack: (indexes) {
          index = (indexes == 0) ? 1 : indexes;

          showLog('next $index');
        },
        nextPage: (index) {
          return Image.network(
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Text('ð¢');
            },
            width: double.infinity,
            height: double.infinity,
            widget.images[index]!.url!,
          );
        },
        controller: bookController,
      ),
      Positioned(
          top: 10,
          left: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onPressed: () {
              _overlayController.toggle();
              setState(() {
                // Toggle the state of the button
                isPressed = !isPressed;
              });
            },
            child: OverlayPortal(
              controller: _overlayController,
              overlayChildBuilder: (BuildContext context) {
                return Stack(
                  children: [
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.78,
                      top: MediaQuery.of(context).size.height * 0.03,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 15,
                        color: Colors.white,
                        child: Showcase(
                          key: _three,
                          description: 'Click here to go back',
                          child: IconButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            //tooltip: 'Play/Pause',
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.71,
                      top: MediaQuery.of(context).size.height * 0.03,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 15,
                        child: Showcase(
                          key: _four,
                          description: 'Keep Your ears open ?',
                          child: IconButton(
                            onPressed: () async {
                              await audioPlayer.stop();
                              showLog(
                                  'music button ${widget.privatePath}/$mp3url');
                              try {
                                (!isPlayed)
                                    ? await audioPlayer.play(UrlSource(
                                        '${widget.privatePath}/$mp3url'))
                                    : await audioPlayer.stop();
                                setState(() {
                                  // Toggle the state of the button
                                  isPlayed = !isPlayed;
                                });
                              } catch (e) {
                                showLog('error on play music $e');
                              }
                            },
                            //tooltip: 'Play/Pause',
                            icon: Icon((isPlayed)
                                ? Icons.music_off
                                : Icons.music_note),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.64,
                      top: MediaQuery.of(context).size.height * 0.03,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 15,
                        child: Showcase(
                          key: _five,
                          description: 'For a bigger better view',
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => fullScreenView(
                                          widget.images[index - 1]?.url)));
                            },
                            //tooltip: 'Play/Pause',
                            icon: Icon(Icons.zoom_in),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.57,
                      top: MediaQuery.of(context).size.height * 0.03,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        elevation: 15,
                        child: IconButton(
                          onPressed: () {
                            ShowCaseWidget.of(context).startShowCase(
                                [_one, _two, _three, _four, _five]);
                          },
                          //tooltip: 'Play/Pause',
                          icon: Icon(Icons.help_outline),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Icon((isPressed) ? Icons.menu : Icons.close),
            ),
          )),
      Positioned(
          right: 10,
          bottom: 8,
          child: CommonCard(
            shape: BorderRadius.circular(100),
            child: Showcase(
              key: _two,
              description: 'Click to view your next page ',
              child: IconButton(
                onPressed: () {
                  bookController.next();
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ),
          )),
      Positioned(
          right: 75,
          bottom: 8,
          child: CommonCard(
            shape: BorderRadius.circular(100),
            child: Showcase(
              key: _one,
              description: 'click here to previous page',
              child: IconButton(
                onPressed: () {
                  bookController.last();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
            ),
          )),
      Positioned(
          bottom: 10,
          left: 10,
          child: SizedBox(
              height: MediaQuery.sizeOf(context).width * .05,
              width: MediaQuery.sizeOf(context).width * .8,
              child: ListView.builder(
                  itemCount: widget.images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          showLog('goToIndex $index');
                          if (!mounted) return;

                          bookController.goTo(index + 1);
                        },
                        child: Row(
                          children: [
                            Image.network(widget.images[index]!.url!,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              return const Text('ð¢');
                            }),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ));
                  }))),
    ]);
  }

  getUrl(List<ImagesViewModel?> images, List<String?> mp3) async {
    //showLog('getUrlLength${images.length}');

    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        urls.add(images[i]!.url!);
        //showLog('getUrl$urls');
      }
    }
    if ( mp3.isNotEmpty) {
      mp3url = mp3[0]!;
    }
  }

  fullScreenView(String? url) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
      ),
      body: Center(
        child: InteractiveViewer(
            // Set it to false

            child: Image.network(url!, errorBuilder: (BuildContext context,
                Object exception, StackTrace? stackTrace) {
          return const Text('ð¢');
        })),
      ),
    );
  }
}
