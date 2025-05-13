import 'dart:async';

import 'package:flame/components.dart';

class Background extends SpriteComponent {

  Background({super.size});

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    sprite = await Sprite.load("Background/background.png");
    return super.onLoad();
  }
}