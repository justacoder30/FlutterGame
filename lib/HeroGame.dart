import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'Entity/Player.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cameraComponent;
  late TiledComponent map;
  late World worldGame = World();
  late final Player player;

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();

    player = Player(Vector2(0, 0));
    map = await TiledComponent.load('map1.tmx', Vector2.all(16));
    worldGame.addAll([
      map,
      player
    ]);

    cameraComponent = CameraComponent.withFixedResolution(
        width: 560,
        height: 315,
        world: worldGame
    );
    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.follow(player);
    addAll([
      cameraComponent,
      worldGame,
    ]);
    return super.onLoad();
  }
}