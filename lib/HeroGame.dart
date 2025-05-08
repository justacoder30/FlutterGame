import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import 'Entity/Player.dart';
import 'map.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents{
  late final MapGame map;
  late final CameraComponent cameraComponent;
  late final Player player;

  HeroGame() {
    WidgetsFlutterBinding.ensureInitialized();
    Flame.device.fullScreen();
    Flame.device.setLandscape();
  }

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();

    map = MapGame();
    player = Player(pos: Vector2(300, 20));

    cameraComponent = CameraComponent.withFixedResolution(
        width: 560,
        height: 315,
        world: map
    );
    map.add(player);

    cameraComponent.viewfinder.anchor = Anchor.center;
    cameraComponent.follow(player);

    addAll([
      cameraComponent,
      map,
    ]);
    return super.onLoad();
  }
}