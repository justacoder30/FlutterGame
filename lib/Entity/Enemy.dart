import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_game/Entity/RectBox.dart';
import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/HeroGame.dart';



class Enemy extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, CollisionCallbacks {
  final double moveSpeed = 70;
  final double damage = 10;
  final texSize = Vector2(96, 64);
  bool isFacingRight = true;
  Vector2 velocity = Vector2.zero();

  RectBox hitbox = RectBox(
    position: Vector2(40, 16),
    size: Vector2(16, 48),
  );

  RectBox edgeBox = RectBox(
    position: Vector2(56, 64),
    size: Vector2(2, 2),
  );

  Enemy(Vector2 pos) {
    position = Vector2(pos.x + hitbox.width/2, pos.y + hitbox.height/2);
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    addAll([
      RectangleHitbox(
          position: hitbox.position,
          size: hitbox.size,
          collisionType: CollisionType.passive
      ),
      RectangleHitbox(
          position: edgeBox.position,
          size: edgeBox.size,
          collisionType: CollisionType.inactive
      ),
    ]);

    loadAnimation();
    anchor = Anchor(0.5, 0.625);

    velocity.x = moveSpeed;

    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is Player) game.player.beingAttacked(damage);
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    updateVelocity(dt);
    updatePosition(dt);
    super.update(dt);
  }

  void updateVelocity(double dt) {

    if(isEdge() || isHitWall()) velocity.x *= -1;

    if(velocity.x > 0) {
      if (!isFacingRight) {
        flipHorizontally();
        isFacingRight = true;
      }
    } else if (velocity.x < 0) {
      if (isFacingRight) {
        flipHorizontally();
        isFacingRight = false;
      }
    }

  }

  void loadAnimation() {
    animations = {
      "Run": createAnimation('Enemy/Walk.png', 10, 0.05, true),
    };

    current = "Run";
  }

  SpriteAnimation createAnimation(String dir, int amount, double stepTime, bool loop) {
    Image image  = game.images.fromCache(dir);
    SpriteAnimationData data = SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: texSize,
      loop: loop,
    );

    return SpriteAnimation.fromFrameData(image, data);
  }

  void updatePosition(double dt) {
    position += velocity * dt;
  }

  bool isHitWall() {
    hitbox.position = Vector2(position.x - hitbox.width/2, position.y - hitbox.height/2);
    for (var collision in game.mapGame.collisions) {
      if (hitbox.isCollide(collision)) {
        if(velocity.x > 0) {
          position.x = collision.left - hitbox.width/2;
        } else if( velocity.x < 0 ) {
          position.x = collision.right + hitbox.width/2;
        }

        return true;
      }
    }
    return false;
  }

  bool isEdge() {
    edgeBox.position.x = isFacingRight ? position.x + hitbox.width/2 : position.x - hitbox.width/2 - edgeBox.width;
    edgeBox.position.y = position.y + hitbox.height/2;
    for(var collision in game.mapGame.collisions) {
      if(edgeBox.isCollide(collision)) return false;
    }
    return true;
  }
}