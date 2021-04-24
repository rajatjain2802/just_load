import 'package:flutter/material.dart';

import 'CommonColors.dart';

AppBar toolBar({
  @required String toolBarTitle,
  Color toolBarTitleColor = CommonColors.txtColorWhite,
  @required VoidCallback onClick,
  IconData toolBarIcon = Icons.arrow_back,
  Color toolBarIconColor = CommonColors.white,
  Color toolBarBgColor = CommonColors.red,
  double elevation = 5,
  bool isImageTitle = false,
  String imagePath = '',
  double imageWidth = 0.0,
  double imageHeight = 0.0,
  BoxFit fit = BoxFit.none,
  List<Widget> actions,
}) {
  return AppBar(
    titleSpacing: 0,
    title: isImageTitle
        ? Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: fit,
          )
        : Text(
            toolBarTitle,
            style: TextStyle(
              color: toolBarTitleColor,
            ),
          ),
    iconTheme: IconThemeData(color: CommonColors.toolbarIconColorDark),
    leading: null,
    elevation: elevation,
    backgroundColor: Colors.pink,
    actions: actions,
  );
}

AppBar toolBarWithSubTitle({
  @required String toolBarTitle,
  String subTitle,
  Color toolBarTitleColor = CommonColors.txtColorWhite,
  Color toolBarSubTitleColor = CommonColors.txtColorWhite,
  @required VoidCallback onClick,
  IconData toolBarIcon = Icons.arrow_back,
  Color toolBarIconColor = CommonColors.white,
  Color toolBarBgColor = CommonColors.red,
  double elevation = 5,
  double subTitleSize = 12,
  double titleSize = 16,
  bool isImageTitle = false,
  String imagePath = '',
  double imageWidth = 0.0,
  double imageHeight = 0.0,
  BoxFit fit = BoxFit.none,
  EdgeInsetsGeometry margin = const EdgeInsets.all(0),
  List<Widget> actions,
}) {
  return AppBar(
    titleSpacing: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          toolBarTitle,
          style: TextStyle(
            color: toolBarTitleColor,
            fontSize: titleSize,
          ),
        ),
        Container(
          margin: margin,
          child: Text(
            subTitle,
            style: TextStyle(
              color: toolBarSubTitleColor,
              fontSize: subTitleSize,
            ),
          ),
        ),
      ],
    ),
    iconTheme: IconThemeData(color: CommonColors.toolbarIconColorDark),
    leading: IconButton(
        icon: Icon(
          toolBarIcon,
          color: toolBarIconColor,
        ),
        onPressed: onClick),
    elevation: elevation,
    backgroundColor: toolBarBgColor,
    actions: actions,
  );
}

AppBar toolBarWithoutIcon(
    {@required String toolBarTitle,
    Color toolBarTitleColor = CommonColors.txtColorWhite,
    IconData toolBarIcon = Icons.arrow_back,
    Color toolBarIconColor = CommonColors.white,
    Color toolBarBgColor = CommonColors.red,
    double elevation = 5,
    bool isImageTitle = false,
    String imagePath = '',
    double imageWidth = 0.0,
    double imageHeight = 0.0,
    BoxFit fit = BoxFit.none,
    List<Widget> actions}) {
  return AppBar(
    title: isImageTitle
        ? Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: fit,
          )
        : Text(
            toolBarTitle,
            style: TextStyle(
              color: toolBarTitleColor,
            ),
          ),
    iconTheme: IconThemeData(color: CommonColors.toolbarIconColorDark),
    elevation: elevation,
    automaticallyImplyLeading: false,
    backgroundColor: toolBarBgColor,
    actions: actions,
  );
}
