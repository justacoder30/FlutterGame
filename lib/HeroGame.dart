import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/Entity/Backgroud.dart';
import 'package:flutter_game/Entity/map.dart';

import 'Entity/Player.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final CameraComponent cameraComponent;
  late MapGame mapGame;
  late TiledComponent tiledMap;
  late Player player = Player(Vector2(0, 0));
  final Vector2 camSize = Vector2(560, 315);
  final List<String> level = ['map1'];

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();

    await loadWorld();
    setCamera();

    addAll([
      cameraComponent,
      mapGame,
    ]);

    return super.onLoad();
  }
  Future<void> loadWorld() async {
    tiledMap = await TiledComponent.load('${level[0]}.tmx', Vector2.all(16));
    mapGame = MapGame(tiledMap, player);
  }

  void setCamera() {
    cameraComponent = CameraComponent.withFixedResolution(
        width: camSize.x,
        height: camSize.y,
        world: mapGame,
        backdrop: Background(),
    );
    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.setBounds(
      Rectangle.fromLTRB(
          camSize.x/2,
          camSize.y/2,
          mapGame.getWidth() - camSize.x/2,
          mapGame.getHeight() - camSize.y/2),
    );
    cameraComponent.follow(player);

  }
}