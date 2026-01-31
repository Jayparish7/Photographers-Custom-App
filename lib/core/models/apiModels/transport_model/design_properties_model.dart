// To parse this JSON data, do
//
//     final colorProperties = colorPropertiesFromJson(jsonString);

import 'dart:convert';

DesignProperties colorPropertiesFromJson(String str) =>
    DesignProperties.fromJson(json.decode(str));

String colorPropertiesToJson(DesignProperties data) =>
    json.encode(data.toJson());

class DesignProperties {
  DesignProperties({
    this.appDesignKeys,
    //this.studioLanguages,
  });

  AppDesignKeys? appDesignKeys;
  //List<StudioLanguage>? studioLanguages;

  factory DesignProperties.fromJson(Map<String, dynamic> json) =>
      DesignProperties(
        appDesignKeys: json["app_design_keys"] == null
            ? null
            : AppDesignKeys.fromJson(json["app_design_keys"]),
      //  studioLanguages: json["studio_languages"] == null
          //  ? null
           // : List<StudioLanguage>.from(json["studio_languages"]
           //     .map((x) => StudioLanguage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "app_design_keys":
            appDesignKeys == null ? null : appDesignKeys!.toJson(),
        //"studio_languages": studioLanguages == null
           // ? null
           // : List<dynamic>.from(studioLanguages!.map((x) => x.toJson())),
      };
}

class AppDesignKeys {
  AppDesignKeys({
    this.app,
    this.appBar,
    this.tabBar,
    this.material,
    this.sideDrawer,
    this.alertDialog,
    this.backgroundIcon,
    this.cardProperties,
    this.iconProperties,
    this.textFormField,
    this.textProperties,
    this.bottomNavigation,
    this.buttonProperties,
    this.transitionEffects,
    this.progressIndicator,
    this.highlightTextColor,
    this.selectionStatusCard,
  });

  App? app;
  AppBar? appBar;
  TabBar? tabBar;
  Material? material;
  BottomNavigation? sideDrawer;
  AlertDialog? alertDialog;
  App? backgroundIcon;
  CardProperties? cardProperties;
  IconProperties? iconProperties;
  TextFormField? textFormField;
  TextProperties? textProperties;
  BottomNavigation? bottomNavigation;
  ButtonProperties? buttonProperties;
  TransitionEffects? transitionEffects;
  ProgressIndicator? progressIndicator;
  HighlightTextColor? highlightTextColor;
  SelectionStatusCard? selectionStatusCard;

  factory AppDesignKeys.fromJson(Map<String, dynamic> json) => AppDesignKeys(
        app: json["app"] == null ? null : App.fromJson(json["app"]),
        appBar:
            json["app_bar"] == null ? null : AppBar.fromJson(json["app_bar"]),
        tabBar:
            json["tab_bar"] == null ? null : TabBar.fromJson(json["tab_bar"]),
        material: json["material"] == null
            ? null
            : Material.fromJson(json["material"]),
        sideDrawer: json["side_drawer"] == null
            ? null
            : BottomNavigation.fromJson(json["side_drawer"]),
        alertDialog: json["alert_dialog"] == null
            ? null
            : AlertDialog.fromJson(json["alert_dialog"]),
        backgroundIcon: json["background_icon"] == null
            ? null
            : App.fromJson(json["background_icon"]),
        cardProperties: json["card_properties"] == null
            ? null
            : CardProperties.fromJson(json["card_properties"]),
        iconProperties: json["icon_properties"] == null
            ? null
            : IconProperties.fromJson(json["icon_properties"]),
        textFormField: json["text_form_field"] == null
            ? null
            : TextFormField.fromJson(json["text_form_field"]),
        textProperties: json["text_properties"] == null
            ? null
            : TextProperties.fromJson(json["text_properties"]),
        bottomNavigation: json["bottom_navigation"] == null
            ? null
            : BottomNavigation.fromJson(json["bottom_navigation"]),
        buttonProperties: json["button_properties"] == null
            ? null
            : ButtonProperties.fromJson(json["button_properties"]),
        transitionEffects: json["transitionEffects"] == null
            ? null
            : TransitionEffects.fromJson(json["transitionEffects"]),
        progressIndicator: json["progress_indicator"] == null
            ? null
            : ProgressIndicator.fromJson(json["progress_indicator"]),
        highlightTextColor: json["highlight_text_color"] == null
            ? null
            : HighlightTextColor.fromJson(json["highlight_text_color"]),
        selectionStatusCard: json["selection_status_card"] == null
            ? null
            : SelectionStatusCard.fromJson(json["selection_status_card"]),
      );

