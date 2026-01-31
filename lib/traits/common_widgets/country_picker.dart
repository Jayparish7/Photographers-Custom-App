import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/controllers/login_controller.dart';
import 'package:photomall_flutter/core/models/apiModels/transport_model/transport_model.dart'
    as contry;

class CustomCountryPicker extends StatefulWidget {
  //final Map<String, dynamic> dropDownValue;
  int dropDownValue;
  final Function onchangeDropDown;

  CustomCountryPicker(
      {Key? key,
      /*this.dropDownValue = const {
        "id": 108,
        "code": "+91",
        "name": "India",
        "short_code": "IN"
      },*/
      this.dropDownValue = 108,
      required this.onchangeDropDown})
      : super(key: key);

  @override
  State<CustomCountryPicker> createState() => _CustomCountryPickerState();
}

class _CustomCountryPickerState extends State<CustomCountryPicker> {
  List<contry.Country> dropDownItems = [];

  LoginController loginController = LoginController();

  @override
  void initState() {
    getDropDownItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
          isExpanded: true,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
          alignment: Alignment.centerLeft,
          style: Theme.of(context).textTheme.titleMedium,
          iconDisabledColor: AppColorData.iconColor,
          iconEnabledColor: AppColorData.iconSelectedColor,
          icon: Icon(
            Icons.arrow_drop_down,
            //color: AppColorData.iconColor,
          ),
          value: widget.dropDownValue,
          borderRadius: BorderRadius.circular(20),
          dropdownColor: AppColorData.textFormFieldCardBg,
          items: dropDownItems
              .map((contry.Country items) => DropdownMenuItem<int>(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(convertToEmoji(items.shortCode!)),
                      SizedBox(
                        width: 4,
                      ),
                      Text(items.name!),
                      SizedBox(
                        width: 4,
                      ),
                      Text(items.code!),
                    ],
                  ),
                  value: items.id))
              .toList(),

          /* items: dropDownItems.map<DropdownMenuItem<Map<String, dynamic>>>(
              (Map<String, dynamic> items) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: items,
              child: Text('${items["code"]}'),
            );
          }).toList(),*/
          onChanged: (int? newValue) {
            widget.dropDownValue = newValue!;
            setState(() {});

            widget.onchangeDropDown(newValue);
          }),
    );
  }

  void getDropDownItems() async {
    // LoginController loginController = LoginController();
    dropDownItems = allCountries!;
  }

  static String convertToEmoji(String countryCode) {
    String flag = countryCode.replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }
}
