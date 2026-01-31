import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart' as icon;
import 'package:lottie/lottie.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/profile_controller.dart';
import 'package:photomall_flutter/core/Utils/address_utils.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as appConfig;
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as transporterModel;
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/common_widgets/custom_transition_widget.dart';
import 'package:photomall_flutter/traits/common_widgets/map_utils.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/contactus/contact_us_data_view_model.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContactUsDataView extends StatefulWidget {
  final String? studioCode;

  const ContactUsDataView({super.key, this.studioCode});

  @override
  State<ContactUsDataView> createState() => _ContactUsDataViewState();
}

class _ContactUsDataViewState extends State<ContactUsDataView> {
  String? publicStoragePath;

  @override
  void initState() {
    super.initState();
    getPubLicStoragePath();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ContactUsDataViewModel>(
        model: ContactUsDataViewModel(
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context),
        onModelReady: (model) =>
            model.getContactUsDetails(studioCode: widget.studioCode),
        builder: (context, model, child) {
          showLog('state in view : ${model.busy}');
          return Stack(
            children: <Widget>[
              _setContactUsDetail(context, model),
              model.busy
                  ? Center(
                      child: CommonCircularProgress(),
                    )
                  : SizedBox()
            ],
          );
        });
  }

  _setContactUsDetail(BuildContext context, ContactUsDataViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: AppColorData.appBarTextColor,
                )),
            UniqueText(
              text: S.of(context).contactUs,
            )
          ],
        ),
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(40.0)),
                      child: isPhotomallApp
                          ? CustomCachedNetworkImageWidget(
                              url: model.studioLogo,
                            )
                          : /*studioDataController.getStudioLogo(context,
                              publicStoragePath: model.publicStoragePath!,
                              documentPath: model.documentDirectory)*/
                          SizedBox(),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '${model.studioName}',
                      style: TextStyle(
                        color: AppColorData.appBarTextColor,
                        fontSize: 25,
                        /*fontWeight: FontWeight.bold,
                       shadows: <Shadow>[
                         Shadow(
                           offset: Offset(2.0, 2.0),
                           blurRadius: 1.0,
                           color: Color.fromARGB(255, 0, 0, 0),
                         ),
                         Shadow(
                           offset: Offset(1.0, 1.0),
                           blurRadius: 1.0,
                           color: Color.fromARGB(255, 0, 0, 0),
                         ),
                       ],*/
                      ),
                    ),

                    SizedBox(
                      height: 65,
                    ),
                    (model.socialProfile!.isNotEmpty &&
                            model.socialProfile != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: 8,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (model.facebookUrl != "")
                                      ? socialIconWidget(
                                          icon: Lottie.asset(
                                              repeat: false,
                                              width: 65,
                                              height: 65,
                                              'assets/animations/fb.json'),
                                          url: model.facebookUrl,
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  (model.whatsappNumber != "" &&
                                          model.whatsappNumber != null)
                                      ? InkWell(
                                          onTap: () async {
                                            showLog("Add event is ");
                                            final link = WhatsAppUnilink(
                                              phoneNumber: model.whatsappNumber,
                                              text: S
                                                  .of(context)
                                                  .helloIAmCurrentlyUsingYourMobileAppAndWould,
                                            );
                                            await launchUrl(
                                                Uri.parse(link.toString()));
                                          },
                                          child: icon.Brand(
                                            icon.Brands.whatsapp,
                                            size: 65,
                                          ),
                                        )
                                      : SizedBox(),
                                  (model.website != "" && model.website != null)
                                      ? socialIconWidget(
                                          icon: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(FontAwesomeIcons.globe,
                                                size: 50.0, color: Colors.blue
                                                // color: Colors.blueAccent,
                                                ),
                                          ),
                                          url: model.website,
                                        )
                                      : SizedBox(),
                                  (model.instagramUrl != "")
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: socialIconWidget(
                                            icon: icon.Brand(
                                              icon.Brands.instagram,
                                              size: 65,
                                            ),
                                            url: model.instagramUrl,
                                          ))
                                      : SizedBox(),
                                  (model.youtubeUrl != "")
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: socialIconWidget(
                                            icon: /* icon.Brand(icon.Brands.youtube,size: 65,
                                               // color: Color(0xffFF0000)
                                                // color: Color(0xffFF0000),
                                                ),*/
                                                Lottie.asset(
                                                    repeat: false,
                                                    width: 65,
                                                    height: 65,
                                                    'assets/animations/youtube.json'),
                                            url: model.youtubeUrl,
                                          ))
                                      : SizedBox(),
                                  (model.twitterUrl != "")
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: socialIconWidget(
                                            icon: Icon(
                                                FontAwesomeIcons.squareTwitter,
                                                size: 50.0,
                                                color: AppColorData
                                                    .iconSelectedColor
                                                //color: Color(0xff1DA1F2),
                                                ),
                                            url: model.twitterUrl,
                                          ))
                                      : SizedBox(),
                                  (model.linkedIn != "")
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: socialIconWidget(
                                            icon: Icon(
                                                FontAwesomeIcons.linkedin,
                                                size: 50.0,
                                                color: AppColorData
                                                    .iconSelectedColor
                                                // color: Color(0xff0077b5),
                                                ),
                                            url: model.linkedIn,
                                          ))
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : (model.whatsappNumber != "" &&
                                model.whatsappNumber != null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: InkWell(
                                  onTap: () async {
                                    showLog("Add event is");
                                    final link = WhatsAppUnilink(
                                      phoneNumber: model.whatsappNumber,
                                      text: S
                                          .of(context)
                                          .helloIAmCurrentlyUsingYourMobileAppAndWould,
                                    );
                                    await launchUrl(Uri.parse(link.toString()));
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.squareWhatsapp,
                                    size: 40.0,
                                    color: AppColorData.iconSelectedColor,
                                  ),
                                ),
                              )
                            : SizedBox(),
                    SizedBox(
                      child: Visibility(
                        visible: model.facebookUrl.isNotEmpty &&
                                model.twitterUrl.isNotEmpty &&
                                model.googlePlusUrl.isNotEmpty &&
                                model.instagramUrl.isNotEmpty &&
                                model.youtubeUrl.isNotEmpty
                            ? true
                            : false,
                        child: CommonCard(
                          shape: BorderRadius.circular(25.0),
                          child: Row(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ///Facebook
                              Visibility(
                                visible:
                                    model.facebookUrl.isNotEmpty ? true : false,
                                child: Expanded(
                                    child: IconButton(
                                        icon: Icon(
                                          EvaIcons.facebook,
                                          color: AppColorData.iconSelectedColor,
                                          // color: Colors.blue,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          showLog(
                                              "facebook url get ::${model.facebookUrl}");
                                          launchUrl(
                                              Uri.parse(model.facebookUrl));
                                        })),
                              ),

                              ///Twitter
                              Visibility(
                                visible:
                                    model.twitterUrl.isNotEmpty ? true : false,
                                child: Expanded(
                                    child: IconButton(
                                        icon: Icon(
                                          EvaIcons.twitter,
                                          color: AppColorData.iconSelectedColor,
                                          //color: Colors.blueAccent,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          showLog(
                                              "Twitter url get ${model.twitterUrl}");
                                          launchUrl(
                                              Uri.parse(model.twitterUrl));
                                        })),
                              ),

                              ///Google Plus
                              Visibility(
                                visible: model.googlePlusUrl.isNotEmpty
                                    ? true
                                    : false,
                                child: Expanded(
                                    child: IconButton(
                                        icon: Icon(
                                          EvaIcons.google,
                                          color: AppColorData.iconSelectedColor,
                                          // color: Colors.red,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          showLog(
                                              "Google Plus url get::${model.googlePlusUrl}");
                                          launchUrl(
                                              Uri.parse(model.googlePlusUrl));
                                        })),
                              ),

                              ///Instagram
                              Visibility(
                                visible: model.instagramUrl.isNotEmpty
                                    ? true
                                    : false,
                                child: Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          showLog(
                                              "Instagram url get::${model.instagramUrl}");
                                          launchUrl(
                                              Uri.parse(model.instagramUrl));
                                        },
                                        child: SizedBox(
                                            height: 30.0,
                                            width: 30,
                                            child: Image.asset(
                                                "assets/images/instagram_icon.png")))),
                              ),

                              ///Youtube
                              Visibility(
                                visible:
                                    model.youtubeUrl.isNotEmpty ? true : false,
                                child: Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          showLog(
                                              "Youtube url get::${model.youtubeUrl}");
                                          launchUrl(
                                              Uri.parse(model.youtubeUrl));
                                        },
                                        child: SizedBox(
                                            height: 30.0,
                                            width: 30,
                                            child: Image.asset(
                                                "assets/images/youtube_icon.png")))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SocialMediaIconView(),
                  ],
                ),
              ),
            ),
          ],
        ),
        model.contactPoints != null
            ? Flexible(
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: model.contactPoints!.length,
                    itemBuilder: (context, index) {
                      return CustomItemTransition(
                        duration: itemTransitionDuration,
                        delay: itemTransitionDelay * index,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Padding(
                              padding: EdgeInsets.all(15.0),
                              child: model.contactPoints![index].name != null
                                  ? CommonText(
                                      text:
                                          '${model.contactPoints![index].name}',
                                      color: AppColorData.titleTextColor,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                                  : SizedBox(),
                            ),*/
                            ContactPointsItem(
                                model.contactPoints![index], model)
                          ],
                        ),
                      );
                    }),
              )
            : SizedBox(),
      ],
    );
  }

  Widget emailDetailWidget(BuildContext context, ContactUsDataViewModel model) {
    return Visibility(
      visible: (model.email.isNotEmpty) ? true : false,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.mail,
                    color: AppColorData.iconColor,
                  ),
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.email.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Visibility(
                      visible: (model.email[index] != '' &&
                              model.email[index].isNotEmpty)
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            launchUrl(
                                Uri.parse("mailto:${model.email[index]}"));
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            // color: Colors.red,
                            child: CommonText(
                              text: model.email[index],
                              style: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.normal,
                              // color: AppColorData.normalTextColor,
                            ),
                            /*leading: Icon(
                              Icons.mail,
                              color: Theme.of(context).primaryColor,
                            ),*/
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget phoneDetailWidget(BuildContext context, ContactUsDataViewModel model) {
    return Visibility(
      visible: (model.phoneNumber != '' && model.phoneNumber.isNotEmpty)
          ? true
          : false,
      child: Column(
        children: [
          Row(children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.phone,
                  color: AppColorData.iconColor,
                ),
              ),
            ),
            VerticalDivider(),
            Expanded(
              flex: 6,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: model.phoneNumber.length,
                itemBuilder: (BuildContext context, int index) {
                  return Visibility(
                    visible: (model.phoneNumber[index] != '' &&
                            model.phoneNumber[index].isNotEmpty)
                        ? true
                        : false,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () => {
                          launchUrl(
                              Uri.parse("tel:${model.phoneNumber[index]}"))
                        },
                        child: Container(
                          child: CommonText(
                            text: model.phoneNumber[index],
                            fontWeight: FontWeight.normal,
                            //color: AppColorData.normalTextColor,
                          ),
                          /* leading: Icon(
                                                        Icons.phone,
                                                        color: Theme.of(context).primaryColor,
                                                      ),*/
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }

  socialIconWidget({
    icon,
    url,
  }) {
    return InkWell(
      onTap: () {
        showLog("Contact_us clicked url is '::'$url ");
        showLog('this is url :: ${url} ');
        launchUrl(Uri.parse(url));
      },
      child: icon,
    );
  }

  ContactPointsItem(
      appConfig.ContactPoint contactPoint, ContactUsDataViewModel model) {
    return Column(
      children: [
        ((contactPoint.phones != null) && (contactPoint.phones!.isNotEmpty))
            ? ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 50),
                  child: Divider(
                    color: AppColorData.dividerColor,
                  ),
                ),
                itemCount: contactPoint.phones!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(
                          "tel:${contactPoint.phones![index].phoneNumber}"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: AppColorData
                                              .bgIconBackgroundColor,
                                          begin:
                                              AppColorData.bgIconGradientBegin,
                                          end: AppColorData.bgIconGradientEnd,
                                          stops: AppColorData.bgIconStops,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.call,
                                          size: 45,
                                          color: Colors.blue,
                                        ),
                                      )),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  //isCard: true,

                                  contactPoint.phones![index].phoneNumber ?? "",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColorData
                                          .cardHighlightedTextColour),
                                  // color: AppColorData.normalTextColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : SizedBox(),
        contactPoint.emails != null && contactPoint.emails!.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 50),
                  child: Divider(
                    color: AppColorData.dividerColor,
                  ),
                ),
                itemCount: contactPoint.emails!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showLog(
                          "message email clicked ${contactPoint.emails![index].address}");
                      launchUrl(Uri.parse(
                          "mailto:${contactPoint.emails![index].address}"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: AppColorData
                                              .bgIconBackgroundColor,
                                          begin:
                                              AppColorData.bgIconGradientBegin,
                                          end: AppColorData.bgIconGradientEnd,
                                          stops: AppColorData.bgIconStops,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: icon.Brand(
                                        icon.Brands.mail,
                                        size: 65,
                                      ),
                                    )),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    "${contactPoint.emails![index].address}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: AppColorData
                                            .cardHighlightedTextColour),
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : SizedBox(),
        contactPoint.address != null
            ? InkWell(
                onTap: () {
                  MapUtils mapController = MapUtils();
                  mapController.openMapByAddress(
                      address: contactPoint.address!);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors:
                                          AppColorData.bgIconBackgroundColor,
                                      begin: AppColorData.bgIconGradientBegin,
                                      end: AppColorData.bgIconGradientEnd,
                                      stops: AppColorData.bgIconStops,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: icon.Brand(
                                    icon.Brands.maps,
                                    size: 65,
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                AddressUtils.getAddress(contactPoint.address!),
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        AppColorData.cardHighlightedTextColour),
                                // color: AppColorData.normalTextColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Future<void> getPubLicStoragePath() async {
    var appConfig = TransporterPreference();
    transporterModel.TransportModel? studioDetails =
        await appConfig.getAppConfig();
    if (studioDetails != null && studioDetails.studioData!.data != null) {
      publicStoragePath = studioDetails.studioData!.data!.publicStoragePath;
    }
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        // center: Alignment.center,
        //radius: 0.5,
        colors: [
          Color(0xff5851DB),
          Color(0xff833AB4),
          Color(0xffC13584),
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

class SocialMediaIconView extends StatefulWidget {
  @override
  State<SocialMediaIconView> createState() => _SocialMediaIconViewState();
}

class _SocialMediaIconViewState extends State<SocialMediaIconView> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ContactUsDataViewModel>(
        model: ContactUsDataViewModel(
            apiHandler: Provider.of<ApiHelper>(context, listen: false),
            context: context),
        onModelReady: (model) => model.getContactUsDetails(),
        builder: (context, model, child) {
          showLog('state in view : ${model.busy}');
          return Stack(
            children: <Widget>[
              _setContactUsDetail(context, model),
              /* Center(
                child: CircularProgressIndicator(),
              )*/
              model.busy
                  ? Center(
                      child: CommonCircularProgress(),
                    )
                  : SizedBox()
            ],
          );
        });
  }

  _setContactUsDetail(BuildContext context, ContactUsDataViewModel model) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child:
              (model.socialProfile!.isNotEmpty && model.socialProfile != null)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (model.facebookUrl != "")
                            ? socialIconWidget(
                                icon: Icon(
                                  FontAwesomeIcons.squareFacebook,
                                  size: 30.0,
                                  color: Color(0xff3b5998),
                                ),
                                url: model.facebookUrl,
                              )
                            : SizedBox(),
                        (model.instagramUrl != "")
                            ? Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: socialIconWidget(
                                  icon: RadiantGradientMask(
                                      child: Icon(
                                    FontAwesomeIcons.squareInstagram,
                                    size: 30.0,
                                    color: Color(0xffC13584),
                                  )),
                                  url: model.instagramUrl,
                                ))
                            : SizedBox(),
                        (model.youtubeUrl != "")
                            ? Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: socialIconWidget(
                                  icon: Icon(
                                    FontAwesomeIcons.squareYoutube,
                                    size: 30.0,
                                    color: Color(0xffFF0000),
                                  ),
                                  url: model.youtubeUrl,
                                ))
                            : SizedBox(),
                        (model.twitterUrl != "")
                            ? Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: socialIconWidget(
                                  icon: Icon(
                                    FontAwesomeIcons.twitter,
                                    size: 30.0,
                                    color: Color(0xff1DA1F2),
                                  ),
                                  url: model.twitterUrl,
                                ))
                            : SizedBox(),
                        (model.linkedIn != "")
                            ? Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: socialIconWidget(
                                  icon: Icon(
                                    FontAwesomeIcons.linkedin,
                                    size: 30.0,
                                    color: Color(0xff0077b5),
                                  ),
                                  url: model.linkedIn,
                                ))
                            : SizedBox(),
                      ],
                    )
                  : SizedBox(),
        ),
        SizedBox(
          child: Visibility(
            visible: model.facebookUrl.isNotEmpty &&
                    model.twitterUrl.isNotEmpty &&
                    model.googlePlusUrl.isNotEmpty &&
                    model.instagramUrl.isNotEmpty &&
                    model.youtubeUrl.isNotEmpty
                ? true
                : false,
            child: CommonCard(
              shape: BorderRadius.circular(25.0),
              child: Row(
                //  mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Facebook
                  Visibility(
                    visible: model.facebookUrl.isNotEmpty ? true : false,
                    child: Expanded(
                        child: IconButton(
                            icon: Icon(
                              EvaIcons.facebook,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            onPressed: () {
                              launchUrl(Uri.parse(model.facebookUrl));
                            })),
                  ),

                  ///Twitter
                  Visibility(
                    visible: model.twitterUrl.isNotEmpty ? true : false,
                    child: Expanded(
                        child: IconButton(
                            icon: Icon(
                              EvaIcons.twitter,
                              color: Colors.blueAccent,
                              size: 30.0,
                            ),
                            onPressed: () {
                              launchUrl(Uri.parse(model.twitterUrl));
                            })),
                  ),

                  ///Google Plus
                  Visibility(
                    visible: model.googlePlusUrl.isNotEmpty ? true : false,
                    child: Expanded(
                        child: IconButton(
                            icon: Icon(
                              EvaIcons.google,
                              color: Colors.red,
                              size: 30.0,
                            ),
                            onPressed: () {
                              launchUrl(Uri.parse(model.googlePlusUrl));
                            })),
                  ),

                  ///Instagram
                  Visibility(
                    visible: model.instagramUrl.isNotEmpty ? true : false,
                    child: Expanded(
                        child: InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(model.instagramUrl));
                            },
                            child: SizedBox(
                                height: 30.0,
                                width: 30,
                                child: Image.asset(
                                    "assets/images/instagram_icon.png")))),
                  ),

                  ///Youtube
                  Visibility(
                    visible: model.youtubeUrl.isNotEmpty ? true : false,
                    child: Expanded(
                        child: InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(model.youtubeUrl));
                            },
                            child: SizedBox(
                                height: 30.0,
                                width: 30,
                                child: Image.asset(
                                    "assets/images/youtube_icon.png")))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  socialIconWidget({
    icon,
    url,
  }) {
    return InkWell(
      onTap: () {
        showLog('this is url :: $url ');
        launchUrl(Uri.parse(url));
      },
      child: icon,
    );
  }
}

class ContactUs {
  bool? appbarRequired;
  final String? studioCode;

  ContactUs({
    this.appbarRequired,
    this.studioCode,
  });
}
