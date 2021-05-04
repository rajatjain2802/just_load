import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:insta_downloader_app/BaseState.dart';
import 'package:insta_downloader_app/ImageViewAssets.dart';
import 'package:insta_downloader_app/Toolbar.dart';
import 'package:insta_downloader_app/Utils.dart';

import 'TextView.dart';

class HowToUseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HowToUseScreenState();
  }
}

class _HowToUseScreenState extends BaseState<HowToUseScreen> {
  @override
  Widget getBuildWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextView(
                    title: "Step 1 :- Go To InstaGram",
                    fontColor: Colors.black,
                    maxLine: 2,
                    fontSize: 22,
                    margin: EdgeInsets.only(bottom: 10),
                    fontWeight: FontWeight.w800,
                  ),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(0),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                  TextView(
                    title: "Step 2 :-",
                    fontColor: Colors.black,
                    maxLine: 2,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(1),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                  TextView(
                    title: "Step 3 :- ",
                    fontColor: Colors.black,
                    maxLine: 2,
                    fontSize: 22,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    fontWeight: FontWeight.w800,
                  ),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(2),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                  TextView(
                    title: "Step 4 :-",
                    fontColor: Colors.black,
                    maxLine: 2,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(3),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                  TextView(
                    title: "Step 5 :-",
                    fontColor: Colors.black,
                    maxLine: 2,
                    margin: EdgeInsets.only(top: 15, bottom: 10),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(4),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                  imageViewAsset(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                      imagePath: imageList.elementAt(5),
                      fit: BoxFit.fill,
                      imageHeight: 500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AppBar getToolBar(BuildContext context) {
    return toolBar(
        toolBarTitle: "Justload",
        toolBarIconColor: Colors.white,
        onClick: () {
          performBack(context);
        });
  }

  @override
  void onScreenReady(BuildContext context) {}
}
