import 'package:flutter/material.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/media/my_photos_route.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/ui/animation/bouncy_page_route_animation.dart';
import 'package:photomall_flutter/ui/contactus/contact_us_data_view.dart';
import 'package:photomall_flutter/ui/drawer/home_route.dart';
import 'package:photomall_flutter/ui/event/add/add_event_route.dart';
import 'package:photomall_flutter/ui/event/booking/book_me_route.dart';
import 'package:photomall_flutter/ui/event/detail/event_details_route.dart';
import 'package:photomall_flutter/ui/event/list/events_list_route.dart';
import 'package:photomall_flutter/ui/event/photos/custom_photo_view.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import 'package:photomall_flutter/ui/folders/model/folder_arguments_model.dart';
import 'package:photomall_flutter/ui/folders/route/folder_route.dart';
import 'package:photomall_flutter/ui/gallery/category_list_view_route.dart';
import 'package:photomall_flutter/ui/gallery/gallery_detailed_route.dart';
import 'package:photomall_flutter/ui/photoselection/view/comment_and_rating_view.dart';
import 'package:photomall_flutter/ui/register/device_register_route.dart';
import 'package:photomall_flutter/ui/settings/contact_us_route.dart';
import 'package:photomall_flutter/ui/settings/settings_route.dart';
import 'package:photomall_flutter/ui/settings/version_info_settings.dart';
import 'package:photomall_flutter/ui/shared/LanguageSelector.dart';
import 'package:photomall_flutter/ui/splash/splash_screen.dart';
import 'package:photomall_flutter/ui/studioPackages/detailedRoute/packages_detailed_route.dart';
import 'package:photomall_flutter/ui/studioPackages/listRoute/studio_packages_list_route.dart';
import 'package:photomall_flutter/ui/videos/video_player_route.dart';
import 'package:photomall_flutter/ui/videos/videoplayer_arguments_model.dart';

abstract class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.SplashScreen:
        showLog("this point splash screen called");

        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RoutePaths.DeviceRegister:
        return MaterialPageRoute(builder: (_) => DeviceRegister());
      case RoutePaths.MyPhotos:
        return MaterialPageRoute(
            builder: (_) => MyPhotosRoute(
                  eventCode: (settings.arguments as String),
                ));

      case RoutePaths.Language:
        LanguageSelectorArguments? arguments =
            settings.arguments as LanguageSelectorArguments?;
        return MaterialPageRoute(
            builder: (_) => LanguageSelector(arguments: arguments));
      case RoutePaths.Home:
        return CustomPageTransitionRoute(
          page: HomeRoute(),
        );
      case RoutePaths.Settings:
        SettingsArguments? arguments = settings.arguments as SettingsArguments?;
        return CustomPageTransitionRoute(
            page: Settings(
                arguments:
                    arguments!)); //MaterialPageRoute(builder: (_) => HomeRoute());
      case RoutePaths.CommentAndRatting:
        CommentAndRattingArguments? arguments =
            settings.arguments as CommentAndRattingArguments?;
        return CustomPageTransitionRoute(
            page: CommentAndRattingView(arguments: arguments!));
      /*     case RoutePaths.AlbumPageView:
        AlbumPageViewArguments arguments = settings.arguments;
        return CustomPageTransitionRoute(page: AlbumPageViewRoute(arguments: arguments));*/
      case RoutePaths.VersionInfo:
        return CustomPageTransitionRoute(
            page:
                VersionInfoRoute()); //MaterialPageRoute(builder: (_) => VersionInfoRoute());
/*      case RoutePaths.Help:
        return MaterialPageRoute(builder: (_) => HelpRoute());*/
      /*case RoutePaths.ContactUs:
        //var post = settings.arguments as Post;
        return MaterialPageRoute(
            builder: (_) => PageTurnSampleRoute(*/ /*post: post*/ /*));*/
      case RoutePaths.AddEvent:
        return SlidePageRoute(
            widget: AddEvent(), direction: AxisDirection.left);
