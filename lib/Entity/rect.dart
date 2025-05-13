import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../HeroGame.dart';

class RectangleCollidable extends PositionComponent with HasGameReference<HeroGame>, CollisionCallbacks {
  final _collisionStartColor = Colors.amber;
  final _defaultColor = Colors.cyan;
  late ShapeHitbox hitbox;

  RectangleCollidable(Vector2 position)
      : super(
    position: position,
    size: Vector2.all(50),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;
    hitbox = RectangleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;

    add(hitbox);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollisionStart
    hitbox.paint.color = _collisionStartColor;
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    hitbox.paint.color = _defaultColor;
    super.onCollisionEnd(other);
  }


}