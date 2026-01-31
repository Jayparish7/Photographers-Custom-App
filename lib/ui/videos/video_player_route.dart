import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/videos/video_player_view_model.dart';
import 'package:photomall_flutter/ui/videos/videoplayer_arguments_model.dart';
import 'package:provider/provider.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as view;

class VideoPlayerRoute extends StatefulWidget {
  final YoutubePlayerArguments arguments;

  VideoPlayerRoute({Key? key, required this.arguments}) : super(key: key);

  @override
  State<VideoPlayerRoute> createState() => _VideoPlayerRouteState();
}

class _VideoPlayerRouteState extends State<VideoPlayerRoute> {
  BaseWidget<VideoPlayerViewModel>? baseWidget;

  //late final PodPlayerController controller;
  late YoutubePlayerController ytController;

  bool isLoading = true;
  String youtubeUrl = '';

  @override
  void initState() {
    showLog(" url video page ${widget.arguments.url}");
    if (widget.arguments.url.contains("youtube")) {
      youtubeUrl = widget.arguments.url.split("/").last;
      showLog("youtubeUrl:$youtubeUrl");
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    ytController = YoutubePlayerController(
      initialVideoId: youtubeUrl, //widget.arguments.url,
      flags: const YoutubePlayerFlags(
          controlsVisibleAtStart: false,
          autoPlay: true,
          mute: false,
          forceHD: true,
          showLiveFullscreenButton: false,
          hideControls: false
          /*showLiveFullscreenButton: false,
        disableDragSeek: false,
        loop: true,
        hideThumbnail: true,*/
          ),
    );
    /* controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.arguments.url}'),
    )..initialise();*/
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  @override
  void dispose() {
    ytController.dispose();
    // controller.dispose();

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
    baseWidget = BaseWidget<VideoPlayerViewModel>(
      model: VideoPlayerViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) =>
          model.initialVideoPlayerMethod(widget.arguments.url),
      builder: (context, model, child) {
        return WillPopScope(
            onWillPop: () async {
              await SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              /* appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),
                title: Text(widget.arguments.title,style: TextStyle(fontSize: 22,color: Colors.white),),backgroundColor: Colors.transparent,
              ),*/
              body: model.isLoading!
                  ? CommonCircularProgress()
                  : showVideo(model)!,
            ));
      },
    );
    return baseWidget!;
  }

  showVideo(VideoPlayerViewModel model) {
    return (widget.arguments.url.contains('vimeo') ||
            widget.arguments.url.contains('odysee'))
        ? networkVideoUrl(widget.arguments.url)
        : OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              // Force rotate if somehow portrait happens
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft,
              ]);
            }
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: YoutubePlayer(
                controller: ytController,
                onReady: () {
                  SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.immersiveSticky);
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                  ]);
                  // Optionally lock orientation here
                },
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              ),
            );
          }); /*PodVideoPlayer(
            controller: controller,
          videoAspectRatio: 16/9,
          );*/
  }

  networkVideoUrl(String url) {
    if (url.contains('vimeo')) {
      showLog("vimeo url:$url");
      String videoID = url.split('/').last;
      return VimeoVideoPlayer(
        videoId: videoID,
        isAutoPlay: true,
        showTitle: false,
        showByline: false,
        enableDNT: true,
        onInAppWebViewCreated: (controller) {
          controller.setSettings(
              settings: view.InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
          ));
        },
        onInAppWebViewLoadStart: (controller, url) async {
          // 🚫 Detect and block redirection
          if (url != null && !url.toString().contains("player.vimeo.com")) {
            await controller.goBack(); // or controller.loadUrl(...) to reset
          }
        },
      );
    }

    final embedUrl = embedKey(url ?? '');

    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(embedUrl!),
      );

    return WebViewWidget(controller: controller);
  }

  embedKey(String url) {
    try {
      if (!url.contains('odysee')) {
        return url;
      }
      if (url.isEmpty) {
        return const Center(child: Text('Invalid video URL'));
      }

      final uri = Uri.parse(url);
      final segments = uri.pathSegments;

      if (segments.length < 2) {
        return const Center(child: Text('Malformed Odysee URL'));
      }

      // Example segment: "I'm-Selling-My-Bike:8"
      final lastSegment = segments.last;
      if (!lastSegment.contains(":")) {
        return const Center(child: Text('Missing claim ID'));
      }
      final parts = lastSegment.split(":");
      final claimName = parts[0];
      final claimId = parts[1];
      final embedUrl =
          Uri.encodeFull("https://odysee.com/\$/embed/$claimName/$claimId");
      return embedUrl;
    } catch (e) {}
  }
}
/*PodVideoPlayer(

            onToggleFullScreen: (a) async {
              showLog("now showing ${a}");

            },

            controller: model.controller!
        )

*/
