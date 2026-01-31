import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import '../../color_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import '../../core/constants/common_constants.dart';
import '../../core/models/apiModels/transport_model/transport_model.dart';
import '../shared_widgets/common_appbar.dart';

class ReviewPageRoute extends StatefulWidget {
  final List<Review> reviews;

  const ReviewPageRoute({super.key, required this.reviews});

  @override
  State<ReviewPageRoute> createState() => _ReviewPageRouteState();
}

class _ReviewPageRouteState extends State<ReviewPageRoute> {
  @override
  void initState() {
    // TODO: implement initState
    showLog('ReviewPageRoute ${widget.reviews}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AppColorData.backgroundGradientBegin,
              end: AppColorData.backgroundGradientEnd,
              colors: AppColorData.backgroundColors)),
      child: Scaffold(
        appBar: CommonAppBar(
          title: S.of(context).reviewsRatings,
        ),
        backgroundColor: Colors.transparent,
        body: ListView.builder(
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              DateTime dateTime =
                  DateTime.parse(widget.reviews[index].time!.toString());
              String formattedDate = DateFormat('yyyy-MMM-dd').format(dateTime);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Container(
                    width: 200,
                    child: Card(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 35,
                                  child: CustomCachedNetworkImageWidget(
                                      url: widget
                                          .reviews[index].profilePhotoUrl!),
                                ),
                              ),
                              Flexible(
                                  child: CommonText(
                                text: widget.reviews[index].authorName!,
                                style: TextStyle(
                                    color: AppColorData.appBarTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ))
                            ],
                          ),
                          Row(
                            children: [
                              PannableRatingBar(
                                spacing: 2,
                                rate: ((widget.reviews[index].rating!) / 10)
                                    .toDouble(),
                                items: List.generate(
                                    5,
                                    (index) => RatingWidget(
                                          selectedColor:
                                              AppColorData.appBarTextColor,
                                          unSelectedColor: Colors.grey,
                                          child: Icon(
                                            Icons.star,
                                            size: 18,
                                          ),
                                        )),
                                onChanged: (value) {
                                  // the rating value is updated on tap or drag.
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: CommonText(
                                  text: formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(.9),
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CommonText(
                                  text: widget.reviews[index].review!
                                      .replaceAll('\n', ''),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
