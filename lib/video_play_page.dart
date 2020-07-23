import 'dart:convert';

import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_viedeo_test/model/audio.dart';
import 'package:flutter_viedeo_test/model/audios.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_viedeo_test/model/subtitles.dart';
import 'package:just_audio2/just_audio.dart';
import 'model/subtitle.dart';

class VideoPlayPage extends StatefulWidget {
  VideoPlayPage({Key key}) : super(key: key);

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  bool showAdvertCover = false;
  bool showAudioCover = false;
  String m3u8Content;
  final String m3u8Url =
      "https://player.vimeo.com/external/440218055.m3u8?s=7ec886b4db9c3a52e0e7f5f917ba7287685ef67f&oauth2_token_id=1360367101";
  List<M3U8> m3u8List = List();
  List<AUDIO> audioList = List();
  var duration = 0;
  var seed;
  AudioPlayer _player;


  bool _isPlaying = false;
  bool _isFullscreen = false;

  bool get isPlaying => _isPlaying;
  set isPlaying(bool playing) {
    // print("playing  $playing");
    _isPlaying = playing;
  }

  @override
  void initState() {
    super.initState();
    getaudios();
    getm3u8s();
  }

  Future<AUDIOs> getaudios() async {
    RegExp regExp2 = new RegExp(
      r"""^#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="(.*)",NAME="(.*)",AUTOSELECT=(.*),DEFAULT=(.*),CHANNELS="(.*)",URI="(.*)""",
      caseSensitive: false,
      multiLine: true,
    );
    if (m3u8Content == null && m3u8Url != null) {
      http.Response response = await http.get(m3u8Url);
      if (response.statusCode == 200) {
        m3u8Content = utf8.decode(response.bodyBytes);
      }
    }
    List<RegExpMatch> matches2 = regExp2.allMatches(m3u8Content).toList();
    // Audio
    matches2.forEach((RegExpMatch regExpMatch) {
      String groupid = (regExpMatch.group(1)).toString();
      String name = (regExpMatch.group(1)).toString();
      String autoselect = (regExpMatch.group(1)).toString();
      String defult = (regExpMatch.group(1)).toString();
      String channels = (regExpMatch.group(1)).toString();
      String url = (regExpMatch.group(3)).toString();

      print(url);
      audioList.add(AUDIO(
          groupid: groupid,
          name: name,
          autoselect: autoselect,
          deafult: defult,
          channels: channels,
          url: url));
    });
    print(audioList);
    AUDIOs audios = AUDIOs(audios: audioList);
    return audios;
  }

  Future<M3U8s> getm3u8s() async {
    m3u8List.add(M3U8(quality: "Auto", url: m3u8Url));
    RegExp regExp = new RegExp(
      r"#EXT-X-STREAM-INF:(?:.*,RESOLUTION=(\d+x\d+))?,?(.*)\r?\n(.*)",
      caseSensitive: false,
      multiLine: true,
    );
    if (m3u8Content == null && m3u8Url != null) {
      http.Response response = await http.get(m3u8Url);
      if (response.statusCode == 200) {
        m3u8Content = utf8.decode(response.bodyBytes);
      }
    }
    print(m3u8Content);
    List<RegExpMatch> matches = regExp.allMatches(m3u8Content).toList();

    print("print ${m3u8List.length}");
    // Video
    matches.forEach((RegExpMatch regExpMatch) {
      String quality = (regExpMatch.group(1)).toString();
      String url = (regExpMatch.group(3)).toString();
      print(url);
      m3u8List.add(M3U8(quality: quality, url: url));
    });
    print(m3u8List);
    M3U8s m3u8s = M3U8s(m3u8s: m3u8List);
    print("m3u8s");
    return m3u8s;
  }

