// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../helpers/colors.dart';
import '../helpers/singleton.dart';
import '../helpers/api_constant.dart';
import '../helpers/constant.dart';
import '../service/api_service.dart';
import '../models/get_course_response_model.dart';
import '../models/course_detail_response_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final url;
  final videoIndex;
  List<LessionList>? videoList;
  Course? courseItem;
  CourseDetailInnerData objCourseDetail;

  VideoPlayerScreen({
    this.videoIndex,
    this.url,
    this.videoList,
    Key? key,
    this.courseItem,
    required this.objCourseDetail,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool isNeedToSeek = false;
  Duration duration = const Duration(hours: 0, minutes: 0, seconds: 0);
  bool isUserStartedVideo = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller!.addListener(checkVideo);
  }

  void checkVideo() {
    // Implement your calls inside these conditions' bodies :
    if (_controller!.value.position ==
            const Duration(seconds: 0, minutes: 0, hours: 0) &&
        _controller!.value.isPlaying &&
        !_controller!.value.isBuffering) {
      if (kDebugMode) {
        print('video Started');
      }
      if (!Singleton.instance.isUserPlayVideo) {
        Singleton.instance.isUserPlayVideo = true;
        startLessionAPI(widget.videoList![widget.videoIndex!].secret ?? "");
      }
    }

    if (_controller!.value.isPlaying) {
      isUserStartedVideo = true;
    }

    if (!_controller!.value.isPlaying &&
        _controller!.value.isInitialized &&
        (_controller!.value.duration == _controller!.value.position)) {
      if (kDebugMode) {
        print('video Ended ${_controller!.value.duration}');
      }
      if (!Singleton.instance.isVideoCompleted) {
        Singleton.instance.isVideoCompleted = true;
        completeLessionAPI(widget.videoList![widget.videoIndex!].secret ?? "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(
          "duration in formate ${_controller!.value.duration.toString().split('.')[0]}");
    }

    if (widget.videoList![widget.videoIndex!].active_duration != "00:00:00") {
      isNeedToSeek = true;
      var test = widget.videoList![widget.videoIndex!].active_duration ?? "";
      List<String> dateParts = test.split(":");
      duration = Duration(
          hours: int.parse(dateParts[0]),
          minutes: int.parse(dateParts[1]),
          seconds: int.parse(dateParts[2]));
    } else {
      isNeedToSeek = false;
    }

    if (kDebugMode) {
      print("url ${widget.url}");
    }
    return Scaffold(
      appBar: Singleton.instance.CommonAppbar(
          appbarText: "",
          leadingClickEvent: () {
            if ((_controller!.value.position.toString().split('.')[0] !=
                    "0:00:00") &&
                (_controller!.value.duration.toString().split('.')[0] !=
                    _controller!.value.position.toString().split('.')[0])) {
              if (kDebugMode) {
                print("PLAYER STOP IN BETWEEN");
              }

              if (!isUserStartedVideo) {
                var count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
              } else {
                pauseLessionAPI(
                    widget.videoList![widget.videoIndex!].secret ?? "",
                    _controller!.value.position.toString().split('.')[0]);
              }
            } else {
              var count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }
          },
          backgroundColor: ColorCodes.navbar,
          iconColor: Colors.white,
          endText: "",
          endTextClickEvent: () {}),
      backgroundColor: ColorCodes.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Center(
                  child: _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: SizedBox(
                            width: _controller!.value.size.width,
                            height: _controller!.value.size.height,
                            child: Chewie(
                              controller: ChewieController(
                                startAt: isNeedToSeek
                                    ? Duration(
                                        hours: duration.inHours,
                                        minutes: duration.inMinutes,
                                        seconds: duration.inSeconds)
                                    : const Duration(
                                        hours: 0, minutes: 0, seconds: 0),
                                autoPlay: false,
                                looping: false,
                                showControls: true,
                                allowFullScreen: true,
                                deviceOrientationsAfterFullScreen: [
                                  DeviceOrientation.portraitUp
                                ],
                                deviceOrientationsOnEnterFullScreen: [
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                ],
                                videoPlayerController: _controller!,
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Singleton.instance.isUserPlayVideo = false;
    Singleton.instance.isVideoCompleted = false;
    _controller?.dispose();
    _controller?.removeListener(checkVideo);
  }

  void startLessionAPI(String secret) {
    late Map<String, String> body;
    body = {
      ApiParamters.secret: secret,
    };

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.startLession);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
          } else if (response.statusCode == 500) {
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          response.success = false;
          response.message = "Please check internet connection";
        }
      }
    });
  }

  void completeLessionAPI(String secret) {
    late Map<String, String> body;
    body = {
      ApiParamters.secret: secret,
    };

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.completeLession);

    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          if (response.statusCode == 200) {
          } else if (response.statusCode == 500) {
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          response.success = false;
          response.message = "Please check internet connection";
        }
      }
    });
  }

  void pauseLessionAPI(String secret, String duration) {
    late Map<String, String> body;
    body = {
      ApiParamters.secret: secret,
      ApiParamters.duration: duration,
    };

    late Map<String, String> header;
    header = {
      HttpHeaders.authorizationHeader: "Bearer ${Singleton.instance.AuthToken}",
    };

    final url = Uri.http(ApiConstants.BaseUrl,
        ApiConstants.BaseUrlHost + ApiConstants.pauseLession);

    Singleton.instance.showDefaultProgress();
    ApiService.postCallwithHeader(url, body, header, context).then((response) {
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        try {
          Singleton.instance.hideProgress();
          if (response.statusCode == 200) {
            var count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
          } else if (response.statusCode == 500) {
          } else if (response.statusCode == 501) {
            Singleton.instance.showAInvalidTokenAlertForLogout(
                context, Constant.alert, responseData["message"]);
          }
        } on SocketException {
          Singleton.instance.hideProgress();
          response.success = false;
          response.message = "Please check internet connection";
        } catch (e) {
          Singleton.instance.hideProgress();
        }
      }
    });
  }
}
