import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pepli/models/models.dart';
import 'package:pepli/modules/modules.dart';
import 'package:pepli/modules/user_profile/user_profile_individual/creativePlay/cubit/creativeplay_cubit.dart'
    show ScheduleListingCubit, ScheduleListingState;
import 'package:pepli/modules/user_profile/user_profile_individual/scheduleView/cubit/schedule_cubit.dart';
import 'package:pepli/utils/foundation_helper_extension.dart';
import 'package:pepli/utils/ui_helper_extension.dart';
import 'package:pepli/widgets/app_back_button.dart';
import 'package:pepli/widgets/progress_hud.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../../../utils/localization_helper.dart';
import '../../../../../utils/text_style.dart';
import '../../creativePlay/models/creativeplay_response.dart'
    show CreativePlayResponse;
import '../../scheduleView/models/schedule_response.dart';
import '../cubit/schedule_listing_cubit.dart';
import '../models/schedule_listing_response.dart';
import 'addScheduleListingPage.dart';
import '../../creativePlay/view/add_creativeplay_page.dart';
import '../../creativePlay/view/creativeplaydetails_page.dart';

extension on BuildContext {
  ScheduleListingCubit get cubit => read();
}

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage({super.key, required this.isEdit});

  final bool isEdit;

  // CreativePlayResponse? CreativePlay;

  static Route route({
    required bool isEdit,
    required String userId,
    required bool isCurrentUser,
    List<ScheduleListingResponse>? scheduleResponse,
  }) {
    return MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ScheduleListingCubit(userId, isCurrentUser)
              ..refreshScheduleList(scheduleResponse),
            // ..fetchListingScheduleList(CreativePlay?.id??""),
          )

          // BlocProvider(create: (context) => ScheduleCubit(userId:userId, isCurrentUser:isCurrentUser)),
          //   ..fillData(CreativePlay),
          // ..fetchCreativePlayList(),
        ],
        child: ScheduleListPage(
          isEdit: isEdit,
          // CreativePlay: CreativePlay,
        ),
      ),
    );
  }

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> with RouteAware {
  final _pagingController =
  PagingController<int, ScheduleListingResponse>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    //final state = context.cubit.state;
    // if (state.errorMessage != null) {
    //   _pagingController.error = state.errorMessage;
    // } else {
    //   _pagingController.itemList = state.scheduleListingList;
    //   _pagingController.nextPageKey = state.pagination.nextPage;
    // }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }

  @override
  void didPopNext() {
    // 👇 Called every time you return to this page
    showLog("user profile resumed, refreshing feed...");
    // context.cubit.fetchCreativePlayList();
    // If you also want to reset pagination:
    //_pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      // ProgressHUD(
      //   isShowingInitial: true,
      //   child:
      BlocBuilder<ScheduleListingCubit, ScheduleListingState>(
          buildWhen: (previous, current) =>
          current.scheduleListingList != previous.scheduleListingList ||
              current.isCurrentUser != previous.isCurrentUser,
          builder: (context, state) {
            // final creativePlayList= state.scheduleListingList[0];
            showLog(
                "----======------inside list view----------=====-checkdata${state.scheduleListingList}");

            return WillPopScope(
              onWillPop: () async {
                context.navigateBack(json.encode(context.cubit.state
                    .scheduleListingList)); // prevent default pop since we already handled it
                return true;
              },
              child: Scaffold(
                  appBar: AppBar(
                    leading: AppBackButton(
                      onTap: () {
                        showLog(
                            " AppBackButton scheduleListingList ${context.cubit.state.scheduleListingList.length}");
                        context.navigateBack(json
                            .encode(context.cubit.state.scheduleListingList));
                      },
                    ),
                    title: Text("Schedule List"),
                    actions: [
                      state.isCurrentUser
                          ? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          //final cubit = context.read<ScheduleListingCubit>();

                          final result = await context
                              .navigateTo(AddListingSchedulePage.route(
                            // creativePlayId: widget.CreativePlay!.id,
                            isEdit: false,
                            userId: state.userId!,
                            isCurrentUser: state.isCurrentUser,
                            cubit: context.cubit,
                          ));
                          if (result == true) {
                            print(
                                "setState state.scheduleListingList ${context.cubit.state.scheduleListingList.length}");
                            // optional — just forces rebuild
                            context.cubit.refreshScheduleList(context
                                .cubit.state.scheduleListingList);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.add_circle,
                            color: context.theme.appColors.primary,
                            size: AppSize.s28,
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                  body:
                  //(state.status.isInProgress)
                  //     ? Container(
                  //         color: Colors.white,
                  //         height: 300,
                  //         child: Center(
                  //             // child: CircularProgressIndicator(),
                  //             ))
                  //     : state.CreativePlayList.isEmpty
                  //         ? Center(
                  //             child: Text("No data found"),
                  //           )
                  //         :
                  RefreshIndicator(
                      onRefresh: () async {
                        //context.cubit.fetchCreativePlayList();
                      },
                      child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          // physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBoxConstants.h8;
                          },
                          shrinkWrap: true,
                          itemCount: state.scheduleListingList.length,
                          itemBuilder: (context, int index) {
                            final scheduleList =
                            state.scheduleListingList[index];

                            return GestureDetector(
                                onTap: () async {
                                  // final creativePlayList =
                                  // state.CreativePlayList[index];
                                  // await context.navigateTo(
                                  //     CreativePlayDetailsPage.route(
                                  //   isEdit: true,
                                  //   creativePlay: creativePlayList,
                                  //   userId: state.userId!,
                                  //   isCurrentUser: state.isCurrentUser,
                                  // ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: AppPadding.p8,
                                      right: AppPadding.p8,
                                      top: AppPadding.p8,
                                      bottom: AppPadding.p8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSize.s8),
                                      border: Border.all(
                                        color: ColorManager.gray7,
                                        width: AppSize.s0_5,
                                      )),
                                  width: double.infinity,
                                  child:
                                  // Card(
                                  // elevation: 1,
                                  // semanticContainer: true,
                                  // shadowColor: ColorManager.primary,
                                  // color: ColorManager.white,
                                  // margin: const EdgeInsets.only(
                                  //     left: AppPadding.p16,
                                  //     right: AppPadding.p16,
                                  //     top: AppPadding.p8,
                                  //     bottom: AppPadding.p8),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 5.0),
                                                child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              softWrap: true,
                                                              overflow:
                                                              TextOverflow
                                                                  .visible,

                                                              "${_convertStringToDate(scheduleList.startDate.toString())?.toLocal().toFormatString("dd MMM")} - ${_convertStringToDate(scheduleList.endDate.toString())?.toLocal().toFormatString("dd MMM")}",

                                                              // "${scheduleList.startDate} - ${scheduleList.endDate}",
                                                              style:
                                                              TextStyleManager
                                                                  .semiBold(
                                                                fontSize:
                                                                FontSize
                                                                    .s14,
                                                                color:
                                                                ColorManager
                                                                    .black1,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  final result =
                                                                  await context
                                                                      .navigateTo(AddListingSchedulePage.route(
                                                                    // creativePlayId:
                                                                    //     widget
                                                                    //         .CreativePlay!
                                                                    //         .id,
                                                                    scheduleItem:
                                                                    scheduleList,
                                                                    isEdit:
                                                                    false,
                                                                    userId: state
                                                                        .userId!,
                                                                    isCurrentUser:
                                                                    state
                                                                        .isCurrentUser,
                                                                  ));
                                                                  // context.cubit
                                                                  //     .fetchListingScheduleList(
                                                                  //     widget.CreativePlay!.id);
                                                                },
                                                                child:
                                                                const Icon(
                                                                  Icons.edit,
                                                                  size: 21,
                                                                  color: ColorManager
                                                                      .primary,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  final confirm =
                                                                  await showAdaptiveDialog<
                                                                      bool>(
                                                                    context:
                                                                    context,
                                                                    builder:
                                                                        (_) =>
                                                                        AlertDialog(
                                                                          title: const Text(
                                                                              "Delete"),
                                                                          content:
                                                                          const Text("Are you sure you want to delete this schedule?"),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed:
                                                                                  () {
                                                                                context.navigateBack(false);
                                                                              },
                                                                              child:
                                                                              const Text("Cancel"),
                                                                            ),
                                                                            TextButton(
                                                                              onPressed:
                                                                                  () async {
                                                                                context.navigateBack(true);
                                                                              },
                                                                              child:
                                                                              const Text(
                                                                                "Delete",
                                                                                style: TextStyle(color: Colors.red),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                  );

                                                                  if (confirm ==
                                                                      true &&
                                                                      context
                                                                          .mounted) {
                                                                    await context
                                                                        .cubit
                                                                        .deleteSchedule(
                                                                        index);
                                                                    context.showSnackBar(
                                                                        "Deleted successfully");
                                                                  }
                                                                },
                                                                child:
                                                                const Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: AppPadding
                                                                          .p6),
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    size: 23,
                                                                    color: ColorManager
                                                                        .red,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      Text(
                                                        softWrap: true,
                                                        // ✅ allow wrapping
                                                        overflow: TextOverflow
                                                            .visible,
                                                        "${scheduleList.startTime} - ${scheduleList.endTime}",
                                                        // ? "10:00 AM - 1:00PM, 4:00 PM - 6:00 PM, 8:00 - 10 PM"
                                                        // : "3:00 AM - 5:00PM, 6:00 PM - 8:00 PM",
                                                        style:
                                                        TextStyleManager
                                                            .medium(
                                                          fontSize:
                                                          FontSize.s12,
                                                          color: ColorManager
                                                              .black1,
                                                        ),
                                                      ),
                                                      Text(
                                                        softWrap: true,
                                                        // ✅ allow wrapping
                                                        overflow: TextOverflow
                                                            .visible,
                                                        "${scheduleList.recurrence?.byDays?.join(", ")}",
                                                        // ? "10:00 AM - 1:00PM, 4:00 PM - 6:00 PM, 8:00 - 10 PM"
                                                        // : "3:00 AM - 5:00PM, 6:00 PM - 8:00 PM",
                                                        style:
                                                        TextStyleManager
                                                            .medium(
                                                          fontSize:
                                                          FontSize.s12,
                                                          color: ColorManager
                                                              .black1,
                                                        ),
                                                      ),
                                                    ]),
                                              )),
                                        ]),
                                  ),
                                ));
                          }))),
            );
          });
    // );
  }

