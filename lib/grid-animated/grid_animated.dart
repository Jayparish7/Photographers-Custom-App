import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photomall_flutter/ui/event/photos/photo_grid.dart';
import '../controllers/album_controller.dart';
import '../core/constants/common_constants.dart';
import '../core/constants/route_constants.dart';
import '../traits/common_widgets/cached_network_image_widget.dart';
import '../ui/event/photos/custom_photo_view.dart';
import '../ui/event/photos/photo_grid_view_model.dart';

class AnimatedMasonryGridView extends StatefulWidget {
  final List<ImagesViewModel?> photosList;
  final ScrollController scrollController;
  final Function scrollToIndex;
  final Function toggleSelection;
  final PhotoGridViewModel model;
  final PhotoGridArguments arguments;

  const AnimatedMasonryGridView({
    required this.photosList,
    required this.scrollController,
    required this.scrollToIndex,
    required this.toggleSelection,
    required this.model,
    required this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedMasonryGridViewState createState() =>
      _AnimatedMasonryGridViewState();
}

class _AnimatedMasonryGridViewState extends State<AnimatedMasonryGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.photosList.isNotEmpty)
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: MasonryGridView.builder(
                  controller: widget.scrollController,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 170),
                  itemCount: widget.photosList.length,
                  itemBuilder: (context, index) {
                    widget.scrollToIndex();

                    // Animate each grid item
                    final animation = Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (index / widget.photosList.length).clamp(0.0, 1.0),
                          1.0,
                          curve: Curves.easeOut,
                        ),
                      ),
                    );

                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: animation.value,
                          child: Transform.scale(
                            scale: animation.value,
                            child: child,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            widget.arguments.borderRadius),
                        child: InkWell(
                          onLongPress: () {
                            showLog(
                                'onLongPress $index ${widget.arguments.photoSelectionsSubmitStatus}');
                            (widget.arguments.folderCode != null &&
                                    !widget
                                        .arguments.photoSelectionsSubmitStatus)
                                ? widget.toggleSelection(index)
                                : null;
                          },
                          onTap: () async {
                            showLog(
                                'model.isSelectionMode ${widget.model.isSelectionMode}');
                            if (widget.model.selectedIndices.isNotEmpty &&
                                widget.model.isSelectionMode &&
                                widget.arguments.folderCode != null) {
                              widget.toggleSelection(index);
                            } else {
                              widget.model.isSelectionMode = false;
                            }
                            if (!widget.model.isSelectionMode) {
                              if (widget.arguments.folderCode == null) {
                                await widget.model.scrollOffsetManager
                                    .updateScrollOffset(
                                        widget.arguments.folderCode ??
                                            widget.arguments.albumCode ??
                                            widget.arguments.eventCode ??
                                            '',
                                        widget.model.scrollController.offset);
                                await widget.model.scrollIndexManager
                                    .updateScrollIndex(
                                        widget.arguments.folderCode ??
                                            widget.arguments.albumCode ??
                                            widget.arguments.eventCode ??
                                            '',
                                        index);
                                showLog(
                                    'widget.arguments?.eventCode ${widget.arguments.eventCode}');
                                Navigator.pushNamed(
                                    context, RoutePaths.CustomPhotoView,
                                    arguments: CustomPhotoViewArgument(
                                        preIndex: index,
                                        title: widget.arguments.appBarTitle,
                                        albumCode: widget.arguments.albumCode,
                                        eventCode: widget.arguments.eventCode,
                                        data: widget.photosList,
                                        publicStoragePath: widget
                                            .arguments.storagePath?.public,
                                        privateStoragePath: widget
                                            .arguments.storagePath?.private,
                                        documentPath: widget.arguments
                                            .storagePath?.DocumentPath,
                                        personCode:
                                            widget.arguments.personCode));
                              } else {
                                showLog(
                                    'photos length ==> ${widget.model.localPhotosList.value.length} ');
                                await widget.model.scrollOffsetManager
                                    .updateScrollOffset(
                                        widget.arguments.folderCode!,
                                        widget.model.scrollController.offset);
                                await widget.model.scrollIndexManager
                                    .updateScrollIndex(
                                        widget.arguments.folderCode!, index);

                                Navigator.pop(context, index);
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              CustomCachedNetworkImageWidget(
                                url: widget.photosList[index]!.url!,
                              ),
                              if (widget.model.selectedIndices.contains(index))
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        : const Center(
            child: Text('No photos available'),
          );
  }
}
