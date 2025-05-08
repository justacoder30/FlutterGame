import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'HeroGame.dart';

void main() {
  HeroGame game = HeroGame();
  runApp(GameWidget(game: game));
}