import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/Entity/background.dart';
import 'package:flutter_game/Entity/map.dart';

import 'Entity/player.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final CameraComponent cameraComponent;
  late MapGame mapGame;
  late TiledComponent tiledMap;
  late JoystickComponent joystick;
  late Player player = Player(Vector2(0, 0));
  //16:9
  // final Vector2 camSize = Vector2(560, 315);
  //20:9
  final Vector2 camSize = Vector2(700, 315);
  late HudButtonComponent jump_btn;
  final List<String> level = ['map1', 'map2'];

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    await images.loadAllImages();
    debugMode = true;

    await loadWorld();
    setJoyTick();
    setJumpBtn();
    setCamera();

    addAll([
      cameraComponent,
      mapGame,
      // btn,
    ]);

    return super.onLoad();
  }
  Future<void> loadWorld() async {
    tiledMap = await TiledComponent.load('${level[0]}.tmx', Vector2.all(16));
    // tiledMap = await TiledComponent.load('map4.tmx', Vector2.all(16));
    mapGame = MapGame(tiledMap, player);
  }

  void setCamera() {
    cameraComponent = CameraComponent.withFixedResolution(
        width: camSize.x,
        height: camSize.y,
        world: mapGame,
        backdrop: Background(size: camSize),
    );

    cameraComponent.viewfinder.anchor = Anchor.center;

    cameraComponent.setBounds(
      Rectangle.fromLTRB(
          camSize.x/2,
          camSize.y/2,
          mapGame.getWidth() - camSize.x/2,
          mapGame.getHeight() - camSize.y/2
      ),
    );

    cameraComponent.follow(player);

    cameraComponent.viewport.add(joystick);
    cameraComponent.viewport.add(jump_btn);
  }

  void setJoyTick() {
    final knobPaint = BasicPalette.white.withAlpha(100).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(50).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 15, paint: knobPaint),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
  }

  void setJumpBtn() {
    final btn  = BasicPalette.white.withAlpha(100).paint();
    final btnDown = BasicPalette.white.withAlpha(50).paint();
    final double size = 50;
    jump_btn = HudButtonComponent(
      margin: const EdgeInsets.only(right: 40, bottom: 30),
      button: CircleComponent(radius: size, paint: btn),
      buttonDown: CircleComponent(radius: size, paint: btnDown),
      onPressed: () {
        if(player.isOnGround) {
          player.velocity.y = -player.jump;
        }
      },
    );
  }
}