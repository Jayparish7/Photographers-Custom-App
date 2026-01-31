import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/services/api_helper.dart';
import 'package:photomall_flutter/traits/common_widgets/cached_network_image_widget.dart';
import 'package:photomall_flutter/ui/base/base_widget.dart';
import 'package:photomall_flutter/ui/folders/model/person_selection_view_model.dart';
import 'package:photomall_flutter/ui/folders/selection_status_card.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_circular_progress.dart';
import 'package:provider/provider.dart';

class PersonPhotoSelections extends StatefulWidget {
  final String? code;
  final String? eventCode;
  final bool? withoutFace;
  final String? appbarTitle;

  PersonPhotoSelections({
    Key? key,
    this.code,
    this.eventCode,
    this.withoutFace,
    this.appbarTitle,
  }) : super(key: key);

  @override
  State<PersonPhotoSelections> createState() => _PersonPhotoSelectionsState();
}

class _PersonPhotoSelectionsState extends State<PersonPhotoSelections> {
  BaseWidget<PersonSelectionViewModel>? baseWidget;

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<PersonSelectionViewModel>(
      model: PersonSelectionViewModel(
        apiHandler: Provider.of<ApiHelper>(context, listen: false),
        context: context,
      ),
      onModelReady: (model) =>
          model.initialMethod(widget.code, widget.eventCode),
      builder: (context, model, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: AppColorData.backgroundGradientBegin,
                  end: AppColorData.backgroundGradientEnd,
                  colors: AppColorData.backgroundColors,
                  stops: AppColorData.appBackgroundStops)),
          child: (model.isLoading) ? CommonCircularProgress() : setView(model),
        );
      },
    );
    return baseWidget!;
  }

  setView(PersonSelectionViewModel model) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: (widget.appbarTitle != null) ? widget.appbarTitle : 'Person',
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              model.personImageURl.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0)),
                      child: Container(
                        color: AppColorData.appBarTextColor,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100.0)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .40,
                              height: MediaQuery.of(context).size.width * .40,
                              child: CustomCachedNetworkImageWidget(
                                url: model.personImageURl,
                                fitSize: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              photoSelectionCards(
                model,
                eventCode: widget.eventCode,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget photoSelectionCards(PersonSelectionViewModel model,
      {String? eventCode}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: photoSelectionCardWidget(
        isWithOutPersonSelection: widget.withoutFace == true,
        eventCode: eventCode,
        personCode: widget.code,
        key: UniqueKey(),
        folderCode: "",
        waitingCount: model.waiting,
        rejectedCount: model.rejected,
        selectedCount: model.selected,
        callBack: () async {
          if (widget.code != null) {
            await model.getPersonsList(widget.code!);
          } else {
            await model.getWithoutPersonsList(widget.eventCode!);
          }

          model.setBusy(false);
        },
      ),
    );
  }
}
