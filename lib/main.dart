import 'package:flutter/material.dart';
import 'package:youtube_downloader/youtube.dart';

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
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final urlController = TextEditingController();
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
              FutureBuilder<Video>(
                future: getVideo(videoId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else {
                    return (snapshot.hasError)
                        ? Text('$snapshot.error')
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

  final Video video;

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
  final Video video;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 700
            ? Column(
                children: [
                  Thumbnail(thumbnailUrl: video.thumbnailUrl),
                  DownloadDetails(video: video),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Thumbnail(thumbnailUrl: video.thumbnailUrl),
                  DownloadDetails(video: video),
                ],
              );
      },
    );
  }
}

class DownloadDetails extends StatelessWidget {
  const DownloadDetails({
    Key? key,
    required this.video,
  }) : super(key: key);
  final Video video;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Chaos | Trashy Thursday',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('The Satya Show'),
          const SizedBox(
            height: 10,
          ),
          const Text('12.03'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                items: const [
                  DropdownMenuItem(
                    value: 'asssssss',
                    child: Text('assssssssssss'),
                  ),
                  DropdownMenuItem(
                    value: 'ab',
                    child: Text('ab'),
                  ),
                  DropdownMenuItem(
                    value: 'ad',
                    child: Text('ad'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Download'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({Key? key, required this.thumbnailUrl}) : super(key: key);

  final String thumbnailUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188,
      width: 336,
      padding: EdgeInsets.all(20),
      child: Placeholder(
        fallbackHeight: 100,
        fallbackWidth: 200,
      ),
    );
  }
}
