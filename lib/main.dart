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
          title: const Text('Youtube Downloader'),
        ),
        body: const HomePage(),
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
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(color: Colors.blue, width: 7.0),
              ),
              labelText: 'Paste Youtube link',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Search'),
          ),
          const SizedBox(
            height: 50,
          ),
          const ResultPane()
        ],
      ),
    );
  }
}

class ResultPane extends StatelessWidget {
  const ResultPane({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 188,
            width: 336,
            child: Placeholder(
              fallbackHeight: 100,
              fallbackWidth: 200,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Column(
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
          )
        ],
      ),
    );
  }
}