  String urlplay =
      "https://player.vimeo.com/external/440218055.m3u8?s=7ec886b4db9c3a52e0e7f5f917ba7287685ef67f&oauth2_token_id=1360367101";
  String qu = "Auto";
  String quaudio = "Audio";
  int startdu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AwsomeVideoPlayer(
              urlplay,
              playOptions: VideoPlayOptions(
                seekSeconds: 30,
                aspectRatio: 16 / 9,
                loop: true,
                autoplay: true,
                allowScrubbing: true,
                startPosition: Duration(seconds: startdu),
              ),
              children: [
                showAdvertCover
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: m3u8List
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        urlplay = e.url;
                                        qu = e.quality;
                                        quaudio = audioList[0].groupid;
                                        showAdvertCover = false;
                                        if (qu == "Auto") {
                                          
                                          _player.stop();
                                        } else {
                                          _player.setUrl(audioList[0].url);
                                          _player.stop();
                                          _player.play();
                                        }
                                      });
                                    },
                                    child: Container(
                                        color: Colors.white,
                                        width: 80,
                                        height: 30,
                                        child: Center(child: Text(e.quality))),
                                  ))
                              .toList(),
                        ),
                      )
                    : Align(),
                showAudioCover
                    ? Padding(
                        padding: EdgeInsets.only(right: 80.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: audioList
                                .map((e) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // urlplay = e.url;
                                          quaudio = e.groupid;
                                          showAudioCover = false;
                                          // if (qu == "Auto") {
                                          //   player.stop();
                                          // } else {
                                          //   player.stop();
                                          //   player.play();
                                          // }
                                        });
                                      },
                                      child: Container(
                                          color: Colors.white,
                                          width: 120,
                                          height: 30,
                                          child:
                                              Center(child: Text(e.groupid))),
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    : Align(),
              ],
              videoStyle: VideoStyle(
                  playIcon: Icon(
                    Icons.play_circle_outline,
                    size: 80,
                    color: Colors.white,
                  ),
                  videoLoadingStyle: VideoLoadingStyle(
                    loadingText: "Loading...",
                    loadingTextFontColor: Colors.white,
                    loadingTextFontSize: 20,
                  ),
                  videoControlBarStyle: VideoControlBarStyle(
                    itemList: [
                      "rewind",
                      "play",
                      "forward",
                      "position-time",
                      "progress",
                      "duration-time",
                      "fullscreen"
                    ],
                  ),
                  videoTopBarStyle: VideoTopBarStyle(
                    actions: [
                      qu == "Auto"
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  showAudioCover = true;
                                });
                              },
                              child: Text("Audio : $quaudio  ",
                                  style: TextStyle(color: Colors.green)),
                            ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showAdvertCover = true;
                          });
                        },
                        child: Text(
                          "Video : $qu",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),

              onpause: (value) {
                print("video paused");
                setState(() async {
                  // if (qu == "Auto") {
                  // } else {
                  //   player.pause();
                  // }
                  isPlaying = true;
                });
              },

              /// ဗွီဒီယိုပြန်ဖွင့်ခြင်း
              onplay: (value) {
                print("video played");
                setState(() async {
                  // if (qu == "Auto") {
                  // } else {
                  //   player.play();
                  //   await player.seek(Duration(seconds: startdu));
                  // }
                  isPlaying = true;
                });
              },

              /// ဗွီဒီယိုပြန်ဖွင့်အဆုံးပြန်ခေါ်
              onended: (value) {
                print("video ended");
                setState(() async {
                  // if (qu == "Auto") {
                  // } else {
                  //   player.stop();
                  // }
                  isPlaying = true;
                });
              },

              /// ဗွီဒီယိုပြန်ဖွင့်ခြင်းပြန်လည်တုံ့ပြန်မှု
              /// စာတန်းထိုးနှင့်ကိုက်ညီရန်အသုံးပြုနိုင်သည်
              ontimeupdate: (value) {
                setState(() {
                  // if (qu == "Auto") {
                  // } else {
                  //   player.seek(
                  //       Duration(microseconds: value.position.inMilliseconds));
                  // }
                  isPlaying = true;
                });
                // print("timeupdate ${value}");
                // var position = value.position.inMilliseconds / 1000;
              },

              onprogressdrag: (position, duration) {
                print("တည်နေ၇ာ： ${position}");
                print("စုစုပေါင်းအချိန်： ${duration}");
              },

              onvolume: (value) {
                print("onvolume ${value}");
              },

              onbrightness: (value) {
                print("onbrightness ${value}");
              },

              onfullscreen: (fullscreen) {
                print("is fullscreen $fullscreen");
                setState(() {});
              },

              /// ပြီးခဲ့သည့်စာမျက်နှာကိုပြန်သွားပါ
              onpop: (value) {
                print("ပြီးခဲ့သည့်စာမျက်နှာကိုပြန်သွားပါ");
              },
            ),
            // getsublist()
          ],
        ),
      ),
    );
  }
}
