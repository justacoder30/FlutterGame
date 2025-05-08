import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MapGame extends World {
  late TiledComponent mapComponent;

  @override
  FutureOr<void> onLoad() async {
    return super.onLoad();
  }
}