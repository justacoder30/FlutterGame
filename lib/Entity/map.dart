import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/Entity/Enemy.dart';
import 'package:flutter_game/Entity/Flag.dart';
import 'package:flutter_game/Entity/Heart.dart';
import 'package:flutter_game/Entity/player.dart';

import 'Coin.dart';
import 'RectBox.dart';

class MapGame extends World {
  late String level;
  late Player player;
  late TiledComponent map;
  List<RectBox> collisions = [];
  List<String> object_positions = ["PlayerPosition", "CoinPosition", "EnemyPosition", "HeartPosition", "FlagPostion"];

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
    for (var obj_pos in object_positions) {
      final position = map.tileMap.getLayer<ObjectGroup>(obj_pos);

      if (position == null) return;

      if (obj_pos == "PlayerPosition") {
        for (var pos in position.objects) {
          player.position = Vector2(pos.x + player.hitbox.width/2, pos.y + player.hitbox.height/2);
        }
      } else if (obj_pos == "CoinPosition") {
        for (var pos in position.objects) {
          add(
              Coin(position: pos.position)
          );
        }
      } else if (obj_pos == "EnemyPosition") {
        for (var pos in position.objects) {
          add(
              Enemy(pos.position)
          );
        }
      } else if (obj_pos == "HeartPosition") {
        for (var pos in position.objects) {
          add(
              Heart(position: pos.position)
          );
        }
      } else if (obj_pos == "FlagPostion") {
        for (var pos in position.objects) {
          add(
              Flag(position: pos.position)
          );
        }
      }
    }
  }
}