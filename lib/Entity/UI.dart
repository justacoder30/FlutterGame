import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter_game/HeroGame.dart';

class UI extends PositionComponent with HasGameReference<HeroGame> {
  final Vector2 texSize = Vector2.all(16);
  List<SpriteComponent> heartlist = [];
  late int numHeart;

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    await loadHearts();
    return super.onLoad();
  }

  int setNumHeart() {
    return ((game.player.currentHP -1 + 10) / 10).toInt();
  }

  Future<void> loadHearts() async {
    numHeart = setNumHeart();

    for (var i=0; i<numHeart; i++) {
      heartlist.add(
        SpriteComponent(
            sprite: await Sprite.load('Item/hearts.png'),
            position: Vector2(texSize.x * i, 0),
            size: texSize
        )
      );
    }

    for(var i=0; i < heartlist.length; i++) {
      add(heartlist[i]);
    }
  }

  void removeHearts() {
    final newNumHeart = setNumHeart();
    print((newNumHeart, numHeart));
    while (newNumHeart < numHeart ) {
      heartlist[--numHeart].removeFromParent();
      heartlist.removeAt(numHeart);
    }
  }
}