  Map<String, dynamic> toJson() => {
        "app": app == null ? null : app!.toJson(),
        "app_bar": appBar == null ? null : appBar!.toJson(),
        "tab_bar": tabBar == null ? null : tabBar!.toJson(),
        "material": material == null ? null : material!.toJson(),
        "side_drawer": sideDrawer == null ? null : sideDrawer!.toJson(),
        "alert_dialog": alertDialog == null ? null : alertDialog!.toJson(),
        "background_icon":
            backgroundIcon == null ? null : backgroundIcon!.toJson(),
        "card_properties":
            cardProperties == null ? null : cardProperties!.toJson(),
        "icon_properties":
            iconProperties == null ? null : iconProperties!.toJson(),
        "text_form_field":
            textFormField == null ? null : textFormField!.toJson(),
        "text_properties":
            textProperties == null ? null : textProperties!.toJson(),
        "bottom_navigation":
            bottomNavigation == null ? null : bottomNavigation!.toJson(),
        "button_properties":
            buttonProperties == null ? null : buttonProperties!.toJson(),
        "transitionEffects":
            transitionEffects == null ? null : transitionEffects!.toJson(),
        "progress_indicator":
            progressIndicator == null ? null : progressIndicator!.toJson(),
        "highlight_text_color":
            highlightTextColor == null ? null : highlightTextColor!.toJson(),
        "selection_status_card":
            selectionStatusCard == null ? null : selectionStatusCard!.toJson(),
      };
}

class AlertDialog {
  AlertDialog({
    this.alertDialogIcon,
    this.alertDialogTitle,
    this.alertDialogContent,
    this.alertDialogBackground,
  });

  String? alertDialogIcon;
  String? alertDialogTitle;
  String? alertDialogContent;
  String? alertDialogBackground;

  factory AlertDialog.fromJson(Map<String, dynamic> json) => AlertDialog(
        alertDialogIcon: json["alert_dialog_icon"] == null
            ? null
            : json["alert_dialog_icon"],
        alertDialogTitle: json["alert_dialog_title"] == null
            ? null
            : json["alert_dialog_title"],
        alertDialogContent: json["alert_dialog_content"] == null
            ? null
            : json["alert_dialog_content"],
        alertDialogBackground: json["alert_dialog_background"] == null
            ? null
            : json["alert_dialog_background"],
      );

  Map<String, dynamic> toJson() => {
        "alert_dialog_icon": alertDialogIcon == null ? null : alertDialogIcon,
        "alert_dialog_title":
            alertDialogTitle == null ? null : alertDialogTitle,
        "alert_dialog_content":
            alertDialogContent == null ? null : alertDialogContent,
        "alert_dialog_background":
            alertDialogBackground == null ? null : alertDialogBackground,
      };
}

class App {
  App({
    this.background,
    this.backgroundEnd,
    this.backgroundBegin,
    this.backgroundStops,
    this.iconColor,
  });

  List<String>? background;
  int? backgroundEnd;
  int? backgroundBegin;
  List<double>? backgroundStops;
  String? iconColor;

  factory App.fromJson(Map<String, dynamic> json) => App(
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
        iconColor: json["icon_color"] == null ? null : json["icon_color"],
      );

  Map<String, dynamic> toJson() => {
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
        "icon_color": iconColor == null ? null : iconColor,
      };
}

class AppBar {
  AppBar({
    this.icon,
    this.titleText,
    this.textColor,
    this.background,
    this.backgroundEnd,
    this.backgroundBegin,
    this.backgroundStops,
  });

  String? icon;
  String? titleText;
  String? textColor;
  List<String>? background;
  int? backgroundEnd;
  int? backgroundBegin;
  List<double>? backgroundStops;

