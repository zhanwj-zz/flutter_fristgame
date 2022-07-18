import 'package:flutter/material.dart';
import 'package:flutter_firstgame/main.dart';
import 'package:flame_audio/flame_audio.dart';

class ButtonController extends StatelessWidget {
  final MyGame game;
  const ButtonController({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: (){
            FlameAudio.bgm.play('zhijie.mp3');
          }, 
          icon: const Icon(Icons.volume_up_rounded),
          color: const Color.fromARGB(255, 2, 73, 4),
          iconSize: 100,
          ),
        IconButton(
          onPressed: (){
            FlameAudio.bgm.pause();
          }, 
          icon: const Icon(Icons.volume_off_rounded),
          color: const Color.fromARGB(255, 2, 73, 4),
          ),
      ],
    );
  }
}
