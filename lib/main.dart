import 'package:flutter/material.dart';

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
          title: Text('Youtube Downloader'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Paste Youtube link',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Download'),
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 500,
                child: const Image(
                  image:
                      NetworkImage('https://i.ytimg.com/vi/VDqGoiOLld4/0.jpg'),
                ),
              ),
              Column(
                children: [
                  Text('Title'),
                  Text('Channel name'),
                  Text('duration'),
                  Row(
                    children: [
                      DropdownButton<String>(
                        items: const [
                          DropdownMenuItem(
                            value: 'a',
                            child: Text('a'),
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
                    ],
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
