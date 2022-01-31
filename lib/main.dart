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
  List<int> items = [];

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
  }

  @override
  void initState() {
    getDataFromSheets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData device = MediaQuery.of(context);
    int noOfItems = (device.size.width.toInt()) ~/ 100;
    var column2;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Muggle Music')),
      ),
      body: SafeArea(
        child: Column(
            key: column2,
            children: items
                .map((i) => Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: noOfItems,
                        itemBuilder: (context, index) {
                          return DatabaseTile(
                            image: image[index + (i * noOfItems)],
                            name: name[index + (i * noOfItems)],
                            year: year[index + (i * noOfItems)].toString(),
                            link: link[index + (i * noOfItems)],
                          );
                        },
                      ),
                    ))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (int i = 0; i <= name.length ~/ noOfItems; i++) {
            items.add(i);
          }
          setState(() {
            Column(
                key: column2,
                children: items
                    .map((i) => Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: noOfItems,
                            itemBuilder: (context, index) {
                              return DatabaseTile(
                                image: image[index + (i * noOfItems)],
                                name: name[index + (i * noOfItems)],
                                year: year[index + (i * noOfItems)].toString(),
                                link: link[index + (i * noOfItems)],
                              );
                            },
                          ),
                        ))
                    .toList());
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

  String imageMaker() {
    String newImage = image;
    String nameImage = name;
    newImage = newImage.replaceFirst(
        'https://github.com/', 'https://raw.githubusercontent.com/');
    newImage = newImage.replaceFirst('blob/main/Images/', 'main/Images/');
    newImage = newImage.replaceFirst('blob/web/Images/', 'web/Images/');
    if (newImage != image) {
      newImage = newImage + name + '.jpg';
    }
    if (nameImage.contains(' ')) {
      nameImage = name.replaceAll(' ', '%20');
    }
    if (newImage == '') {
      newImage =
          'https://raw.githubusercontent.com/mravinshu/mugglemusic/main/Images/' +
              nameImage +
              '.jpg';
    }
    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    String newImage = imageMaker();
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
                      image: newImage,
                    )),
          );
        },
        child: SizedBox(
          height: 20,
          child: Column(
            children: [
              Hero(
                tag: 'img',
                child: Image(
                  image: NetworkImage(newImage),
                  height: 80,
                  width: 80,
                ),
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
