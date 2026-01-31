import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  CommonAppBar({
    Key? key,
    this.title,
    this.isMainPage = false,
    this.actions = const [SizedBox()],
    this.isTransparentAppBar = false,
    this.isAppBarTitleWidget = false,
    this.titleWidget,
    this.isCenterTitle = false,
    this.isTransparent = false,
    this.autoLeadingIcon = true,
    this.menuKey,
    this.qrKey,
  });

  final Key? menuKey;
  final Key? qrKey;
  final double preferredHeight = 60.0;
  final String? title;
  final bool isMainPage;
  final List<Widget> actions;
  final bool isTransparentAppBar;
  final bool isAppBarTitleWidget;
  final Widget? titleWidget;
  final bool isCenterTitle;
  final bool isTransparent;
  final bool autoLeadingIcon;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight); // default is 56.0

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);
  List<Widget> actions = [
    SizedBox(),

    /*Container(
      height: 50,
      width: 50,
      color: Colors.blue,
    )*/
  ];
  StreamSubscription? listener;

  //var keyMenu = GlobalKey();
  // var keyQr = GlobalKey();
  //var keyChat = GlobalKey();

  @override
  void initState() {
    showLog("Common appbar connection:: checkInternetConnectivity showing");
    checkInternetConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    //...
    super.dispose();
    listener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(25),
      child: AppBar(
        automaticallyImplyLeading: widget.autoLeadingIcon,
        centerTitle: widget.isCenterTitle,
        titleSpacing: -5,
        backgroundColor: Colors.transparent,
        actions: actions,
        // pinned: true,
        // expandedHeight: 60,
        flexibleSpace: widget.isTransparent
            ? Container(
                color: Colors.black,
              )
            : Container(
                height: 100,
                decoration: BoxDecoration(
                    // LinearGradient
                    /* gradient: LinearGradient(
                    stops: AppColorData.appBarStops,
                    begin: AppColorData.appBarGradientBegin,
                    end: AppColorData.appBarGradientEnd,
                    // colors for gradient
                    colors: widget.isTransparentAppBar
                        ? [Colors.transparent, Colors.transparent]
                        : AppColorData
                            .appBarBackgroundColors, //[Colors.greenAccent,Colors.lightBlueAccent]//
                  ),*/
                    /* borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20))*/
                    ),
              ),
        // title of appbar
        title: !widget.isAppBarTitleWidget
            ? UniqueText(
                text: '${widget.title}',
                //isAppBar: true,
                //style: Theme.of(context).textTheme.headlineSmall.copyWith(color: Colors.black),
              )
            : widget.titleWidget,
        // centerTitle: true,
        elevation: 0,
        leading: widget.isMainPage
            ? Image.asset('assets/images/splash_logo.png')
            : null,
        iconTheme: IconThemeData(color: AppColorData.bgIconColor),
        /* GestureDetector(
          onTap: (){
            showLog("Back page");
          },
          child: IconButton(onPressed:(){
            Navigator.pop(context);},
            icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: AppColorData.appBarIconColor
       ),),
        ),*/
      ),
    );
  }

  Future<bool> isLoggedIn() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getBool('$isUserLoggedInPreferenceKey') ?? false;
  }

  Future<void> checkInternetConnectivity() async {
    showLog("app bar internet method ");

    InternetConnectionStatus data =
        await InternetConnectionChecker.instance.connectionStatus;

    if (data == InternetConnectionStatus.connected ||
        widget.isMainPage == true) {
      /* if(widget.isMainPage){
        actionss = widget.actions;
      }*/
      /* actionss = [
        Container(
          height: 50,
          width: 50,
          color: Colors.green,
          child: Text(" initial running",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
        )
      ];*/
      actions = widget.actions;
      setState(() {});
    } else {
      actions = [
        //SizedBox(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        /*CommonText(
                          text: " Offline",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.red),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ];
      setState(() {});
    }
    listener = InternetConnectionChecker.instance
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          {
            if (widget.isMainPage == true) {
              //actions = widget.actions;
            } else {
              actions = widget.actions;
            }
            /*actionss = [
              Container(
                height: 50,
                width: 50,
                color: Colors.green,
                child: Text("data"),

              )
            ];*/
            setState(() {});
            isConnected.value = true;
            showLog(
                "main common appbar true data <> :: ${isConnected.value} :: $status");
          }
          break;
        case InternetConnectionStatus.disconnected:
          {
            actions = [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          /*border: Border.all(
                              color: Colors.red,
                              width: 2,
                            )*/
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                size: 20,
                                color: Colors.yellow,
                              ),
                              /*  CommonText(
                                text: " Offline",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.red),
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
            setState(() {});
            isConnected.value = false;
            showLog(
                "main common appbar false data >> :: ${isConnected.value} :: $status");
          }
          break;
        case InternetConnectionStatus.slow:
          // TODO: Handle this case.
          //throw UnimplementedError();
      }
    });
  }
}
