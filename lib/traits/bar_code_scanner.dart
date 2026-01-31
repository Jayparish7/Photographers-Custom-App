import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as google;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';

class BarcodeScannerWithController extends StatefulWidget {
  final Function scannedValue;

  BarcodeScannerWithController({Key? key, required this.scannedValue})
      : super(key: key);

  @override
  _BarcodeScannerWithControllerState createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController>
    with SingleTickerProviderStateMixin {
  String? barcodeCaptured;
  var flashIcon = Icons.flash_off.obs;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    facing: CameraFacing.back,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.15,
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: MobileScanner(
                        controller: controller,
                        fit: BoxFit.cover,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          //final Uint8List? image = capture.image;
                          for (final barcode in barcodes) {
                            debugPrint('Barcode found! ${barcode.rawValue}');
                            if (barcode.rawValue != null) {
                              barcodeCaptured = barcode.rawValue!;
                            }
                          }
                          if (barcodeCaptured != null &&
                              barcodeCaptured!.isNotEmpty) {
                            setState(() {
                              widget.scannedValue(barcodeCaptured);
                            });
                          }
                          /*
                          setState(() {
                            // validate 4 to 10 digit
                           int  length = barcodes.raw.toString().length;
                           showLog("the scanned vale ${length}");
                           showLog("the scanned vale ${barcodes.raw[0]}");
                          //  this.barcode = barcodes.raw;
                           //   widget.scannedValue(barcode);
                         //  }
                          });
                        */
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: Obx(() => IconButton(
                                  color: AppColorData.iconColor,
                                  icon: Icon(
                                    flashIcon.value,
                                    color: AppColorData.iconColor,
                                  ),
                                  iconSize: 32.0,
                                  onPressed: () {
                                    flashIcon.value =
                                        flashIcon.value == Icons.flash_off
                                            ? Icons.flash_on
                                            : Icons.flash_off;
                                    controller.toggleTorch();
                                  },
                                )),
                          ),
                          /*IconButton(
                                color: Colors.white,
                                icon: isStarted
                                    ? const Icon(Icons.stop)
                                    : const Icon(Icons.play_arrow),
                                iconSize: 32.0,
                                onPressed: () => setState(() {
                                  isStarted ? controller.stop() : controller.start();
                                  isStarted = !isStarted;
                                }),
                              ),
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 200,
                                  height: 50,
                                  child: FittedBox(
                                    child: Text(
                                      barcode ?? 'Scan something!',
                                      overflow: TextOverflow.fade,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),*/
                          Center(
                            child: IconButton(
                              color: AppColorData.iconColor,
                              icon: Icon(Icons.cameraswitch,
                                  color: AppColorData.iconColor),
                              iconSize: 32.0,
                              onPressed: () => controller.switchCamera(),
                            ),
                          ),
                          Center(
                            child: IconButton(
                              color: AppColorData.iconColor,
                              icon: const Icon(Icons.image_outlined),
                              iconSize: 32.0,
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                // Pick an image
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  _pickImageAndScan(image);

                                  showLog("image found");
                                  showLog("image found ${image.path}");
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: CommonText(
                                      text: S.of(context).barcodeFound,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickImageAndScan(XFile? image) async {

    if (image == null) return;

    final File imageFile = File(image.path);
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final google.BarcodeScanner barcodeScanner = google.BarcodeScanner();

    try {
      final List<google.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        setState(() {
          barcodeCaptured = barcodes.first.rawValue ?? "No barcode found";
          widget.scannedValue(barcodeCaptured);
        });
      } else {
        setState(() {
          barcodeCaptured = "No barcode detected";
        });
      }
    } catch (e) {
      setState(() {
        barcodeCaptured = "Error scanning barcode: $e";
      });
    } finally {
      barcodeScanner.close();
    }
  }
}
