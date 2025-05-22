import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../HeroGame.dart';

class LoadingGame extends StatefulWidget {
  final HeroGame game;
  const LoadingGame({super.key, required this.game});

  @override
  State<LoadingGame> createState() => _LoadingGameState();
}

class _LoadingGameState extends State<LoadingGame> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10), () {
      widget.game.overlays.remove('LoadingGame');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 10,

            ),
            SizedBox(height: 10,),
            Text('Loading...',style: TextStyle(fontSize: 20,color: Colors.blue),)
          ],
        ),

      ),
    );
  }
}
