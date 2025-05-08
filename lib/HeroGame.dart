import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'Entity/Player.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cameraComponent;
  late TiledComponent map;
  late World worldGame = World();
  late final Player player;
  final Vector2 camSize = Vector2(560, 315);

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();

    player = Player(Vector2(0, 0));
    map = await TiledComponent.load('map1.tmx', Vector2.all(16));
    print((map.width, map.height));
    worldGame.addAll([
      map,
      player
    ]);

    cameraComponent = CameraComponent.withFixedResolution(
        width: camSize.x,
        height: camSize.y,
        world: worldGame
    );
    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.setBounds(
      Rectangle.fromLTRB(
          camSize.x/2,
          camSize.y/2,
          map.width - camSize.x/2,
          map.height - camSize.y/2),
    );
    cameraComponent.follow(player);

    addAll([
      cameraComponent,
      worldGame,
    ]);
    return super.onLoad();
  }
}