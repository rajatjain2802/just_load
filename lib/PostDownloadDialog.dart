import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_downloader_app/instagramDownload/InstaData.dart';
import 'package:progressive_image/progressive_image.dart';

import 'DialogBaseState.dart';

class PostDownloadDialog extends StatefulWidget {
  final barrierDismissible;
  final bgColor;
  final InstaProfile instaProfile;
  final InstaPost instaPost;
  final List<bool> isVideo;

  const PostDownloadDialog(
      {Key key,
      this.barrierDismissible,
      this.bgColor,
      this.instaProfile,
      this.isVideo,
      this.instaPost})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PostDownloadDialogState();
  }

  static Future<bool> show(
      {@required BuildContext context,
      bool barrierDismissible = true,
      InstaProfile instaProfile,
      InstaPost instaPost,
      List<bool> isVideo,
      backgroundColor = const Color(0xb3212121)}) async {
    bool data = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) {
            return PostDownloadDialog(
              barrierDismissible: barrierDismissible,
              bgColor: backgroundColor,
              instaProfile: instaProfile,
              isVideo: isVideo,
              instaPost: instaPost,
            );
          },
          opaque: false,
        ));
    return data;
  }
}

class _PostDownloadDialogState extends DialogBaseState<PostDownloadDialog> {
  Directory dir;
  Directory thumbDir;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createFolder();
  }

  _createFolder() async {
    final folderName = "justload/Instagram";
    dir = Directory("storage/emulated/0/$folderName");
    if ((await dir.exists())) {
      // TODO:
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    } else {
      dir.create();
    }

    final tFolderName = ".justload/.thumbs";
    thumbDir = Directory("storage/emulated/0/$tFolderName");
    if ((await thumbDir.exists())) {
      if (!thumbDir.existsSync()) {
        thumbDir.createSync(recursive: true);
      }
    } else {
      thumbDir.create();
    }
  }

  @override
  Widget getBuildDialogWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(10.0),
      child: GridView.builder(
        itemCount: widget.instaPost.childPostsCount,
        scrollDirection: widget.instaPost.childPostsCount < 2 ? Axis.vertical : Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: ProgressiveImage(
                              placeholder: AssetImage('assets/images/placeholder_image.png'),
                              thumbnail: NetworkImage(widget.instaPost.childPostsCount > 1
                                  ? widget.instaPost.childposts[index].photoMediumUrl
                                  : widget.instaPost.photoMediumUrl),
                              image: NetworkImage(widget.instaPost.childPostsCount > 1
                                  ? widget.instaPost.childposts[index].photoLargeUrl
                                  : widget.instaPost.photoLargeUrl),
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          widget.isVideo[index]
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.videocam),
                                  ),
                                )
                              : Align(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 5.0),
                        child: GestureDetector(
                          child: Text(
                            '${widget.instaPost.description.length > 100 ? widget.instaPost.description.replaceRange(100, widget.instaPost.description.length, '') : widget.instaPost.description}...',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          onTap: () async {
                            Clipboard.setData(ClipboardData(text: widget.instaPost.description));
                            // _igScaffoldKey.currentState.showSnackBar(
                            //     mySnackBar(context, 'Caption Copied'));
                          },
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.file_download),
                            onPressed: () async {
                              // _igScaffoldKey.currentState.showSnackBar(
                              //     mySnackBar(context, 'Added to Download'));
                              Fluttertoast.showToast(
                                  msg: "Added to download",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Theme.of(context).accentColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              String downloadUrl = widget.instaPost.childPostsCount == 1
                                  ? widget.instaPost.videoUrl.length > 4
                                      ? widget.instaPost.videoUrl
                                      : widget.instaPost.photoLargeUrl
                                  : widget.instaPost.childposts[index].videoUrl.length > 4
                                      ? widget.instaPost.childposts[index].videoUrl
                                      : widget.instaPost.childposts[index].photoLargeUrl;
                              String name =
                                  'IG-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.${downloadUrl.toString().contains('jpg') ? 'jpg' : 'mp4'}';
                              String thumbUrl = widget.instaPost.childPostsCount > 1
                                  ? widget.instaPost.childposts[index].photoLargeUrl
                                  : widget.instaPost.photoLargeUrl;
                              await FlutterDownloader.enqueue(
                                url: thumbUrl,
                                savedDir: thumbDir.path,
                                fileName: name.substring(0, name.length - 3) + 'jpg',
                                showNotification: false,
                              );
                              await FlutterDownloader.enqueue(
                                  url: downloadUrl,
                                  savedDir: dir.path,
                                  fileName: name,
                                  showNotification: true,
                                  openFileFromNotification: true,
                                  requiresStorageNotLow: true);
                            },
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 1, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      ),
    );
  }

  @override
  void onVerticalDragEndEvent(DragEndDetails details) {
    // TODO: implement onVerticalDragEndEvent
    if (widget.barrierDismissible) {
      Navigator.pop(context);
    }
  }

  @override
  Color getBgColorOfDialog() {
    // TODO: implement getBgColor
    return widget.bgColor;
  }

  @override
  void onScreenReady(BuildContext context) {}
}
