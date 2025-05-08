import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
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

class Player extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, KeyboardHandler{
  Vector2 velocity = Vector2.zero();
  final double graviry = 1000;
  final double moveSpeed = 150;
  final double jump = 400;

  bool isFacingRight = true;
  PlayerDirection direction = PlayerDirection.none;


  Player(Vector2 pos) : super(position: pos);

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
    // velocity.x = 0;
    // velocity.y = 0;
    // print(keysPressed.contains(LogicalKeyboardKey.keyA));
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ) {
      velocity.x = -100;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      velocity.x = 100;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ) {
      velocity.y = -100;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS)){
      velocity.y = 100;
    }
    return super.onKeyEvent(event, keysPressed);
  }


  void updateVelocity(double dt) {
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