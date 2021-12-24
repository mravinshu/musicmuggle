import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

AudioCache audioCache = AudioCache();
AudioPlayer advancedPlayer = AudioPlayer();
IconData play = Icons.play_arrow;
Icon player = Icon(Icons.play_arrow);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: Card(
                child: Image(
                  image: NetworkImage(widget.image),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (flag == 0) {
                  flag = 1;
                } else {
                  flag = 0;
                }
              },
              child: IconButton(
                icon: player,
                onPressed: () async {
                  if (flag == 0) {
                    await advancedPlayer.play(widget.link);

                    setState(() {
                      player = Icon(Icons.pause);
                    });
                  } else {
                    advancedPlayer.pause();
                    setState(() {
                      player = Icon(Icons.play_arrow);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
