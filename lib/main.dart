import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_downloader/youtube_downloader.dart';

void main() {
  runApp(const MyApp());
}

const appName = 'Youtube Downloader';
const appDescription = 'Download YouTube videos & audios for free';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Downloader',
      home: Scaffold(
        drawer: const AppDrawer(appName: appName),
        appBar: AppBar(
          title: const Text(appName),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const HomePage(),
          ),
        ),
      ),
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.downloading,
      size: size,
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.appName}) : super(key: key);

  final String appName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: const AppIcon(size: 50),
            applicationName: appName,
            applicationVersion: '1.0.0',
            applicationLegalese: '\u{a9} 2022 Aparna Panda',
            aboutBoxChildren: const [
              SizedBox(height: 24),
              Text(appDescription),
            ],
          ),
        ],
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

  final urlController = TextEditingController();
  String? videoId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppIcon(size: 100),
            Text(
              appDescription,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              'Paste the link in format: https://www.youtube.com/watch?v=videoId',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: 'Paste YouTube link',
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              videoId = null;
                              urlController.clear();
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                      onFieldSubmitted: submitForm,
                      validator: validate,
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    onPressed: () => submitForm(urlController.text),
                    icon: const Icon(Icons.search),
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
                  }
                  if (snapshot.hasData) {
                    return ResultPane(video: snapshot.data!);
                  }
                  final error = snapshot.error as MediaException;
                  if (error.code == 'not-found') {
                    return const Text(
                        'The requested video does not exist. Please check in YouTube and try again.');
                  }
                  return const Text(
                      'Some internal error occured. Please try again later.');
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
        return constraints.maxWidth < 600
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DownloadDetails(
                        video: video,
                        vertical: false,
                      ),
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
        DownloadMenu(
          title: video.title,
          items: video.videos,
          label: 'Video',
        ),
        const SizedBox(
          height: 10,
        ),
        DownloadMenu(
          title: video.title,
          items: video.audios,
          label: 'Audio',
        ),
        const SizedBox(height: 10),
        Text(
          'If the browser starts to play the media instead of downloading, you can save it with ctrl+s, cmd+s or phones Save As button.',
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

class DownloadMenu<T extends UrlItem> extends StatefulWidget {
  const DownloadMenu({
    Key? key,
    required this.title,
    required this.items,
    required this.label,
  }) : super(key: key);

  final String title;
  final List<T> items;
  final String label;

  @override
  State<DownloadMenu> createState() => _DownloadMenuState();
}

class _DownloadMenuState<T extends UrlItem> extends State<DownloadMenu<T>> {
  late T selectedItem;

  @override
  void initState() {
    selectedItem = widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: DropdownButtonFormField<T>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: widget.label,
              filled: true,
            ),
            items: [
              for (final item in widget.items)
                DropdownMenuItem(
                  child: Text('$item'),
                  value: item,
                ),
            ],
            onChanged: (value) {
              setState(() {
                selectedItem = value!;
              });
            },
            value: selectedItem,
          ),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: selectedItem.url));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Download link for $selectedItem copied to clipboard!'),
              ),
            );
          },
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          iconSize: 30,
          onPressed: () {
            final fileName = '${widget.title}.${selectedItem.format}';
            final a = AnchorElement(href: selectedItem.url);
            a.download = fileName;
            a.click();
          },
          icon: const Icon(Icons.download),
        ),
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
      padding: const EdgeInsets.only(left: 16.0),
      child: Image.memory(const Base64Decoder().convert(thumbnailData)),
    );
  }
}
