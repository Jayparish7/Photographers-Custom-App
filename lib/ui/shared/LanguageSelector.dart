import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/Utils/toast_util.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';
import 'package:photomall_flutter/core/constants/route_constants.dart';
import 'package:photomall_flutter/core/constants/shared_preference_constants.dart';
import 'package:photomall_flutter/generated/l10n.dart';
import 'package:photomall_flutter/ui/drawer/home_route.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_appbar.dart';
import 'package:photomall_flutter/ui/shared_widgets/common_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../traits/common_widgets/custom_transition_widget.dart';
import '../settings/version_info_settings.dart';

class LanguageSelector extends StatefulWidget {
  final bool? needToShowDoneButton;
  final LanguageSelectorArguments? arguments;

  LanguageSelector({this.needToShowDoneButton = false, this.arguments});

  @override
  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  int? languageIndex;
  List<CompanyLanguage> _listItem = [];
  String deviceLocale = "en";

  void initState() {
    super.initState();
    _listItem.add(CompanyLanguage(
      name: "বাংলা",
      firstLetter: "ক",
      symbol: "bn",
      description: 'Bengali',
    ));
    _listItem.add(CompanyLanguage(
        name: "English",
        firstLetter: "A",
        symbol: "en",
        description: "English"));
    _listItem.add(CompanyLanguage(
      name: "Français",
      firstLetter: "un",
      symbol: "fr",
      description: 'French',
    ));
    _listItem.add(CompanyLanguage(
        name: "ગુજરાતી",
        firstLetter: "એ",
        symbol: "gu",
        description: "Gujarati"));
    _listItem.add(CompanyLanguage(
      name: "हिन्दी",
      firstLetter: "ए",
      symbol: "hi",
      description: 'Hindi',
    ));
    _listItem.add(CompanyLanguage(
      name: "ಕನ್ನಡ",
      firstLetter: "ಎ",
      symbol: "kn",
      description: 'Kannada',
    ));
    _listItem.add(CompanyLanguage(
      name: "മലയാളം",
      firstLetter: "എ",
      symbol: "ml",
      description: 'Malayalam',
    ));
    _listItem.add(CompanyLanguage(
      name: "मराठी",
      firstLetter: "ए",
      symbol: "mr",
      description: 'Marathi',
    ));
    _listItem.add(CompanyLanguage(
      code: "5fuyxulp",
      name: "தமிழ்",
      firstLetter: "அ",
      symbol: "ta",
      description: 'Tamil',
    ));
    _listItem.add(CompanyLanguage(
      name: "తెలుగు",
      firstLetter: "ఎ",
      symbol: "te",
      description: 'Telugu',
    ));
    _listItem.add(CompanyLanguage(
      name: "Malay",
      firstLetter: "B",
      symbol: "ms",
      description: 'Malay',
    ));

    setLanguageSelectedIndex();
  }

  setLanguageSelectedIndex() async {
    var prefs = await SharedPreferences.getInstance();
    var selectedValue = prefs.getInt("value");
    showLog("selected value : $selectedValue");
    setState(() {
      languageIndex = selectedValue;
    });
    deviceLocale = await Devicelocale.currentLocale ?? 'en-In';
    showLog("deviceLocale is $deviceLocale");
  }

