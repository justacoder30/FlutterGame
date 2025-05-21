import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/HeroGame.dart';

class Heart extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, CollisionCallbacks {
  final texSize = Vector2(18, 14);
  final score = 20;
  final health = 10;

  Heart({super.position});

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    add(
        RectangleHitbox(
            collisionType: CollisionType.passive
        )
    );

    animations = {
      "Idle": createAnimation("Item/Big Heart Idle (18x14).png", 8, 0.08)
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if(other is Player) {
      // game.player.collectSound.start(volume: 0.7);
      game.score += score;
      game.player.currentHP += health;
      game.ui.increaseHeart();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}