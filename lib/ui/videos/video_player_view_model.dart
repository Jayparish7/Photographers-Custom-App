import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photomall_flutter/api/repository/photomall_apis.dart';
import 'package:photomall_flutter/core/Utils/file_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/driftdb/dao/file_dao.dart';
import 'package:photomall_flutter/ui/base/base_observer.dart';
//import 'package:pod_player/pod_player.dart';
import 'package:last_pod_player/last_pod_player.dart';

class VideoPlayerViewModel extends BaseObserver {
  VideoPlayerViewModel({
    this.apiHandler,
    this.context,
  }) {
    apiRepo = PhotomallApis(this.context);
  }

  PodPlayerController? controller;

  //late YoutubePlayerController controller;
  //YoutubePlayerController? controller;

  ApiHelper? apiHandler;
  PhotomallApis? apiRepo;
  BuildContext? context;
  bool? isLoading = false;
  FileUtil fileUtil = FileUtil();
  FileModelDao fileModelDao = FileModelDao();

  @override
  void onInternetConnectionBack() async {
    showLog('event_list_route :: onInternetConnectionBack :: called');
  }

  // init method
  initialVideoPlayerMethod(String url) async {
    /* isLoading = true;
    setBusy(false);
    await loadVideo(url);
    //await loadVideo(url);
    isLoading = false;
    setBusy(false);*/
  }

  loadVideo(String url) async {
    showLog('videoId is start $url');

    final urls = await PodPlayerController.getYoutubeUrls("$url");

    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.networkQualityUrls(
        videoUrls: urls!,
      ),
      podPlayerConfig: const PodPlayerConfig(

          // videoQualityPriority: [360],
          ),
    )..initialise();
    /* final videoId = YoutubePlayer.convertUrlToId(url);
    showLog(" url video page model ${videoId}");

    controller = YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          enableCaption: false,
          hideThumbnail: true,
          //hideControls: true,
          showLiveFullscreenButton: false,
          useHybridComposition: false,
        ));*/
  }
}
