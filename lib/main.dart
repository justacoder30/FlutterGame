import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'HeroGame.dart';
import 'Menu/GameOver.dart';
import 'Menu/LoadingGame.dart';
import 'Menu/MainMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  HeroGame heroGame = await HeroGame();
  runApp(
    GameWidget(
      game: heroGame,
      overlayBuilderMap: {
        'LoadingGame': (_, game) => LoadingGame(game: heroGame),
        'MainMenu': (_, game) => MainMenu(game: heroGame),
        'GameOver': (_, game) => GameOver(game: heroGame),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
