import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MapGame extends World {
  late TiledComponent mapComponent;

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    mapComponent = await TiledComponent.load('map1.tmx', Vector2.all(16));
    add(mapComponent);

    return super.onLoad();
  }
}