  getSelectedRadioButtonValue() async {
    var prefs = await SharedPreferences.getInstance();
    var selectedValue = prefs.getInt("value");
    showLog("selected value : $selectedValue");
    setState(() {
      languageIndex = selectedValue ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // Adjust height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: AppColorData.backgroundGradientBegin,
          end: AppColorData.backgroundGradientEnd,
          colors: AppColorData.backgroundColors,
          stops: AppColorData.appBackgroundStops,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).select_language,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColorData.appBarTextColor,
              ),
            ),
          ),
          Divider(),

          // Scrollable Language List
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _listItem.length,
              itemBuilder: (context, index) {
                final language = _listItem[index];
                return ListTile(
                  leading: Checkbox(
                    activeColor: AppColorData.appBarTextColor,
                    value:
                        _listItem[languageIndex ?? 1].symbol == language.symbol,
                    onChanged: (bool? selected) {
                      if (selected == true) {
                        languageIndex = index;
                        _onItemClick();
                        setState(() {});
                        // Close bottom sheet after selection
                      }
                    },
                  ),
                  title: Text(language.name!),
                  subtitle:
                      !deviceLocale.contains(_listItem[index].symbol ?? '')
                          ? Text(language.description!)
                          : Text("(device's language)"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  languageGridList() {
    return GridView.count(
      childAspectRatio:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 2,
      crossAxisCount:
          MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
      children: List.generate(_listItem.length, (index) {
        showLog("language: => $languageIndex");

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: listItems(_listItem[index], index: index),
        );
      }),
    );
  }

  Widget listItems(CompanyLanguage companyLanguage, {int index = 0}) {
    showLog("language: => $languageIndex");
    return Opacity(
      opacity: languageIndex == index ? 1.0 : 1.0,
      child: MaterialButton(
          padding: EdgeInsets.all(0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: AppColorData.cardElevation,
          color: languageIndex == index
              ? AppColorData.selectedCardBackgroundColor.withOpacity(0.4)
              : AppColorData.cardBackgroundColors[0],
          onPressed: () async {
            showLog("language pressed $index");
            if (widget.arguments!.needToShowDoneButton == false) {
              if (languageIndex != index) {
                setState(() => languageIndex = index);
                _onItemClick();
              }
            } else {
              setState(() {
                languageIndex = index;
                _onItemClickMainPage();
              });

              Navigator.pushReplacementNamed(context, RoutePaths.Home);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColorData.bgIconBackgroundColor,
                      begin: AppColorData.bgIconGradientBegin,
                      end: AppColorData.bgIconGradientEnd,
                      stops: AppColorData.bgIconStops,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonText(
                    text: companyLanguage.firstLetter ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    isHeadingHighlightText: true,
                  ),
                ),
              ),
              CommonText(
                text: companyLanguage.name!,
                color: AppColorData.titleTextColor,
                style: Theme.of(context).textTheme.titleMedium,
                //fontSize: TextProperty.p1,
              ),
            ],
          )),
    );
  }

  _onItemClick() async {
    showLog('_onItemClick called ');
    showLog("initially open toast 1");
    CompanyLanguage companyLanguage = _listItem[languageIndex!];
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('value', languageIndex!);
    prefs.setString(languageSymbolPreferenceKey, companyLanguage.symbol!);
    prefs.setString(languageCodePreferenceKey, companyLanguage.code ?? '');
    showLog("Language code in language selector : ${companyLanguage.symbol}");
    updateLocale(companyLanguage.symbol!);
    Navigator.pop(context);

    showSnackBar(companyLanguage.symbol!, false);
  }

  _onItemClickMainPage() async {
    showLog('_onItemClickMainPage called');
    showLog("initially open toast 2");
    CompanyLanguage companyLanguage = _listItem[languageIndex!];
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('value', languageIndex!);
    prefs.setString(languageSymbolPreferenceKey, companyLanguage.symbol!);
    prefs.setString(languageCodePreferenceKey, companyLanguage.code ?? '');
    showLog("Language code in language selector : ${companyLanguage.symbol}");
    updateLocale(companyLanguage.symbol!);
    showSnackBar(companyLanguage.symbol!, true);
    return;
  }

  Widget languagesList() {
    return Column(
      children: <Widget>[
        listOfLanguages("Bengali (বাংলা)", 1, "bn"),
        listOfLanguages("English", 2, "en"),
        listOfLanguages("French (Français)", 3, "fr"),
        listOfLanguages("Gujarati (ગુજરાતી)", 4, "gu"),
        listOfLanguages("Hindi (हिन्दी)", 5, "hi"),
        listOfLanguages("kannada (ಕನ್ನಡ)", 6, "kn"),
        listOfLanguages("Malayalam (മലയാളം)", 7, "ml"),
        listOfLanguages("Marathi (मराठी)", 8, "mr"),
        listOfLanguages("Tamil (தமிழ்)", 9, "ta"),
        listOfLanguages("Telugu (తెలుగు)", 10, "te"),
        listOfLanguages("Malay (malay)", 11, "ms"),
      ],
    );
  }

  void updateLocale(String language) async {
    showLog(" inside update for $language");
    try {
      setState(() {
        S.load(Locale(language));
      });
    } catch (e) {
      showLog("exception in languages $e");
    }
  }

  showSnackBar(String languageCode, bool isFistTime) {
    ToastContext().init(context);
    ToastUtil toastUtil = ToastUtil();
    if (languageCode == "bn") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "ভাষা সফলভাবে নির্বাচিত হয়েছে৷");
      } else {
        toastUtil.showShortToast(context, "ভাষা সফলভাবে পরিবর্তিত হয়েছে.");
      }
    } else if (languageCode == "en") {
      if (isFistTime == true) {
        toastUtil.showShortToast(context, "Language selected successfully.");
      } else {
        toastUtil.showShortToast(context, "Language changed successfully.");
      }
    } else if (languageCode == "fr") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "Langue sélectionnée avec succès.");
      } else {
        toastUtil.showShortToast(
            context, "La langue a été modifiée avec succès.");
      }
    } else if (languageCode == "gu") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "ભાષા સફળતાપૂર્વક પસંદ કરી.");
      } else {
        toastUtil.showShortToast(context, "ભાષા સફળતાપૂર્વક બદલાઈ.");
      }
    } else if (languageCode == "hi") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "भाषा सफलतापूर्वक चुनी गई।");
      } else {
        toastUtil.showShortToast(context, "भाषा सफलतापूर्वक बदली गई।");
      }
    } else if (languageCode == "kn") {
      if (isFistTime) {
        toastUtil.showShortToast(
            context, "ಭಾಷೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಆಯ್ಕೆ ಮಾಡಲಾಗಿದೆ.");
      } else {
        toastUtil.showShortToast(
            context, "ಭಾಷೆಯನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಯಿಸಲಾಗಿದೆ.");
      }
    } else if (languageCode == "ml") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "ഭാഷ വിജയകരമായി തിരഞ്ഞെടുത്തു.");
      } else {
        toastUtil.showShortToast(context, "ഭാഷ വിജയകരമായി മാറ്റി.");
      }
    } else if (languageCode == "mr") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "भाषा यशस्वीरित्या निवडली.");
      } else {
        toastUtil.showShortToast(context, "भाषा यशस्वीरित्या बदलली.");
      }
    } else if (languageCode == "ta") {
      if (isFistTime) {
        toastUtil.showShortToast(
            context, "மொழி வெற்றிகரமாக தேர்ந்தெடுக்கப்பட்டது.");
      } else {
        toastUtil.showShortToast(
            context, "வெற்றிகரமாக மொழி மாற்றியமைக்கப்பட்டது.");
      }
    } else if (languageCode == "te") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "భాష విజయవంతంగా ఎంపిక చేయబడింది.");
      } else {
        toastUtil.showShortToast(context, "భాష విజయవంతంగా మార్చబడింది.");
      }
    } else if (languageCode == "ms") {
      if (isFistTime) {
        toastUtil.showShortToast(context, "Bahasa dipilih dengan berjaya.");
      } else {
        toastUtil.showShortToast(context, "Bahasa berjaya ditukar.");
      }
    }
  }

  Widget listOfLanguages(String languageName, int value, String languageCode) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Radio(
              activeColor: Colors.black,
              value: value,
              groupValue: languageIndex,
              onChanged: (int? i) async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setInt('value', value);
                showLog("Language code in language selector : $languageCode");
                updateLocale(languageCode);
                setState(
                  () => languageIndex = i,
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeRoute()),
                    ModalRoute.withName("/home"));
                showLog("initially open tost 3");
                showSnackBar(languageCode, false);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: CommonText(
            text: languageName,
            style: Theme.of(context).textTheme.titleMedium,
            // fontSize: TextProperty.p1,
          ),
        ),
      ],
    );
  }
}