  factory AppBar.fromJson(Map<String, dynamic> json) => AppBar(
        icon: json["icon"] == null ? null : json["icon"],
        titleText: json["title_text"] == null ? null : json["title_text"],
    textColor: json["text"] == null ? null : json["text"],
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "icon": icon == null ? null : icon,
        "title_text": titleText == null ? null : titleText,
        "text": textColor == null ? null : textColor,
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
      };
}

class BottomNavigation {
  BottomNavigation({
    this.background,
    this.selectedIcon,
    this.selectedText,
    this.backgroundEnd,
    this.unselectedIcon,
    this.unselectedText,
    this.backgroundBegin,
    this.backgroundStops,
    this.clipPath,
    this.menuPosition,
  });

  List<String>? background;
  String? selectedIcon;
  String? selectedText;
  int? backgroundEnd;
  String? unselectedIcon;
  String? unselectedText;
  int? backgroundBegin;
  List<double>? backgroundStops;
  int? clipPath;
  int? menuPosition;

  factory BottomNavigation.fromJson(Map<String, dynamic> json) =>
      BottomNavigation(
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        selectedIcon:
            json["selected_icon"] == null ? null : json["selected_icon"],
        selectedText:
            json["selected_text"] == null ? null : json["selected_text"],
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        unselectedIcon:
            json["unselected_icon"] == null ? null : json["unselected_icon"],
        unselectedText:
            json["unselected_text"] == null ? null : json["unselected_text"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        menuPosition: json.containsKey("menu_position")
            ? json["menu_position"] == null
                ? null
                : json["menu_position"]
            : null,
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
        clipPath: json["clip_path"] == null ? null : json["clip_path"],
      );

  Map<String, dynamic> toJson() => {
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "selected_icon": selectedIcon == null ? null : selectedIcon,
        "selected_text": selectedText == null ? null : selectedText,
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "unselected_icon": unselectedIcon == null ? null : unselectedIcon,
        "unselected_text": unselectedText == null ? null : unselectedText,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "menu_position": menuPosition == null ? null : menuPosition,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
        "clip_path": clipPath == null ? null : clipPath,
      };
}

class ButtonProperties {
  ButtonProperties({
    this.shadow,
    this.elevation,
    this.background,
    this.textColor,
    this.backgroundEnd,
    this.backgroundBegin,
    this.backgroundStops,
    this.textButtonColor,
    this.elevatedButtonColor,
    this.outLineButtonBorder,
  });

  String? shadow;
  int? elevation;
  List<String>? background;
  String? textColor;
  int? backgroundEnd;
  int? backgroundBegin;
  List<double>? backgroundStops;
  String? textButtonColor;
  String? elevatedButtonColor;
  String? outLineButtonBorder;

  factory ButtonProperties.fromJson(Map<String, dynamic> json) =>
      ButtonProperties(
        shadow: json["shadow"] == null ? null : json["shadow"],
        elevation: json["elevation"] == null ? null : json["elevation"],
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        textColor: json["text_color"] == null ? null : json["text_color"],
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
        textButtonColor: json["text_button_color"] == null
            ? null
            : json["text_button_color"],
        elevatedButtonColor: json["elevated_button_color"] == null
            ? null
            : json["elevated_button_color"],
        outLineButtonBorder: json["out_line_button_border"] == null
            ? null
            : json["out_line_button_border"],
      );

  Map<String, dynamic> toJson() => {
        "shadow": shadow == null ? null : shadow,
        "elevation": elevation == null ? null : elevation,
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "text_color": textColor == null ? null : textColor,
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
        "text_button_color": textButtonColor == null ? null : textButtonColor,
        "elevated_button_color":
            elevatedButtonColor == null ? null : elevatedButtonColor,
        "out_line_button_border":
            outLineButtonBorder == null ? null : outLineButtonBorder,
      };
}

class CardProperties {
  CardProperties({
    this.margin,
    this.shadow,
    this.elevation,
    this.background,
    this.selectedBackground,
    this.highlightedTextColour,
    this.normalTextColour,
    this.highlightedIconColour,
    this.normalIconColour,
    this.backgroundColors,
    this.backgroundEnd,
    this.backgroundBegin,
    this.backgroundStops,
  });

