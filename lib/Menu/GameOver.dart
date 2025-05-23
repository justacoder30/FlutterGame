import 'package:flutter/material.dart';
import 'package:flutter_game/HeroGame.dart';

class GameOver extends StatelessWidget {
  final HeroGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hero Game',style: TextStyle(color: Colors.deepOrange,fontSize: 48,fontWeight: FontWeight.bold,),),
            SizedBox(height: 10,),
            Text("Score: ${game.score}", style: TextStyle(color: Colors.white,fontSize: 30),),
            SizedBox(height: 50,),

            ElevatedButton(
                onPressed: () {
                  game.overlays.remove('GameOver');
                  game.loadNextGame();
                },
                child: Text('Continute',style: TextStyle(color: Colors.red,fontSize: 40,fontWeight: FontWeight.bold,)))
          ],
        ),
      ),
    );
  }
}