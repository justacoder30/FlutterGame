import 'package:flutter/material.dart';
import 'package:flutter_game/HeroGame.dart';

class MainMenu extends StatelessWidget {
  final HeroGame game;
  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hero Game',style: TextStyle(color: Colors.deepOrange,fontSize: 48,fontWeight: FontWeight.bold,),),
            SizedBox(height: 50,),

            ElevatedButton(
                onPressed: () {
                  game.overlays.remove('MainMenu');
                  //game.overlays.add('LoadingGame');
                },
                child: Text('Play',style: TextStyle(color: Colors.red,fontSize: 40,fontWeight: FontWeight.bold,)
                ),
            ),
            //SizedBox(height: 50,),

          ],

        ),
      ),
    );
  }
}