  int? margin;
  String? shadow;
  int? elevation;
  String? background;
  String? selectedBackground;
  String? highlightedTextColour;
  String? normalTextColour;
  String? highlightedIconColour;
  String? normalIconColour;
  List<String>? backgroundColors;
  int? backgroundEnd;
  int? backgroundBegin;
  List<double>? backgroundStops;

  factory CardProperties.fromJson(Map<String, dynamic> json) => CardProperties(
      margin: json["margin"] == null ? null : json["margin"],
      shadow: json["shadow"] == null ? null : json["shadow"],
      elevation: json["elevation"] == null ? null : json["elevation"],
      background: json["background"] == null ? null : json["background"],
      selectedBackground: json["selected_background"] == null
          ? null
          : json["selected_background"],
      highlightedTextColour: json["highlighted_text_colour"],
      normalTextColour: json["normal_text_colour"],
      highlightedIconColour: json["highlighted_icon_colour"],
      normalIconColour: json["normal_icon_colour"],
      backgroundColors: json["background_colors"] == null
          ? null
          : List<String>.from(json["background_colors"].map((x) => x)),
      backgroundEnd:
          json["background_end"] == null ? null : json["background_end"],
      backgroundBegin:
          json["background_begin"] == null ? null : json["background_begin"],
      backgroundStops: json["background_stops"] == null
          ? null
          : List<double>.from(
              json["background_stops"].map((x) => x.toDouble())));

  Map<String, dynamic> toJson() => {
        "margin": margin == null ? null : margin,
        "shadow": shadow == null ? null : shadow,
        "elevation": elevation == null ? null : elevation,
        "background": background == null ? null : background,
        "selected_background":
            selectedBackground == null ? null : selectedBackground,
        "highlighted_text_colour": highlightedTextColour,
        "normal_text_colour": normalTextColour,
        "highlighted_icon_colour": highlightedIconColour,
        "normal_icon_colour": normalIconColour,
        "background_colors": backgroundColors == null
            ? null
            : List<dynamic>.from(backgroundColors!.map((x) => x)),
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
      };
}

class HighlightTextColor {
  HighlightTextColor({
    this.labelLargeText,
    this.titleMediumText,
    this.headLineSmallText,
  });

  String? labelLargeText;
  String? titleMediumText;
  String? headLineSmallText;

  factory HighlightTextColor.fromJson(Map<String, dynamic> json) =>
      HighlightTextColor(
        labelLargeText:
            json["label_Large_text"] == null ? null : json["label_Large_text"],
        titleMediumText: json["title_medium_text"] == null
            ? null
            : json["title_medium_text"],
        headLineSmallText: json["head_line_small_text"] == null
            ? null
            : json["head_line_small_text"],
      );

  Map<String, dynamic> toJson() => {
        "label_Large_text": labelLargeText == null ? null : labelLargeText,
        "title_medium_text": titleMediumText == null ? null : titleMediumText,
        "head_line_small_text":
            headLineSmallText == null ? null : headLineSmallText,
      };
}

class IconProperties {
  IconProperties({
    this.selected,
    this.unselected,
  });

  String? selected;
  String? unselected;

  factory IconProperties.fromJson(Map<String, dynamic> json) => IconProperties(
        selected: json["selected"] == null ? null : json["selected"],
        unselected: json["unselected"] == null ? null : json["unselected"],
      );

  Map<String, dynamic> toJson() => {
        "selected": selected == null ? null : selected,
        "unselected": unselected == null ? null : unselected,
      };
}

class Material {
  Material({
    this.divider,
  });

  String? divider;

  factory Material.fromJson(Map<String, dynamic> json) => Material(
        divider: json["divider"] == null ? null : json["divider"],
      );

  Map<String, dynamic> toJson() => {
        "divider": divider == null ? null : divider,
      };
}

class ProgressIndicator {
  ProgressIndicator({
    this.strokeWidth,
    this.circularColor,
    this.circularBackground,
  });

  int? strokeWidth;
  String? circularColor;
  String? circularBackground;

