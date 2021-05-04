import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_downloader_app/BaseState.dart';
import 'package:insta_downloader_app/CommonColors.dart';
import 'package:permission_handler/permission_handler.dart';

import 'HomeScreen.dart';
import 'Toolbar.dart';

class MainTabScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainTabScreenState();
  }
}

class MainTabScreenState extends BaseState<MainTabScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  PermissionStatus status;

  int denyCnt = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _getPermission();
  }

  void _getPermission() async {
    status = await Permission.storage.request();

    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Storage Permission Requried'),
            content: Text('Enable Storage Permission from App Setting'),
            actions: <Widget>[
              FlatButton(
                child: Text('Open Setting'),
                onPressed: () async {
                  openAppSettings();
                  exit(0);
                },
              )
            ],
          );
        },
      );
    } else {
      while (!status.isGranted) {
        if (denyCnt > 20) {
          exit(0);
        }
        status = await Permission.storage.request();
        denyCnt++;
      }
    }
  }

  @override
  Widget getBuildWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.zero,
          color: CommonColors.white,
          child: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              indicatorColor: CommonColors.themeColor,
              unselectedLabelColor: CommonColors.txtColorGray,
              labelColor: CommonColors.txtColorDark,
              tabs: [
                Tab(
                  text: 'Home',
                ),
                Tab(text: 'Downloads'),
              ]),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [HomeScreen(), Container()]),
        )
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  AppBar getToolBar(BuildContext context) {
    return toolBarWithoutIcon(
      toolBarTitle: 'JustLoad',
      elevation: 0,
    );
  }

  @override
  void onScreenReady(BuildContext context) {}
}
