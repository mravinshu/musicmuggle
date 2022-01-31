import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

AudioCache audioCache = AudioCache();
AudioPlayer advancedPlayer = AudioPlayer();
Icon player = const Icon(Icons.play_arrow);
Icon stop = const Icon(Icons.stop);

class Player extends StatefulWidget {
  final String name, link, image;
  const Player(
      {Key? key, required this.name, required this.link, required this.image})
      : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  int flag = 0;

  String linkMaker() {
    String newLink = widget.link;
    newLink = newLink.replaceFirst('https://drive.google.com/file/d/',
        'https://www.googleapis.com/drive/v3/files/');
    newLink = newLink.replaceFirst('/view?usp=sharing',
        '?alt=media&key=AIzaSyAHZvpRfSSLv8d-PAStwwTzmig4VGx3a1o');
    return newLink;
  }

  @override
  void initState() {
    advancedPlayer.onSeekComplete.listen((event) => setState(() {
          flag = 0;
          player = const Icon(Icons.play_arrow);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Card(
                child: Hero(
                  tag: 'img',
                  child: Image(
                    image: NetworkImage(widget.image),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String newLink = linkMaker();
                    if (flag == 0) {
                      flag = 1;
                      advancedPlayer.play(newLink);
                      setState(() {
                        player = const Icon(Icons.pause);
                      });
                    } else if (flag == 1) {
                      advancedPlayer.pause();
                      flag = 2;
                      setState(() {
                        player = const Icon(Icons.play_arrow);
                      });
                    } else if (flag == 2) {
                      advancedPlayer.resume();
                      flag = 1;
                      setState(() {
                        player = const Icon(Icons.pause);
                      });
                    }
                  },
                  child: player,
                ),
                ElevatedButton(
                    onPressed: () {
                      advancedPlayer.stop();
                      flag = 0;
                      setState(() {
                        player = const Icon(Icons.play_arrow);
                      });
                    },
                    child: stop)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
