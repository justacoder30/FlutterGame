import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/HeroGame.dart';

enum PlayerDirection {
  left,
  right,
  up,
  down,
  none
}

enum PlayerState {
  idle,
  run,
  fall,
  attack,
  jump
}

class Player extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, KeyboardHandler {
  Vector2 velocity = Vector2.zero();
  final double graviry = 1000;
  final double moveSpeed = 150;
  final double jump = 400;
  bool isFacingRight = true;
  PlayerDirection direction = PlayerDirection.none;


  Player({required Vector2 pos}) {
    position = pos;
  }

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    loadAnimation();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    updateVelocity(dt);

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    final bool is_A_Pressed = keysPressed.contains(LogicalKeyboardKey.keyA) ;
    final bool is_D_Pressed = keysPressed.contains(LogicalKeyboardKey.keyD) ;
    final bool is_S_Pressed = keysPressed.contains(LogicalKeyboardKey.keyS) ;
    final bool is_W_Pressed = keysPressed.contains(LogicalKeyboardKey.keyW) ;

    direction = PlayerDirection.none;

    if (is_A_Pressed && is_D_Pressed) {
      direction = PlayerDirection.none;
    } else if (is_A_Pressed) {
      direction = PlayerDirection.left;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
    } else if (is_D_Pressed) {
      direction = PlayerDirection.right;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
    } else if (is_W_Pressed) {
      direction = PlayerDirection.up;
    } else if (is_S_Pressed) {
      direction = PlayerDirection.down;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void updateVelocity(double dt) {
    // if (direction == PlayerDirection.none) {
    //   velocity.x = 0;
    // }
    double dirX = 0.0;
    switch(direction) {
      case PlayerDirection.left:
        dirX = -moveSpeed;
        break;
      case PlayerDirection.right:
        dirX = moveSpeed;
        break;
      case PlayerDirection.up:
        break;
      case PlayerDirection.down:
        break;
      case PlayerDirection.none:
        dirX = 0;
        break;
    }

    velocity.x = dirX;

    position += velocity * dt;
  }

  void loadAnimation() {
    animations = {
      PlayerState.idle: createAnimation(
          'Player/Idle.png',
          10,
          0.05,
          Vector2(120, 80)
      ),
      PlayerState.run: createAnimation(
          'Player/Run.png',
          10,
          0.04,
          Vector2(120, 80)
      ),

    };

    current = PlayerState.idle;
  }

  SpriteAnimation createAnimation(String dir, int amount, double stepTime, Vector2 texSize) {
    Image image  = game.images.fromCache(dir);
    SpriteAnimationData data = SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: texSize
    );

    return SpriteAnimation.fromFrameData(image, data);
  }
}