/*
            MaterialPageRoute(builder: (_) => AddEvent(*/
/*post: post*/ /*
));
*/
      case RoutePaths.StudioPackage:
        return CustomPageTransitionRoute(page: StudioPackagesListRoute());
      case RoutePaths.StudioPackageDetails:
        PackagesDetailArguments? arguments =
            settings.arguments as PackagesDetailArguments?;
        return CustomPageTransitionRoute(
            page: PackagesDetailedRoute(
          arguments: arguments!,
        ));
      case RoutePaths.Events:
        EventsListArguments? arguments =
            settings.arguments as EventsListArguments?;
        return CustomPageTransitionRoute(
            page: EventsListRoute(arguments: arguments!));
      /* return MaterialPageRoute(
            builder: (_) => EventsListRoute(*/ /*post: post*/ /*));*/
      case RoutePaths.EventDetails:
        EventDetailsRouteArguments? arguments =
            settings.arguments as EventDetailsRouteArguments?;
        return ZoomPageRoute(
            widget: EventDetailsRoute(
          arguments: arguments!,
        )); //MaterialPageRoute(builder: (_) => EventDetailsRoute());

      case RoutePaths.BookMe:
        return CustomPageTransitionRoute(
            page:
                BookMeRoute()); //MaterialPageRoute(builder: (_) => BookMeRoute());

      case RoutePaths.PhotoGrid:
        PhotoGridArguments? arguments =
            settings.arguments as PhotoGridArguments?;
        return CustomPageTransitionRoute(
            page: PhotoGrid(arguments: arguments!));
      case RoutePaths.CategoryList:
        return CustomPageTransitionRoute(page: CategoryListRoute());

      case RoutePaths.GalleryDetailed:
        GalleryDetailedRouteArguments? arguments =
            settings.arguments as GalleryDetailedRouteArguments?;
        return CustomPageTransitionRoute(
            page: GalleryDetailedRoute(
                arguments:
                    arguments!)); //MaterialPageRoute(builder: (_) => GalleryDetailedRoute(arguments: arguments));
      case RoutePaths.YoutubePlayer:
        YoutubePlayerArguments? arguments =
            settings.arguments as YoutubePlayerArguments?;
        return CustomPageTransitionRoute(
            page: VideoPlayerRoute(arguments: arguments!));
      case RoutePaths.CustomPhotoView:
        CustomPhotoViewArgument? arguments =
            settings.arguments as CustomPhotoViewArgument?;
        return MaterialPageRoute(
            builder: (_) => CustomPhotoView(arguments: arguments!));
      /*  case 'Contact Us':
        ContactUs arguments = settings.arguments;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: (_, a, __, c) => SlideTransition(
              position: Tween<Offset>(
                  begin:  getBeginOffset(AxisDirection.up),
                  end: Offset.zero
              ).animate(a),
              child: c,
            ),
            pageBuilder: (_, __, ___) {
              return ContactUsRoute(arguments:ContactUs(appbarRequired: true));

            });*/
      case RoutePaths.ContactUs:
        ContactUs? arguments = settings.arguments as ContactUs?;
        return PageRouteBuilder(
            settings: settings,
            transitionsBuilder: (_, a, __, c) => FadeTransition(
                  opacity: a,
                  child: c,
                ),
            pageBuilder: (_, __, ___) {
              return ContactUsRoute(arguments: arguments!);
            });
      case RoutePaths.FolderRoute:
        FoldersRouteModel? arguments = settings.arguments as FoldersRouteModel?;
        return FadeInPageRoute(
            widget: FolderRoute(
          arguments: arguments!,
          key: UniqueKey(),
        ));

      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  static Offset getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return Offset(0, 1);
      case AxisDirection.down:
        return Offset(0, -1);

      case AxisDirection.right:
        return Offset(-1, 0);

      case AxisDirection.left:
        return Offset(1, 0);
    }
  }
}