//   },
// ),

//   Scaffold(
//   appBar: AppBar(
//     leading: const AppBackButton(),
//     title: const Text("Creative Play"),
//   ),
//   body:
//   BlocConsumer<ScheduleListingCubit, ScheduleListingState>(
//       listenWhen: (previous, current) =>
//           previous.CreativePlayList != current.CreativePlayList ||
//           previous.status != current.status,
//       listener: (context, state) {
//         context.handleStatus(
//           formStatus: state.status,
//           validationStatus: false,
//           skipValidationStatus: true,
//           popCurrentPage: false,
//         );
//         if (state.errorMessage != null) {
//           _pagingController.error = state.errorMessage;
//         } else {
//           _pagingController.itemList = state.CreativePlayList;
//           _pagingController.nextPageKey = state.pagination.nextPage;
//         }
//       },
//       buildWhen: (previous, current) =>
//           previous.CreativePlayList != current.CreativePlayList ||
//           previous.status != current.status,
//       builder: (context, state) {
//         return   Expanded(child: ListView.builder(
//             itemCount: 2,
//             itemBuilder: (context, index){
//               return Card(
//                 elevation: 1,
//                 semanticContainer: true,
//                 shadowColor: ColorManager.primary,
//                 color: ColorManager.white,
//                 margin: const EdgeInsets.only(
//                     left: AppPadding.p16,
//                     right: AppPadding.p16,
//                     top: AppPadding.p8,
//                     bottom: AppPadding.p8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SquareUserAvatar(
//                         ignore: true,
//                         imageUrl: "",
//                         isCurrentUser: false,
//                         userId: "",
//                         width: AppSize.s60,
//                         height: AppSize.s70,
//                         radius: AppSize.s4,
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Amy Gray",
//                                         style: TextStyleManager.semiBold(
//                                           fontSize: FontSize.s14,
//                                           color: ColorManager.black1,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: AppPadding.p4,right: AppPadding.p4),
//                                         child: SuperTooltip(
//                                           hideTooltipOnTap: true,
//                                           showBarrier: true,
//                                           shadowColor: Colors.transparent,
//
//                                           controller: SuperTooltipController(),
//                                           hideTooltipOnBarrierTap: true,
//                                           showCloseButton: true,
//                                           closeButtonSize: AppSize.s24,
//                                           backgroundColor: ColorManager.white,
//                                           content: Container(
//                                             constraints: BoxConstraints(
//                                               // Set max width based on screen size
//                                               maxWidth: screenWidth * 0.8,
//                                               // Set max height so that tooltip does not overflow
//                                               maxHeight:
//                                               MediaQuery.of(context)
//                                                   .size
//                                                   .height *
//                                                   0.5,
//                                             ),
//                                             padding: const EdgeInsets.only(
//                                                 top: AppSize.s4),
//                                             child: const SingleChildScrollView(
//                                               child: Text(
//                                                 "",
//                                                 softWrap: true,
//                                                 style: TextStyle(
//                                                     color: ColorManager.gray1,
//                                                     fontSize: 12),
//                                               ),
//                                             ),
//                                           ),
//                                           child: const Icon(
//                                             Icons.info_outline,
//                                             size: AppSize.s16,
//                                             color: ColorManager.gray1,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     "07 Jul, 2025",
//                                     style: TextStyleManager.regular(
//                                       fontSize: FontSize.s14,
//                                       color: ColorManager.gray5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "3D Animator",
//                                     style: TextStyleManager.semiBold(
//                                       fontSize: FontSize.s14,
//                                       color: ColorManager.gray5,
//                                     ),
//                                   ),
//                                   Text(
//                                     "10:00PM EST",
//                                     style: TextStyleManager.regular(
//                                       fontSize: FontSize.s14,
//                                       color: ColorManager.black1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "ABC Talent Agency",
//                                         style: TextStyleManager.regular(
//                                           fontSize: FontSize.s14,
//                                           color: ColorManager.gray5,
//                                         ),
//                                       ),
//                                       Text(
//                                         "Audition - Self-Tape",
//                                         style: TextStyleManager.regular(
//                                           fontSize: FontSize.s14,
//                                           color: ColorManager.black1,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.edit,size: 21,color: ColorManager.primary,),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: AppPadding.p6),
//                                         child: Icon(Icons.delete,size: 23,color: ColorManager.red,),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//         ));
//
//         //   Padding(
//         //   padding: PaddingConstants.screenPadding,
//         //   child: RefreshIndicator(
//         //     onRefresh: () async {
//         //       // context.cubit.fetchVolunteerExperienceList();
//         //     },
//         //     child: PagedListView.separated(
//         //       separatorBuilder: (context, index) => SizedBoxConstants.h8,
//         //       pagingController: _pagingController,
//         //       builderDelegate:
//         //           PagedChildBuilderDelegate<CreativePlayResponse?>(
//         //         firstPageErrorIndicatorBuilder: (context) =>
//         //             const Center(child: Text('Failed to load Creative Play.')),
//         //         noItemsFoundIndicatorBuilder: (context) =>
//         //             const Center(child: Text('No Creative Play available.')),
//         //         itemBuilder: (context, volunteer, index) {
//         //           if (volunteer == null) return const SizedBox.shrink();
//         //
//         //           return CreativePlayItemView(
//         //             CreativePlay: state.CreativePlayList[index],
//         //             onDelete: (String id) {
//         //               // context.cubit.deleteVolunteer(id);
//         //             },
//         //             isFromEdit: state.isCurrentUser,
//         //             onEdit: (String id) async {
//         //               await context.navigateTo(
//         //                 AddCreativePlayPage.route(
//         //                   userId: id,
//         //                   isCurrentUser: state.isCurrentUser,
//         //                   creativePlay: state.CreativePlayList[index],
//         //                 ),
//         //               );
//         //               if (context.mounted) {
//         //                 // context.cubit.fetchVolunteerExperienceList();
//         //               }
//         //             },
//         //           );
//         //         },
//         //       ),
//         //     ),
//         //   ),
//         // );
//       },
//     ),
//
// );
}

DateTime? _convertStringToDate(String? date) {
  print("start date: $date");
  if (date == null || date.isEmpty) return null;

  try {
    // 1. Try ISO8601 parse first (works for most APIs)
    return DateTime.parse(date);
  } catch (_) {
    // 2. If fails, try custom formats
    final possibleFormats = [
      "MM/dd/yyyy HH:mm:ss",
      "MM/dd/yyyy hh:mm:ss a",
      "yyyy-MM-dd HH:mm:ss",
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
      "yyyy-MM-dd'T'HH:mm:ss",
    ];

    for (var format in possibleFormats) {
      try {
        return DateFormat(format).parse(date);
      } catch (_) {
        // keep trying
      }
    }
  }

  print("⚠️ Could not parse date: $date");
  return null;
}
