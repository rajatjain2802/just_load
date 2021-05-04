import 'package:flutter/material.dart';

import 'HowToUseScreen.dart';
import 'MainTabScreen.dart';

loginIntent(BuildContext context) async {
  var route = new MaterialPageRoute(
    builder: (BuildContext context) {
      return new MainTabScreen();
    },
  );
  Navigator.of(context).pushReplacement(route);
}

howToUseIntent(BuildContext context) async {
  var route = new MaterialPageRoute(
    builder: (BuildContext context) {
      return new HowToUseScreen();
    },
  );
  Navigator.of(context).push(route);
}
