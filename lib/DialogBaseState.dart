import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CommonColors.dart';
import 'CommonField.dart';

abstract class DialogBaseState<T extends StatefulWidget> extends State<T> {
  bool _isShowing = false;
  bool _isFirstTime = true;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences preference;
  Color getBgColorOfDialog();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: onVerticalDragEndEvent,
          child: Scaffold(
            backgroundColor: getBgColorOfDialog(),
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            key: scaffoldKey,
            body: Dialog(
              child: SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    getBuildDialogWidget(context),
                    _isShowing ? circularProgress() : Container(),
                    _isFirstTime ? _callApiWidget(context) : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () => performBack(context),
    );
  }

  performBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      onBackPressed(context);
    } else {
      exit(0);
    }
  }

  openDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  Widget getBuildDialogWidget(BuildContext context);

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onScreenReady(BuildContext context);

  Widget _callApiWidget(BuildContext ctx) {
    SharedPreferences.getInstance().then((pref) {
      preference = pref;
      _isFirstTime = false;
      onScreenReady(ctx);
    }, onError: (e) {
      print('Error = ' + e.toString());
    });
    return Container();
  }

  showProgress(bool b) {
    if (_isShowing != b) {
      if (this.mounted) {
        setState(() {
          _isShowing = b;
        });
      }
    }
  }

  showSnackBar(String str, {Color bgColor = CommonColors.red, bool isPop = true}) {
    var snackbar = new SnackBar(
      content: new Text(str),
      duration: Duration(seconds: 2),
      backgroundColor: bgColor,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    if (isPop) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  void onVerticalDragEndEvent(DragEndDetails details);
}
