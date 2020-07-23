// import 'dart:convert';
// import 'package:flutter_viedeo_test/model/subtitle.dart';
// import 'package:http/http.dart' as http;

// import 'model/subtitles.dart';

// class M3U8ListController {
//   String m3u8Content;
//   String m3u8Url;


//   M3U8ListController({
//     this.m3u8Url,
//     this.m3u8Content,

//   });

//   Future<M3U8s> getm3u8s() async {
//     RegExp regExp = new RegExp(
//       r"#EXT-X-STREAM-INF:(?:.*,RESOLUTION=(\d+x\d+))?,?(.*)\r?\n(.*)",
//       caseSensitive: false,
//       multiLine: true,
//     );
//     if (m3u8Content == null && m3u8Url != null) {
//       http.Response response = await http.get(m3u8Url);
//       if (response.statusCode == 200) {
//         m3u8Content = utf8.decode(response.bodyBytes);
//       }
//     }
//     print(m3u8Content);

//     List<RegExpMatch> matches = regExp.allMatches(m3u8Content).toList();
//     List<M3U8> m3u8List = List();
//     print("print ${m3u8List.length}");
//     matches.forEach((RegExpMatch regExpMatch) {
//       // print("print startTimeHours : ${regExpMatch.group(2)}");

//       String quality = (regExpMatch.group(1)).toString();
//       String url = (regExpMatch.group(3)).toString();

//       print(url);

//       m3u8List.add(M3U8(quality: quality, url: url));
//     });

//     print(m3u8List);

//     M3U8s m3u8s = M3U8s(m3u8s: m3u8List);
//     print("m3u8s");
//     return m3u8s;
//   }
// }