  factory ProgressIndicator.fromJson(Map<String, dynamic> json) =>
      ProgressIndicator(
        strokeWidth: json["stroke_width"] == null ? null : json["stroke_width"],
        circularColor:
            json["circular_color"] == null ? null : json["circular_color"],
        circularBackground: json["circular_background"] == null
            ? null
            : json["circular_background"],
      );

  Map<String, dynamic> toJson() => {
        "stroke_width": strokeWidth == null ? null : strokeWidth,
        "circular_color": circularColor == null ? null : circularColor,
        "circular_background":
            circularBackground == null ? null : circularBackground,
      };
}

class SelectionStatusCard {
  SelectionStatusCard({
    this.background,
    this.rejectedCard,
    this.rejectedText,
    this.selectedCard,
    this.selectedText,
    this.backgroundEnd,
    this.undecidedCard,
    this.undecidedText,
    this.backgroundBegin,
    this.backgroundStops,
  });

  List<String>? background;
  String? rejectedCard;
  String? rejectedText;
  String? selectedCard;
  String? selectedText;
  int? backgroundEnd;
  String? undecidedCard;
  String? undecidedText;
  int? backgroundBegin;
  List<double>? backgroundStops;

  factory SelectionStatusCard.fromJson(Map<String, dynamic> json) =>
      SelectionStatusCard(
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        rejectedCard:
            json["rejected_card"] == null ? null : json["rejected_card"],
        rejectedText:
            json["rejected_text"] == null ? null : json["rejected_text"],
        selectedCard:
            json["selected_card"] == null ? null : json["selected_card"],
        selectedText:
            json["selected_text"] == null ? null : json["selected_text"],
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        undecidedCard:
            json["undecided_card"] == null ? null : json["undecided_card"],
        undecidedText:
            json["undecided_text"] == null ? null : json["undecided_text"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "rejected_card": rejectedCard == null ? null : rejectedCard,
        "rejected_text": rejectedText == null ? null : rejectedText,
        "selected_card": selectedCard == null ? null : selectedCard,
        "selected_text": selectedText == null ? null : selectedText,
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "undecided_card": undecidedCard == null ? null : undecidedCard,
        "undecided_text": undecidedText == null ? null : undecidedText,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
      };
}

class TabBar {
  TabBar({
    this.background,
    this.backgroundEnd,
    this.indicatorColor,
    this.backgroundBegin,
    this.backgroundStops,
    this.unSelectedLabel,
    this.selectedLabelColor,
  });

  List<String>? background;
  int? backgroundEnd;
  String? indicatorColor;
  int? backgroundBegin;
  List<double>? backgroundStops;
  String? unSelectedLabel;
  String? selectedLabelColor;

  factory TabBar.fromJson(Map<String, dynamic> json) => TabBar(
        background: json["background"] == null
            ? null
            : List<String>.from(json["background"].map((x) => x)),
        backgroundEnd:
            json["background_end"] == null ? null : json["background_end"],
        indicatorColor:
            json["indicator_color"] == null ? null : json["indicator_color"],
        backgroundBegin:
            json["background_begin"] == null ? null : json["background_begin"],
        backgroundStops: json["background_stops"] == null
            ? null
            : List<double>.from(
                json["background_stops"].map((x) => x.toDouble())),
        unSelectedLabel: json["un_selected_label"] == null
            ? null
            : json["un_selected_label"],
        selectedLabelColor: json["selected_label_color"] == null
            ? null
            : json["selected_label_color"],
      );

  Map<String, dynamic> toJson() => {
        "background": background == null
            ? null
            : List<dynamic>.from(background!.map((x) => x)),
        "background_end": backgroundEnd == null ? null : backgroundEnd,
        "indicator_color": indicatorColor == null ? null : indicatorColor,
        "background_begin": backgroundBegin == null ? null : backgroundBegin,
        "background_stops": backgroundStops == null
            ? null
            : List<dynamic>.from(backgroundStops!.map((x) => x)),
        "un_selected_label": unSelectedLabel == null ? null : unSelectedLabel,
        "selected_label_color":
            selectedLabelColor == null ? null : selectedLabelColor,
      };
}

class TextFormField {
  TextFormField({
    this.dateText,
    this.dateSelectedText,
    this.textFormFieldCursor,
    this.textFormFieldMargin,
    this.textFormFieldShadow,
    this.dateHeadingBackground,
    this.dateSelectedBackground,
    this.textFormFieldElevation,
    this.textFormFieldHintText,
    this.textFormFieldBackground,
    this.textFormFieldBorderSide,
    this.textFormFieldLabelText,
  });

