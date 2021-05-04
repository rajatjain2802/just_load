import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_downloader_app/CommonColors.dart';
import 'package:insta_downloader_app/IntentHelper.dart';
import 'package:insta_downloader_app/appConstant.dart';
import 'package:insta_downloader_app/instagramDownload/InstaData.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PostDownloadDialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  var _igScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _urlController = TextEditingController();
  InstaProfile _instaProfile;
  InstaPost _instaPost = InstaPost();
  FlutterDownloader flutterDownloader = new FlutterDownloader();
  List<bool> _isVideo = [false];
  bool _showData = false,
      _isDisabled = true,
      _isPost = false,
      _isPrivate = false,
      _notfirst = false;

  bool validateURL(List<String> urls) {
    Pattern pattern = r'^((http(s)?:\/\/)?((w){3}.)?instagram?(\.com)?\/|).+$';
    RegExp regex = new RegExp(pattern);

    for (var url in urls) {
      if (!regex.hasMatch(url)) {
        return false;
      }
    }
    return true;
  }

  void getButton(String url) {
    if (validateURL([url])) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterDownloader.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _igScaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _urlController,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green[400])),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green[400])),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _urlController.text = '';
                                setState(() {});
                              },
                            ),
                            hintText: 'https://www.instagram.com/...'),
                        onChanged: (value) {
                          getButton(value);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Map<String, dynamic> result =
                            await SystemChannels.platform.invokeMethod('Clipboard.getData');
                        result['text'] =
                            result['text'].toString().replaceAll(RegExp(r'\?igshid=.*'), '');
                        result['text'] = result['text']
                            .toString()
                            .replaceAll(RegExp(r'https://instagram.com/'), '');
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _urlController.text =
                              result['text'].toString().replaceAll(RegExp(r'\?igshid=.*'), ''),
                        );
                        setState(() {
                          getButton(result['text'].toString());
                        });
                        Fluttertoast.showToast(msg: "Loading...");

                        if (!_isDisabled) {
                          //Check Internet Connection
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            _igScaffoldKey.currentState
                                .showSnackBar(mySnackBar(context, 'No Internet'));
                            return;
                          }
                          Fluttertoast.showToast(msg: "Fetching Download links...");

                          setState(() {
                            _notfirst = true;
                            _showData = false;
                            _isPrivate = false;
                          });

                          if (_urlController.text.contains('/p/') ||
                              _urlController.text.contains('/tv/') ||
                              _urlController.text.contains('/reel/')) {
                            _instaProfile = await InstaData.postFromUrl('${_urlController.text}');

                            if (_instaProfile == null) {
                              _igScaffoldKey.currentState
                                  .showSnackBar(mySnackBar(context, 'Invalid Url'));
                              setState(() {
                                _notfirst = false;
                              });
                            } else {
                              _instaPost = _instaProfile.postData;
                              if (_instaProfile.isPrivate == true) {
                                setState(() {
                                  _isPrivate = true;
                                });
                                _instaPost.childPostsCount = 1;
                                _instaPost.videoUrl = 'null';
                                _instaPost.photoSmallUrl = _instaProfile.profilePicUrl;
                                _instaPost.photoMediumUrl = _instaProfile.profilePicUrl;
                                _instaPost.photoLargeUrl = _instaProfile.profilePicUrlHd;
                                _instaPost.description = _instaProfile.bio;
                              } else {
                                setState(() {
                                  _isPrivate = false;
                                });
                              }

                              setState(() {
                                if (_instaPost.childPostsCount > 1) {
                                  _isVideo.clear();
                                  _instaPost.childposts.forEach((element) {
                                    element.videoUrl.length > 4
                                        ? _isVideo.add(true)
                                        : _isVideo.add(false);
                                  });
                                } else {
                                  _isVideo.clear();
                                  _instaPost.videoUrl.length > 4
                                      ? _isVideo.add(true)
                                      : _isVideo.add(false);
                                }
                                _showData = true;
                                _isPost = true;
                                if (_showData && _isPost) {
                                  PostDownloadDialog.show(
                                      context: context,
                                      barrierDismissible: false,
                                      instaPost: _instaPost,
                                      instaProfile: _instaProfile,
                                      isVideo: _isVideo);
                                }
                              });
                            }
                          }
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(color: CommonColors.themeColor),
                          padding: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
                          child: Text(
                            "Paste".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Share.share(
                            'https://play.google.com/store/apps/details?id=com.mrgeekypankaj.justload');
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(color: CommonColors.themeColor),
                          padding: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
                          child: Text(
                            "SHARE APP".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String url = "https://play.google.com/store/apps/details?id=com"
                            ".mrgeekypankaj.justload";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {}
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(color: CommonColors.themeColor),
                          padding: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
                          child: Text(
                            "RATE US!".toUpperCase(),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        howToUseIntent(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 5, right: 8),
                          decoration: BoxDecoration(color: CommonColors.themeColor),
                          padding: EdgeInsets.only(left: 12, right: 12, top: 15, bottom: 15),
                          child: Text(
                            "HOW TO USE".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
