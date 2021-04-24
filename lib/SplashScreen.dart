import 'package:flutter/material.dart';
import 'package:insta_downloader_app/BaseState.dart';
import 'package:insta_downloader_app/ImageViewAssets.dart';
import 'package:insta_downloader_app/IntentHelper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends BaseState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget getBuildWidget(BuildContext context) {
    return Container(
      child: imageViewAsset(
        fit: BoxFit.fill,
        imagePath: 'assets/images/SplashScreen.jpg',
      ),
    );
  }

  @override
  AppBar getToolBar(BuildContext context) {
    return null;
  }

  @override
  void onScreenReady(BuildContext context) {
    Future.delayed(Duration(milliseconds: 500), () {
      loginIntent(context);
    });
  }
}
