import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtube_downloader/youtube_downloader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Downloader',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Youtube Downloader'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: const HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final urlController = TextEditingController()
    ..text = 'https://www.youtube.com/watch?v=Hd3z2lH6BBM';
  String? videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'Paste YouTube link',
                      ),
                      onFieldSubmitted: submitForm,
                      validator: validate,
                    ),
                  ),
                  IconButton(
                    onPressed: () => submitForm(urlController.text),
                    icon: const Icon(Icons.search),
                  ),
                  const Tooltip(
                    child: Icon(Icons.info_outline),
                    message:
                        'URL Formats\nhttps://www.youtube.com/watch?v=videoId\nhttps://youtu.be/videoId',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            if (videoId != null)
              FutureBuilder<Media>(
                future: getData(videoId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else {
                    return (snapshot.hasError)
                        ? Text((snapshot.error as MediaException).code)
                        : ResultPane(video: snapshot.data!);
                  }
                },
              )
          ],
        ),
      ),
    );
  }

  void submitForm(String url) {
    setState(() {
      videoId = null;
    });
    final state = formKey.currentState;
    if (state == null || !state.validate()) return;
    final v = parseVideoId(url);
    print('fetching details for $v');
    setState(() {
      videoId = v;
    });
  }

  String parseVideoId(String url) {
    return (Uri.parse(url).queryParameters['v'] ?? '').trim();
  }

  String? validate(String? url) {
    if (url == null || parseVideoId(url).isEmpty) {
      return 'Invalid YouTube video URL';
    }
    return null;
  }
}

class ResultPane extends StatelessWidget {
  const ResultPane({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Media video;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //     color: Colors.grey[200],
    //   ),
    //   padding: const EdgeInsets.all(20),
    //   child: const AdaptiveResultPane(),
    // );
    return Card(
      elevation: 10,
      child: AdaptiveResultPane(video: video),
    );
  }
}

class AdaptiveResultPane extends StatelessWidget {
  const AdaptiveResultPane({
    Key? key,
    required this.video,
  }) : super(key: key);
  final Media video;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 700
            ? Column(
                children: [
                  Thumbnail(thumbnailData: video.thumbnailData),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DownloadDetails(
                      video: video,
                      vertical: true,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Thumbnail(thumbnailData: video.thumbnailData),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: DownloadDetails(
                      video: video,
                      vertical: false,
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class DownloadDetails extends StatelessWidget {
  const DownloadDetails({
    Key? key,
    required this.vertical,
    required this.video,
  }) : super(key: key);
  final Media video;
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          vertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          video.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(video.author),
        const SizedBox(
          height: 10,
        ),
        Text(video.duration),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Video',
                  filled: true,
                ),
                items: [
                  for (final v in video.videos)
                    DropdownMenuItem(
                      child: Text('$v'),
                      value: v.url,
                    ),
                ],
                onChanged: (value) {},
                value: video.videos[0].url,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(Icons.download),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Audio',
                  filled: true,
                ),
                items: [
                  for (final a in video.audios)
                    DropdownMenuItem(
                      child: Text('$a'),
                      value: a.url,
                    ),
                ],
                onChanged: (value) {},
                value: video.audios[0].url,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(Icons.download),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({Key? key, required this.thumbnailData}) : super(key: key);

  final String thumbnailData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.memory(const Base64Decoder().convert(thumbnailData)),
    );
  }
}