  String? dateText;
  String? dateSelectedText;
  String? textFormFieldCursor;
  int? textFormFieldMargin;
  String? textFormFieldShadow;
  String? dateHeadingBackground;
  String? dateSelectedBackground;
  int? textFormFieldElevation;
  String? textFormFieldHintText;
  String? textFormFieldBackground;
  String? textFormFieldBorderSide;
  String? textFormFieldLabelText;

  factory TextFormField.fromJson(Map<String, dynamic> json) => TextFormField(
        dateText: json["date_text"] == null ? null : json["date_text"],
        dateSelectedText: json["date_selected_text"] == null
            ? null
            : json["date_selected_text"],
        textFormFieldCursor: json["text_form_field_cursor"] == null
            ? null
            : json["text_form_field_cursor"],
        textFormFieldMargin: json["text_form_field_margin"] == null
            ? null
            : json["text_form_field_margin"],
        textFormFieldShadow: json["text_form_field_shadow"] == null
            ? null
            : json["text_form_field_shadow"],
        dateHeadingBackground: json["date_heading_background"] == null
            ? null
            : json["date_heading_background"],
        dateSelectedBackground: json["date_selected_background"] == null
            ? null
            : json["date_selected_background"],
        textFormFieldElevation: json["text_form_field_elevation"] == null
            ? null
            : json["text_form_field_elevation"],
        textFormFieldHintText: json["text_form_field_hint_text"] == null
            ? null
            : json["text_form_field_hint_text"],
        textFormFieldBackground: json["text_form_field_background"] == null
            ? null
            : json["text_form_field_background"],
        textFormFieldBorderSide: json["text_form_field_borderSide"] == null
            ? null
            : json["text_form_field_borderSide"],
        textFormFieldLabelText: json["text_form_field_label_text"] == null
            ? null
            : json["text_form_field_label_text"],
      );

  Map<String, dynamic> toJson() => {
        "date_text": dateText == null ? null : dateText,
        "date_selected_text":
            dateSelectedText == null ? null : dateSelectedText,
        "text_form_field_cursor":
            textFormFieldCursor == null ? null : textFormFieldCursor,
        "text_form_field_margin":
            textFormFieldMargin == null ? null : textFormFieldMargin,
        "text_form_field_shadow":
            textFormFieldShadow == null ? null : textFormFieldShadow,
        "date_heading_background":
            dateHeadingBackground == null ? null : dateHeadingBackground,
        "date_selected_background":
            dateSelectedBackground == null ? null : dateSelectedBackground,
        "text_form_field_elevation":
            textFormFieldElevation == null ? null : textFormFieldElevation,
        "text_form_field_hint_text":
            textFormFieldHintText == null ? null : textFormFieldHintText,
        "text_form_field_background":
            textFormFieldBackground == null ? null : textFormFieldBackground,
        "text_form_field_borderSide":
            textFormFieldBorderSide == null ? null : textFormFieldBorderSide,
        "text_form_field_label_text":
            textFormFieldLabelText == null ? null : textFormFieldLabelText,
      };
}

class TextProperties {
  TextProperties({
    this.headLineSix,
    this.helpTextColor,
    this.buttonTextColor,
    this.bodyLargeTextColor,
    this.bodySmallTextColor,
    this.bodyMediumTextColor,
    this.labelLargeTextColor,
    this.titleLargeTextColor,
    this.labelMediumTextColor,
    this.titleMediumTextColor,
    this.headLineSmallTextColor,
  });

  String? headLineSix;
  String? helpTextColor;
  String? buttonTextColor;
  String? bodyLargeTextColor;
  String? bodySmallTextColor;
  String? bodyMediumTextColor;
  String? labelLargeTextColor;
  String? titleLargeTextColor;
  String? labelMediumTextColor;
  String? titleMediumTextColor;
  String? headLineSmallTextColor;

