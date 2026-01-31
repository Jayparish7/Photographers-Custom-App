import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:photomall_flutter/color_constants.dart';

import '../../core/constants/studio_config_constants.dart';

class BirthdayWishScreen extends StatefulWidget {
  final String userName;
  final bool birthdayWish;

  const BirthdayWishScreen(
      {Key? key, required this.userName, required this.birthdayWish})
      : super(key: key);

  @override
  _BirthdayWishScreenState createState() => _BirthdayWishScreenState();
}

class _BirthdayWishScreenState extends State<BirthdayWishScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[20],
      body: Stack(
        children: [
          // Background Confetti
          Positioned(
              top: 45,
              right: 25,
              child: Container(
                decoration: BoxDecoration(
                    color: AppColorData.appBarTextColor,
                    borderRadius: BorderRadius.circular(100)),
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColorData.backgroundColors.first,
                    )),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.pink,
                Colors.orange
              ],
              numberOfParticles: 50,
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cake Image
                  Image.asset(
                    widget.birthdayWish
                        ? 'assets/images/birthday_cake.png'
                        : 'assets/images/anniversary_heart.png',
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  // Greeting Card
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            widget.birthdayWish
                                ? "Happy Birthday, ${widget.userName}!"
                                : "Happy Anniversary,",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColorData.appBarTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.birthdayWish
                                ? "Wishing you a day filled with love, joy, and amazing surprises!"
                                : "Wishing you both a lifetime of love, happiness, and cherished moments together.",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColorData.appBarTextColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "- From all of us at ${appName}",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.normal,
                              color: Colors.red[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Action Button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
