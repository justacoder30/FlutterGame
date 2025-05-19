import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/HeroGame.dart';

class Coin extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>{
  final texSize = Vector2.all(16);

  Coin({super.position});

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive
      )
    );

    animations = {
      "Idle": createAnimation("Item/Coin.png", 5, 0.08)
    };

    current = "Idle";

    return super.onLoad();
  }

  SpriteAnimation createAnimation(String dir, int amount, double stepTime) {
    Image image  = game.images.fromCache(dir);
    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: texSize,
    );

    return SpriteAnimation.fromFrameData(image, data);
  }
}