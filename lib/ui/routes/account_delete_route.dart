import 'package:flutter/material.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import '../../color_constants.dart';
import '../../core/constants/common_constants.dart';
import '../../core/services/api_helper.dart';
import '../../generated/i18n.dart';
import '../base/base_widget.dart';
import '../popup/logout_dialog.dart';
import '../shared_widgets/common_alert_dialog.dart';
import '../shared_widgets/common_button.dart';
import '../shared_widgets/common_circular_progress.dart';
import 'account_delete_route_view_model.dart';

class DeleteRoute extends StatefulWidget {
  final bool? isFromLogin;

  const DeleteRoute({super.key, this.isFromLogin});

  @override
  State<DeleteRoute> createState() => _DeleteRouteState();
}

class _DeleteRouteState extends State<DeleteRoute> {
  BaseWidget<DeleteRouteViewModel>? baseWidget;

  bool? login;

  final ValueNotifier<bool> deletedKey = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeletedKey();
    setState(() {});
  }

  getDeletedKey() async {
    /*login =
        await PreferenceHelper.getBool(isUserLoggedInPreferenceKey) ?? false;*/

    deletedKey.value = (widget.isFromLogin == true) ? true : false;
    //  await PreferenceHelper.getBool(isDeletedKey) ?? false;
  }

  Widget build(BuildContext context) {
    baseWidget = BaseWidget<DeleteRouteViewModel>(
        model: DeleteRouteViewModel(
          apiHandler: Provider.of<ApiHelper>(context, listen: false),
          context: context,
        ),
        onModelReady: (model) {
          model.accountDeletionData();
          //model.getInitialMediaData(widget.eventCode, widget.personCode);
        },
        builder: (context, model, child) {
          return SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: AppColorData.backgroundGradientBegin,
                        end: AppColorData.backgroundGradientEnd,
                        colors: AppColorData.backgroundColors)),
                child: Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: CommonAppBar(title: 'Delete this account'),
                    backgroundColor: Colors.transparent,
                    body: model.isLoading == false
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    size: 100,
                                    color: AppColorData.bgIconColor,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      ValueListenableBuilder<bool>(
                                          valueListenable: deletedKey,
                                          builder: (BuildContext context,
                                              bool value, Widget? child) {
                                            return !value
                                                ? Text(
                                                    'If you delete your account:',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    'You are requesting the deletion of your account.:',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  );
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: deletedKey,
                                            builder: (BuildContext context,
                                                bool value, Widget? child) {
                                              return !value
                                                  ? Text(
                                                      '        1. The account data will be deleted in 30 days ',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    )
                                                  : Text(
                                                      '         1. Your account deletion request is in process.',
                                                      style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    );
                                            }),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ValueListenableBuilder<bool>(
                                              valueListenable: deletedKey,
                                              builder: (BuildContext context,
                                                  bool value, Widget? child) {
                                                return !value
                                                    ? Text(
                                                        '        2.If you log in again, you will be able to cancel the account deletion..',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      )
                                                    : Text(
                                                        '        2. The account data will be deleted in ${model.daysCount} days ',
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      );
                                              })),
                                      SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ValueListenableBuilder<bool>(
                                          valueListenable: deletedKey,
                                          builder: (BuildContext context,
                                              bool value, Widget? child) {
                                            return !value
                                                ? CommonButton(
                                                    height: 70,
                                                    isOutLinedButton: true,
                                                    buttonText: 'Cancel',
                                                    onPressCall: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                : CommonButton(
                                                    height: 70,
                                                    isOutLinedButton: true,
                                                    buttonText:
                                                        'Cancel Deletion',
                                                    onPressCall: () async {
                                                      await model
                                                          .accountDeletionApiCall();
                                                      Navigator.pop(context);

                                                      /* Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context)=>HomeRoute()));*/
                                                    },
                                                  );
                                          }),
                                      ValueListenableBuilder<bool>(
                                          valueListenable: deletedKey,
                                          builder: (BuildContext context,
                                              bool value, Widget? child) {
                                            return !value
                                                ? TapDebouncer(onTap: () async {
                                                    await model
                                                        .accountDeletionStoreApiCall();
                                                    Navigator.pop(context);
                                                    removeValues(
                                                      context,
                                                    );
                                                  }, // your tap handler moved here
                                                    builder:
                                                        (BuildContext context,
                                                            TapDebouncerFunc?
                                                                onTap) {
                                                    return CommonButton(
                                                      height: 70,
                                                      buttonText: 'Continue',
                                                      onPressCall: onTap,
                                                    );
                                                  })
                                                : CommonButton(
                                                    height: 70,
                                                    buttonText: '    Ok    ',
                                                    onPressCall: () async {
                                                      removeValues(context);

                                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRoute(true)));
                                                    },
                                                  );
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : CommonCircularProgress())),
          );
        });
    return baseWidget!;
  }

  Future accountDeleteAlertDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CommonAlertDialog(
            title: 'Are you sure you want to delete your account',
            content:
                'If you delete your account, it will be deleted in 30 days unless you log in again.',
            actions: [
              ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? SizedBox()
                        : CommonButton(
                            isOutLinedButton: true,
                            buttonText: S.of(context)?.cancel,
                            onPressCall: () {
                              Navigator.pop(context);
                            },
                          );
                  }),
              ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? CommonCircularProgress()
                        : CommonButton(
                            buttonText: S.of(context)?.yes,
                            onPressCall: () async {
                              //removeValues(context);
                              isLoading.value = true;
                              await Future.delayed(Duration(seconds: 10));
                              Navigator.pop(context);
                              Navigator.pop(context);
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginRoute(true)));
                            },
                          );
                  })
            ],
          );
        });
  }
}
