import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/pm_job_controller.dart';
import 'package:photomall_flutter/core/Utils/native_method_channel.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/services/image_handler.dart';
import 'package:photomall_flutter/driftdb/dao/event_dao.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/media/media_view_model.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/traits/utils/network_util.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:photomall_flutter/ui/videos/videoplayer_arguments_model.dart';
import '../driftdb/app_db.dart';
import '../ui/gallery/gallery_route_view_model.dart';

class MediaList extends StatefulWidget {
  final Key? key;
  final int? index;
  final List<Media>? medias;
  final DownloadPath? downloadPath;
  final MediaRouteViewModel? model;
  final String? eventCode;
  final bool? userOwnEvent;
  final List<String>? categoryName;

  MediaList({
    this.index,
    this.medias,
    this.downloadPath,
    this.model,
    this.eventCode,
    this.key,
    this.categoryName,
    this.userOwnEvent,
  }) : super(key: key);

  @override
  State<MediaList> createState() => _MediaListState();
}

ImageProcessor imageProcessor = ImageProcessor();
String? eventCode = '';

class _MediaListState extends State<MediaList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLog("widget.userOwnEvent ${widget.userOwnEvent}");
  }

  @override
  Widget build(BuildContext context) {
    return CustomItemTransition(
      delay: widget.index! * itemTransitionDelay,
      duration: itemTransitionDuration,
      child: widget.medias![widget.index!].media!.ableType ==
              TransportDataKeys.albums
          ? setAlbumView(widget.medias!, widget.index!, widget.downloadPath!,
              widget.model!, borderRadius: widget.model!.borderRadius)
          : setVideoView(widget.medias!, widget.index!,
              borderRadius: widget.model!.borderRadius, model: widget.model!),
    );
  }

  Widget setAlbumView(
    List<Media> media,
    int index,
    DownloadPath downloadPath,
    MediaRouteViewModel model, {
    double borderRadius = 10.0,
  }) {
    showLog('setAlbumView ${media[index].albums!.code}');
    showLog('gallery ====. ${media[index].albums!.visibility} ');
    showLog('coverImage ====. ${media[index].albums!.coverImage} ');
    showLog('type ====. ${media[index].albums!.type} ');
    return (media[index].albums?.coverImage == null ||
            ((media[index].albums!.visibility == 0) &&
                media[index].albums!.type == photos))
        ? SizedBox()
        : (media[index].event?.categoryName == model.category ||
                model.category == '')
            ? (media[index].albums!.visibility == 1 ||
                    (media[index].albums!.visibility == 2 &&
                            widget.userOwnEvent == true ||
                        model.isFromPrivateKey == true))
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: InkWell(
                          onTap: () async {
                            if (Platform.isAndroid) {
                              if (media[index].albums!.type != photos &&
                                  media[index].albums!.type !=
                                      invitationAlbum) {
                                try {
                                  await NativeMethodChannel()
                                      .showAlbum(media[index].media!.ableCode);
                                } catch (e, s) {
                                  showLog('Error OPEN :: $e :: $s');
                                }
                              } else {
                                onTapPhotoAlbum(media[index], downloadPath,
                                    media[index].albums!.name, model,
                                    borderRadius: borderRadius);
                              }
                            } else {
                              if (media[index].albums!.type != photos &&
                                  media[index].albums!.type !=
                                      invitationAlbum) {
                                try {
                                  getEventCode(media[index]);
                                  onTapEAlbum(
                                      index,
                                      media[index],
                                      downloadPath,
                                      media[index].albums!.name,
                                      widget.eventCode ?? eventCode,
                                      model);
                                } catch (e, s) {
                                  showLog('Error OPEN :: $e :: $s');
                                }
                              } else {
                                onTapPhotoAlbum(media[index], downloadPath,
                                    media[index].albums!.name, model);
                              }
                            }
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  CustomCachedNetworkImageWidget(
                                    url:
                                        "${downloadPath.public}/${media[index].albums!.coverImage}",
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 10,
                                bottom: 25,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    getAlbumName(media[index]),
                                    /*  CommonText(
                                  // isCard: true,
                                  // isHighlightedCard: true,
                                  text: "${demoEvent[index]!.event!.name} ",
                                  //fontWeight: FontWeight.bold,
                                  //color: AppColorData.titleTextColor,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(5.0, 5.0),
                                        blurRadius: 8.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                  // fontSize: TextProperty.h2,
                                ),*/
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 5,
                                child: CommonText(
                                  //isCard: true,
                                  //isHighlightedCard: false,
                                  text: media[index].albums!.type ==
                                          invitationAlbum
                                      ? S.of(context).invitation
                                      : (media[index].albums!.type != photos)
                                          ? "${S.of(context).albums}"
                                          : "${S.of(context).photos}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 8.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  )
                : SizedBox()
            : SizedBox();
  }

  Widget setVideoView(
    List<Media> media,
    int index, {
    double borderRadius = 30.0,
    required MediaRouteViewModel model,
  }) {
    showLog("Setvideoview :${media[index].videos}");
    return (media[index].event?.categoryName == model.category ||
            model.category == '')
        ? (media[index].videos?.visibility == 1 ||
                media[index].videos?.visibility == 2 &&
                    widget.userOwnEvent == true ||
                model.isFromPrivateKey == true)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    InternetChecker myConnectivity = InternetChecker();
                    myConnectivity.networkChecker(
                        onTap: () async {
                          showYoutube(index, media);
                        },
                        context: context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: media[index].videos == null ||
                                      media[index].videos!.url == ''
                                  ? CommonCircularProgress()
                                  : Column(
                                      children: [
                                        FutureBuilder<String>(
                                          future: getVideoCoverImage(
                                              media[index].videos!.url),
                                          // Fetch the URL
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CommonCircularProgress(); // or any loading widget
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                color: AppColorData
                                                    .appBarTextColor,
                                                child: Image.asset(
                                                    'assets/images/splash_logo.png'),
                                              );
                                            } else {
                                              return CachedNetworkImage(
                                                imageUrl: snapshot.data!,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  color: AppColorData
                                                      .appBarTextColor,
                                                  child: Image.asset(
                                                      'assets/images/splash_logo.png'),
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                            ),
                            Center(
                              //left: 90,
                              //top: 70,
                              child: Opacity(
                                opacity: 0.6,
                                child: Container(
                                  child: CircleAvatar(
                                    child: /* Icon(
                                  Icons.play_arrow,
                                  size: 30,
                                ),*/
                                        Lottie.asset(
                                            'assets/animations/play.json',
                                            height: 40,
                                            width: 40),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  width: 60.0,
                                  height: 60.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.white, // border color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        /*Positioned(
                top: 0,
                right: 0,
                child: ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: AppColorData.cardGradientBegin,
                              end: AppColorData.cardGradientEnd,
                              colors: AppColorData.cardBackgroundColors,
                              stops: AppColorData.cardStops)),
                      height: 40,
                      width: 180,
                    )),
              ),*/

                        Positioned(
                          bottom: 5,
                          left: 15,
                          child: CommonText(
                            //isCard: true,
                            //isHighlightedCard: false,
                            text: '${S.of(context).video}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 15,
                          child: getVideoName(media[index]),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : SizedBox()
        : SizedBox();
  }

  Future<void> onTapPhotoAlbum(Media media, DownloadPath downloadPath,
      String name, MediaRouteViewModel model,
      {double borderRadius = 10.0}) async {
    showLog('onTapPhotoAlbum ${borderRadius}');
    await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => PhotoGrid(
                  arguments: PhotoGridArguments(
                    mediaRouteViewModel: model,
                    isFromAlbum: true,
                    callbackPhotoSelection: () {},
                    storagePath: DownloadPath(
                        private: downloadPath.private,
                        public: downloadPath.public,
                        DocumentPath: downloadPath.DocumentPath),
                    albumCode: media.media!.ableCode,
                    appBarTitle: name,
                    borderRadius: borderRadius,
                    eventCode: media.event?.code,
                  ),
                )));
  }

  Future<void> onTapEAlbum(
    int index,
    Media media,
    DownloadPath downloadPath,
    String name,
    String? eventCode,
    MediaRouteViewModel model,
  ) async {
    showLog('eventCode $eventCode');
    await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => PhotoGrid(
                  arguments: PhotoGridArguments(
                      mediaRouteViewModel: model,
                      callbackPhotoSelection: () {},
                      storagePath: DownloadPath(
                          private: downloadPath.private,
                          public: downloadPath.public,
                          DocumentPath: downloadPath.DocumentPath),
                      albumCode: media.media!.ableCode,
                      appBarTitle: name,
                      eventCode: eventCode,
                      isIos: true),
                )));
  }

  void showYoutube(int index, List<Media> media) {
    showLog('showYoutube ${media[index].videos!.url} ');
    Navigator.pushNamed(context, RoutePaths.YoutubePlayer,
        arguments: YoutubePlayerArguments(
            url: media[index].videos!.url,
            title:
                "${media[index].event!.categoryName} ${S.of(context).video}"));
  }

  getEventCode(Media media) {
    if (widget.eventCode != null) {
      showLog("yes eventCode is present ");
    } else {
      eventCode = media.event?.code;
      showLog("yes eventCode ${eventCode}");
    }
  }

  getAlbumName(Media media) {
    String text = '';
    if (widget.eventCode != null) {
      text = media.albums?.name ?? "";
      showLog("yes it contain this $text");
    } else {
      text = media.event?.categoryName ?? "";
      eventCode = media.event?.code;
      showLog("yes it contain this1 ${media.event?.code}");
    }
    if (text.contains("&amp;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&amp;", "&");
    }
    if (text.contains("&#039;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&#039;", "\'");
    }

    return CommonText(
      // isCard: true,
      // isHighlightedCard: true,
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 8.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ),
    );
  }

  getVideoName(Media media) {
    String text = '';

    if (widget.eventCode != null) {
      text = media.videos?.name ?? "";
    } else {
      text = media.event?.categoryName ?? "";
    }

    if (text.contains("&amp;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&amp;", "&");
    }
    if (text.contains("&#039;")) {
      showLog("yes it contain this ");
      text = text.replaceAll("&#039;", "\'");
    }

    return CommonText(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 8.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
        // isCard: true,
        // isHighlightedCard: true,
        text: '$text',
        maxlines: 1);
  }
}
