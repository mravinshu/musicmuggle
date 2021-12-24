import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:audioplayers/audioplayers.dart';
import 'package:music/player.dart';

void main() {
  runApp(const MyApp());
}

AudioCache audioCache = AudioCache();
AudioPlayer advancedPlayer = AudioPlayer();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muggle Music',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> name = [];
  List<int> year = [];
  List<String> link = [];
  List<String> image = [];

  getDataFromSheets() async {
    var raw = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbztHS_sZI87hv6mAS7stwgDCVIe5O5-eI0ka34JJhiM21HbvHAoATzWh-qdU_zj0Aoktg/exec"));

    var jsonData = convert.jsonDecode(raw.body);
    jsonData.forEach((element) {
      name.add(element['name']);
      year.add(element['year']);
      link.add(element['link']);
      image.add(element['image']);
    });
    print('used');
  }

  @override
  void initState() {
    getDataFromSheets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muggle Music'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: name.length,
        itemBuilder: (context, index) {
          return DatabaseTile(
            image: image[index],
            name: name[index],
            year: year[index].toString(),
            link: link[index],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: name.length,
              itemBuilder: (context, index) {
                return DatabaseTile(
                  image: image[index],
                  name: name[index],
                  year: year[index].toString(),
                  link: link[index],
                );
              },
            );
          });
        },
      ),
    );
  }
}

class DatabaseTile extends StatelessWidget {
  final String name, year, link, image;
  // ignore: use_key_in_widget_constructors
  const DatabaseTile(
      {required this.link,
      required this.name,
      required this.year,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Player(
                      name: name,
                      link: link,
                      image: image,
                    )),
          );
        },
        child: SizedBox(
          height: 20,
          child: Column(
            children: [
              Image(
                image: NetworkImage(image),
                height: 80,
                width: 80,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