class ListItemModel {
  String? language;
  String? languageSymbol;
  Color? backgroundColor;
  String? languageCode;

  ListItemModel(
      {this.language,
      this.languageSymbol,
      this.backgroundColor,
      this.languageCode});
}

class CompanyLanguage {
  CompanyLanguage({
    this.code,
    this.name,
    this.symbol,
    this.firstLetter,
    this.description,
  });

  String? code;
  String? name;
  String? symbol;
  String? firstLetter;
  String? description;

  factory CompanyLanguage.fromJson(Map<String, dynamic> json) =>
      CompanyLanguage(
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        firstLetter: json["first_letter"] == null ? '' : json["first_letter"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "name": name == null ? null : name,
        "symbol": symbol == null ? null : symbol,
        "first_letter": firstLetter == null ? null : firstLetter,
      };
}

class LanguageSelectorArguments {
  bool? needToShowDoneButton;
  bool? isFromSetting;

  LanguageSelectorArguments(
      {this.needToShowDoneButton, this.isFromSetting = false});
}

class DeviceLanguage {
  updateLocale() async {
    try {
      List? languages = await Devicelocale.preferredLanguages;
      String? locale = await Devicelocale.currentLocale;
      String? language = locale?.substring(0, 2);
      showLog(" languages are  $languages  && $locale");
      var prefs = await SharedPreferences.getInstance();

      prefs.setInt('value', getIndexBySymbol(language ?? 'en'));
      S.load(Locale(language ?? 'en'));
    } catch (e) {
      showLog("language exception $e");
      S.load(Locale('en'));
    }
  }

  int getIndexBySymbol(String symbol) {
    return localLanguages.indexWhere((lang) => lang.symbol == symbol);
  }
}

List<CompanyLanguage> localLanguages = [
  CompanyLanguage(
      name: "বাংলা", firstLetter: "ক", symbol: "bn", description: 'Bengali'),
  CompanyLanguage(
      name: "English", firstLetter: "A", symbol: "en", description: "English"),
  CompanyLanguage(
      name: "Français", firstLetter: "un", symbol: "fr", description: 'French'),
  CompanyLanguage(
      name: "ગુજરાતી", firstLetter: "એ", symbol: "gu", description: "Gujarati"),
  CompanyLanguage(
      name: "हिन्दी", firstLetter: "ए", symbol: "hi", description: 'Hindi'),
  CompanyLanguage(
      name: "ಕನ್ನಡ", firstLetter: "ಎ", symbol: "kn", description: 'Kannada'),
  CompanyLanguage(
      name: "മലയാളം", firstLetter: "എ", symbol: "ml", description: 'Malayalam'),
  CompanyLanguage(
      name: "मराठी", firstLetter: "ए", symbol: "mr", description: 'Marathi'),
  CompanyLanguage(
      name: "தமிழ்", firstLetter: "அ", symbol: "ta", description: 'Tamil'),
  CompanyLanguage(
      name: "తెలుగు", firstLetter: "ఎ", symbol: "te", description: 'Telugu'),
  CompanyLanguage(
      name: "Malay", firstLetter: "B", symbol: "ms", description: 'Malay'),
];
