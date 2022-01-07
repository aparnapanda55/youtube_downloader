import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Video {
  final String title;
  final String author;
  final String duration;
  final String thumbnailUrl;
  final List<DownloadUrl> downloadUrls;

  Video({
    required this.title,
    required this.author,
    required this.duration,
    required this.thumbnailUrl,
    required this.downloadUrls,
  });
  @override
  String toString() {
    return '<Video $title ($author)>';
  }

  static final _formatter = NumberFormat('00');

  static String _duration(String value) {
    final time = int.parse(value);
    final hour = time ~/ 3600;
    final minutes = (time % 3600) ~/ 60;
    final seconds = (time % 3600) % 60;
    final h = _formatter.format(hour);
    final m = _formatter.format(minutes);
    final s = _formatter.format(seconds);

    return hour == 0 ? '$m:$s' : '$h:$m:$s';
  }

  static List<DownloadUrl> _urls(Map<String, dynamic> data) {
    return [
      ...data['streamingData']['formats'],
      ...data['streamingData']['adaptiveFormats'],
    ]
        .map((e) => DownloadUrl(
              quality: 'quality',
              size: 'size',
              url: 'url',
            ))
        .toList();
  }

  factory Video.fromJson(Map<String, dynamic> data) {
    return Video(
      title: data['videoDetails']['title'],
      author: data['videoDetails']['author'],
      duration: _duration(data['videoDetails']['lengthSeconds']),
      thumbnailUrl: data['videoDetails']['thumbnail']['thumbnails'][0]['url']
          .split('?')[0],
      downloadUrls: _urls(data),
    );
  }
}

class DownloadUrl {
  final String quality;
  final String size;
  final String url;

  DownloadUrl({
    required this.quality,
    required this.size,
    required this.url,
  });
}

Future<Video> getVideo(String videoId) async {
  final url =
      'https://mcaij3hdak.execute-api.ap-south-1.amazonaws.com/watch?v=$videoId';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    throw Exception('status: ${res.statusCode}');
  }
  final data = jsonDecode(res.body);
  return Video.fromJson(data);
}
