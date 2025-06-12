import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/Entity/RectBox.dart';
import 'package:flutter_game/HeroGame.dart';
import 'package:flutter_game/State/PlayerState/DeathState.dart';
import 'package:flutter_game/State/PlayerState/IdleState.dart';
import 'package:flutter_game/State/PlayerState/StateOfPlayer.dart';

enum State {
  idle,
  run,
  fall,
  jump,
  hurt,
  death
}

class Player extends SpriteAnimationGroupComponent with HasGameReference<HeroGame>, KeyboardHandler{
  final double moveSpeed = 200;
  final texSize = Vector2(128, 128);
  double graviry = 500;
  double jump = 320;
  double jumpTime = 0.7;
  double jumpHeight = 100;
  bool isOnGround = false;
  bool isFacingRight = true;
  bool isJump = false;
  bool isHit = false;
  final double HP = 50;
  late double currentHP;
  double damageTaken = 0;
  Vector2 velocity = Vector2.zero();
  StateOfPlayer state = IdleState();

  RectBox hitbox = RectBox(
    position: Vector2(21, 64),
    size: Vector2(22, 64),
  );

  RectBox gravityBox = RectBox(
    position: Vector2(21, 128),
    size: Vector2(22, 3)
  );

  void setSpawnPoint(Vector2 pos) {
    position = Vector2(pos.x + hitbox.width/2, pos.y + hitbox.height/2);
    currentHP = HP;
  }

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad

    addAll([
      RectangleHitbox(
          position: hitbox.position,
          size: hitbox.size,
          collisionType: CollisionType.active
      ),
      RectangleHitbox(
        position: gravityBox.position,
        size: gravityBox.size,
        collisionType: CollisionType.inactive
      )
    ]);

    loadAnimation();
    // anchor = Anchor(0.1640625, 0.5);
    anchor = Anchor(0.25, 0.75);

    graviry = (2 * jumpHeight) /(jumpTime*jumpTime);
    jump = 2 * jumpHeight/ jumpTime;
    return super.onLoad();
  }

  bool isOutOfMap() {
    if(position.y > game.mapGame.getHeight()) {
      currentHP = 0;
      return true;
    }
    return false;
  }

  @override
  Future<void> update(double dt) async {
    // TODO: implement update
    updateState();
    updatePosition(dt);
    updateVelocity(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent

    final isSpacePressed = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpacePressed && isOnGround) {
      velocity.y = -jump;
    }


    return super.onKeyEvent(event, keysPressed);
  }

  void beingAttacked(double damage) {
    isHit = true;
    damageTaken = damage;
  }

  bool IsOnGround() {
    gravityBox.position = Vector2(position.x - hitbox.width/2, position.y + hitbox.height/2);
    for(var collision in game.mapGame.collisions) {
      if(gravityBox.isCollide(collision)) return true;
    }
    return false;
  }

  void updateGraviry(double dt) {
    isOnGround = IsOnGround();
  }

  void updateState() {
    if(currentHP <= 0  || isOutOfMap()) {
      state = DeathState();
    }

    state = state.update(this);
  }

  void updateVelocity(double dt) {
    updateGraviry(dt);
    velocity.x = 0;

    if(game.joystick.delta.x >= game.joystick.knobRadius/2) {
      velocity.x = moveSpeed;
      if (!isFacingRight) {
        flipHorizontally();
        isFacingRight = true;
      }
    } else if (game.joystick.delta.x <= - game.joystick.knobRadius/2) {
      velocity.x = -moveSpeed;
      if (isFacingRight) {
        flipHorizontally();
        isFacingRight = false;
      }
    }

  }

  void loadAnimation() {
    animations = {
      State.idle: createAnimation('Knight/Idle.png', 4, 0.17, true),
      State.run: createAnimation('Knight/Run.png', 7, 0.09, true),
      State.fall: createAnimation('Knight/Fall.png', 4, 0.135, false),
      State.jump: createAnimation('Knight/Jump.png', 2, 0.12, false),
      State.hurt: createAnimation('Knight/Hurt.png', 2, 0.2, false),
      State.death: createAnimation('Knight/Dead.png', 6, 0.1, false),
    };

    current = State.idle;
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
    position.x += velocity.x * dt;
    collision("x");
    position.y += velocity.y * dt + 0.5 * graviry * dt * dt;
    velocity.y += graviry * dt;
    collision("y");
  }

  void collision(String direction) {
    hitbox.position = Vector2(position.x - hitbox.width/2, position.y - hitbox.height/2);
    for (var collision in game.mapGame.collisions) {
      if (!hitbox.isCollide(collision)) continue;

      if(direction == "y") {
        if(velocity.y > 0) {
          position.y = collision.top - hitbox.height/2;
          isOnGround = true;
        } else if (velocity.y < 0) {
          position.y = collision.bottom + hitbox.height/2;
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

  Future<void> beingHit() async {
    currentHP -= damageTaken;
    game.hitSound.start(volume: 1);
    game.health.removeHearts();
  }
}