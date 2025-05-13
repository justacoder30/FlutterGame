import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/Entity/rect.dart';

import 'RectBox.dart';

class MapGame extends World {
  late String level;
  late Player player;
  late TiledComponent map;
  List<RectBox> collisions = [];

  MapGame(this.map, this.player);

  @override
  FutureOr<void> onLoad() async {
    player.position = Vector2(250, 130);

    addCollision();
    addObjects();

    addAll([
      map,
      player,
      RectangleCollidable(Vector2(30, 30)),
    ]);

    return super.onLoad();
  }

  double getWidth() {
    return map.width;
  }

  double getHeight() {
    return map.height;
  }

  void addCollision() {
    final boxs = map.tileMap.getLayer<ObjectGroup>('Collision');

    if (boxs == null) return;

    for (var box in boxs.objects) {
      final block = RectBox(
        position: Vector2(box.x, box.y),
        size: Vector2(box.width, box.height),
      );
      collisions.add(block);
      add(block);
    }
  }

  void addObjects() {
    final position = map.tileMap.getLayer<ObjectGroup>("PlayerPosition");

    if (position == null) return;

    for (var pos in position.objects) {
      player.position = Vector2(pos.x, pos.y);
      player.collisionsBox = collisions;
    }
  }
}