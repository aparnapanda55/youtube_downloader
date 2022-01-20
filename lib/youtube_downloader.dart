import 'dart:convert';

import 'package:http/http.dart' as http;

class Media {
  final String videoId;
  final String title;
  final String author;
  final String thumbnailData;
  final String duration;
  final List<Video> videos;
  final List<Audio> audios;

  Media({
    required this.title,
    required this.videoId,
    required this.author,
    required this.thumbnailData,
    required this.duration,
    required this.videos,
    required this.audios,
  });

  factory Media.fromJson(Map<String, dynamic> data) {
    return Media(
      title: data['title'],
      videoId: data['videoId'],
      author: data['author'],
      thumbnailData: data['thumbnailData'],
      duration: data['duration'],
      videos: [for (final video in data['video']) Video.fromJson(video)],
      audios: [for (final audio in data['audio']) Audio.fromJson(audio)],
    );
  }

  @override
  String toString() {
    return '<Media:$videoId $title by $author>';
  }
}

abstract class UrlItem {
  final String url = '';
}

class Video implements UrlItem {
  final String format;
  final String quality;
  final String size;
  @override
  final String url;

  Video({
    required this.format,
    required this.quality,
    required this.size,
    required this.url,
  });

  factory Video.fromJson(Map<String, dynamic> data) {
    return Video(
      format: data['format'],
      quality: data['quality'],
      size: data['size'],
      url: data['url'],
    );
  }

  @override
  String toString() {
    return size.isEmpty ? '$format/$quality' : '$format/$quality - $size';
  }
}

class Audio implements UrlItem {
  final String format;
  final String codecs;
  final String bitrate;
  final String size;
  @override
  final String url;

  Audio({
    required this.format,
    required this.codecs,
    required this.bitrate,
    required this.size,
    required this.url,
  });

  factory Audio.fromJson(Map<String, dynamic> data) {
    return Audio(
      format: data['format'],
      codecs: data['codecs'],
      bitrate: data['bitrate'],
      size: data['size'],
      url: data['url'],
    );
  }

  @override
  String toString() {
    return size.isEmpty
        ? '$format/$codecs - $bitrate'
        : '$format/$codecs - $bitrate - $size';
  }
}

class MediaException implements Exception {
  final String code;

  MediaException(this.code);
}

Future<Media> getData(String videoId) async {
  final url =
      'https://mcaij3hdak.execute-api.ap-south-1.amazonaws.com/watch?v=$videoId';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    try {
      return Media.fromJson(jsonDecode(res.body));
    } catch (e) {
      throw MediaException('internal-error');
    }
  } else if (res.statusCode == 404) {
    throw MediaException('not-found');
  } else {
    throw MediaException('internal-error');
  }
}

void main(List<String> args) async {
  print(await getData('VDqGoiOLld4'));
}
