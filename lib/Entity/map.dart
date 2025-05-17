import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/Entity/player.dart';

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

    addAll([
      map,
      player,
    ]);

    addCollision();
    addObjects();



    return super.onLoad();
  }

  double getWidth() {
    return map.width;
  }

  double getHeight() {
    return map.height;
  }

  void addCollision() {
    final Collisions = map.tileMap.getLayer<ObjectGroup>('Collision');

    if (Collisions == null) return;

    for (var collision in Collisions.objects) {
      final block = RectBox(
        position: Vector2(collision.x, collision.y),
        size: Vector2(collision.width, collision.height),
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
    }
  }
}