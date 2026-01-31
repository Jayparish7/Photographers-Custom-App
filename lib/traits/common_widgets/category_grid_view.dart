import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/driftdb/app_db.dart' as appDb;
import 'package:photomall_flutter/driftdb/dao/event_dao.dart' as eventDao;
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/traits/common_widgets/common_card.dart';
import 'package:photomall_flutter/traits/image_processor.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class CategoryViewWidget extends StatefulWidget {
  CategoryViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryViewWidget> createState() => _CategoryViewWidgetState();
}

class _CategoryViewWidgetState extends State<CategoryViewWidget> {
  ImageProcessor imageProcessor = ImageProcessor();
  List<CategoryList> categoryList = [];
  Stream<List<appDb.Event>>? events;

  @override
  void initState() {
    prepareCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return events == null
        ? SizedBox()
        : Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: CommonCard(
                    shape: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CommonText(
                              isCard: true,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.normal,
                              text: S.of(context).category,
                              // fontSize: TextProperty.hint
                            ),
                          ),
                        ),
                        Icon(
                          Icons.filter_alt,
                          size: 20,
                          color: AppColorData.cardNormalIconColour,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showLog("Category list view :: pressed");
                    Navigator.pushNamed(context, RoutePaths.CategoryList);
                  },
                ),
              ],
            ),
          );
  }

  void prepareCategoryList() {
    eventDao.EventModelDao eventModelDao = eventDao.EventModelDao();
    // get gallery events
    events = eventModelDao.streamGalleryEvent();
  }
}

class CategoryList {
  CategoryList({this.name, this.eventCode});

  String? name;
  String? eventCode;

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        name: json["name"],
        eventCode: json["eventCode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "eventCode": eventCode,
      };
}
