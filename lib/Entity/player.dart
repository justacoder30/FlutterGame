import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/Entity/RectBox.dart';
import 'package:flutter_game/HeroGame.dart';

enum PlayerState {
  idle,
  run,
  fall,
  attack1,
  attack2,
  attack3,
  jump
}

class Player extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, KeyboardHandler, CollisionCallbacks {
  final double graviry = 1000;
  // final double moveSpeed = 150;
  final double moveSpeed = 300;
  final double jump = 400;
  final texSize = Vector2(128, 128);
  bool isOnGround = false;
  Vector2 velocity = Vector2.zero();
  List<RectBox> collisionsBox = [];

  RectBox hitbox = RectBox(
    position: Vector2(21, 64),
    size: Vector2(22, 64),
  );

  RectBox attachBox = RectBox (
    position: Vector2(43, 60),
    size: Vector2(70, 68),
  );

  RectBox gravityBox = RectBox(
    position: Vector2(21, 128),
    size: Vector2(22, 1)
  );

  bool isFacingRight = true;
  Player(Vector2 pos) : super(position: pos);

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad

    add(RectangleHitbox(
      position: hitbox.position,
      size: hitbox.size
    ));

    add(RectangleHitbox(
        position: attachBox.position,
        size: attachBox.size
    ));

    add(RectangleHitbox(
        position: gravityBox.position,
        size: gravityBox.size
    ));

    loadAnimation();
    // anchor = Anchor(0.1640625, 0.5);
    anchor = Anchor(0.25, 0.75);
    // anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    updateVelocity(dt);
    updatePosition(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent

    final isAKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isDKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD);
    final isSKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS);
    final isWKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW);
    final isFKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyF);
    final isJKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyJ);
    final isSpacePressed = keysPressed.contains(LogicalKeyboardKey.space);

    print(keysPressed.contains(LogicalKeyboardKey.keyD));
    if (isFKeyPressed) {
      velocity.x = 0;
      velocity.y = 0;
      current = PlayerState.idle;
    }

    if (isJKeyPressed) {
      current = PlayerState.attack1;
    }

    if (isAKeyPressed) {
      velocity.x = -moveSpeed;
      current = PlayerState.run;
      if (isFacingRight) {
        flipHorizontally();
        isFacingRight = false;
      }
    }
    if (isDKeyPressed) {
      velocity.x = moveSpeed;
      current = PlayerState.run;
      if (!isFacingRight) {
        flipHorizontally();
        isFacingRight = true;
      }
    }

    if (isSpacePressed && isOnGround) {
      velocity.y = -jump;
    }

    if (isWKeyPressed) {
      velocity.y = -100;
    }
    if (isSKeyPressed) {
      velocity.y = 100;
    }


    return super.onKeyEvent(event, keysPressed);
  }

  bool IsOnGround() {
    gravityBox.position = Vector2(position.x - hitbox.width/2, position.y + hitbox.height/2);
    for(var collision in collisionsBox) {
      if(gravityBox.isCollide(collision)) return true;
    }
    return false;
  }

  void updateGraviry(double dt) {
    isOnGround = IsOnGround();
    if(!isOnGround)
      velocity.y += graviry * dt;
  }

  void updateVelocity(double dt) {
    velocity.x *= 0.99;

    if(velocity.x.abs() <= 90) {
      current = PlayerState.idle;
      velocity.x = 0;
    }

    // print(velocity.x.abs());

    updateGraviry(dt);
  }

  void loadAnimation() {
    animations = {
      PlayerState.idle: createAnimation('Knight/Idle.png', 4, 0.17),
      PlayerState.run: createAnimation('Knight/Run.png', 7, 0.09),
      PlayerState.attack1: createAnimation('Knight/Attack 1.png', 5, 0.08),
    };

    current = PlayerState.idle;
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

  void updatePosition(double dt) {
    position.x += velocity.x * dt;
    collision("x");
    position.y += velocity.y * dt;
    collision("y");
  }

  void collision(String direction) {
    hitbox.position = Vector2(position.x - hitbox.width/2, position.y - hitbox.height/2);
    for (var collision in collisionsBox) {
      if (!hitbox.isCollide(collision)) continue;

      if(direction == "y") {
        if(velocity.y > 0) {
          position.y = collision.top - hitbox.height/2;
          isOnGround = true;
        } else if (velocity.y < 0) {
          position.y = collision.bottom + hitbox.height/2 + 1;
        }
        velocity.y = 0;
      }else if(direction == "x") {
        if(velocity.x > 0) {
          position.x = collision.left - hitbox.width/2;
        } else if (velocity.x < 0) {
          position.x = collision.right + hitbox.width/2;
        }
        velocity.x = 0;
      }

    }
  }
}