  factory TextProperties.fromJson(Map<String, dynamic> json) => TextProperties(
        headLineSix:
            json["head_line_six"] == null ? null : json["head_line_six"],
        helpTextColor:
            json["help_text_color"] == null ? null : json["help_text_color"],
        buttonTextColor: json["button_text_color"] == null
            ? null
            : json["button_text_color"],
        bodyLargeTextColor: json["body_large_text_color"] == null
            ? null
            : json["body_large_text_color"],
        bodySmallTextColor: json["body_small_text_color"] == null
            ? null
            : json["body_small_text_color"],
        bodyMediumTextColor: json["body_medium_text_color"] == null
            ? null
            : json["body_medium_text_color"],
        labelLargeTextColor: json["label_large_text_color"] == null
            ? null
            : json["label_large_text_color"],
        titleLargeTextColor: json["title_large_text_color"] == null
            ? null
            : json["title_large_text_color"],
        labelMediumTextColor: json["label_medium_text_color"] == null
            ? null
            : json["label_medium_text_color"],
        titleMediumTextColor: json["title_medium_text_color"] == null
            ? null
            : json["title_medium_text_color"],
        headLineSmallTextColor: json["head_line_small_text_color"] == null
            ? null
            : json["head_line_small_text_color"],
      );

  Map<String, dynamic> toJson() => {
        "head_line_six": headLineSix == null ? null : headLineSix,
        "help_text_color": helpTextColor == null ? null : helpTextColor,
        "button_text_color": buttonTextColor == null ? null : buttonTextColor,
        "body_large_text_color":
            bodyLargeTextColor == null ? null : bodyLargeTextColor,
        "body_small_text_color":
            bodySmallTextColor == null ? null : bodySmallTextColor,
        "body_medium_text_color":
            bodyMediumTextColor == null ? null : bodyMediumTextColor,
        "label_large_text_color":
            labelLargeTextColor == null ? null : labelLargeTextColor,
        "title_large_text_color":
            titleLargeTextColor == null ? null : titleLargeTextColor,
        "label_medium_text_color":
            labelMediumTextColor == null ? null : labelMediumTextColor,
        "title_medium_text_color":
            titleMediumTextColor == null ? null : titleMediumTextColor,
        "head_line_small_text_color":
            headLineSmallTextColor == null ? null : headLineSmallTextColor,
      };
}

class TransitionEffects {
  TransitionEffects({
    this.itemTransition,
    this.pageTransition,
  });

  int? itemTransition;
  int? pageTransition;

  factory TransitionEffects.fromJson(Map<String, dynamic> json) =>
      TransitionEffects(
        itemTransition:
            json["itemTransition"] == null ? null : json["itemTransition"],
        pageTransition:
            json["pageTransition"] == null ? null : json["pageTransition"],
      );

  Map<String, dynamic> toJson() => {
        "itemTransition": itemTransition == null ? null : itemTransition,
        "pageTransition": pageTransition == null ? null : pageTransition,
      };
}

/*class StudioLanguage {
  StudioLanguage({
    this.code,
    this.font,
    this.name,
    this.symbol,
    this.firstLetter,
    this.lastUpdatedAt,
  });

  String? code;
  dynamic font;
  String? name;
  String? symbol;
  String? firstLetter;
  int? lastUpdatedAt;

  factory StudioLanguage.fromJson(Map<String, dynamic> json) => StudioLanguage(
        code: json["code"] == null ? null : json["code"],
        font: json["font"],
        name: json["name"] == null ? null : json["name"],
        symbol: json["symbol"] == null ? null : json["symbol"],
        firstLetter: json["first_letter"] == null ? null : json["first_letter"],
        lastUpdatedAt:
            json["last_updated_at"] == null ? null : json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "font": font,
        "name": name == null ? null : name,
        "symbol": symbol == null ? null : symbol,
        "first_letter": firstLetter == null ? null : firstLetter,
        "last_updated_at": lastUpdatedAt == null ? null : lastUpdatedAt,
      };
}*/
