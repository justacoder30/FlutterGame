import 'dart:async';
import 'dart:ffi';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_game/Entity/UI.dart';
import 'package:flutter_game/Entity/background.dart';
import 'package:flutter_game/Entity/map.dart';

import 'Entity/player.dart';

class HeroGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late CameraComponent cameraComponent;
  late MapGame mapGame;
  late UI ui;
  late TiledComponent tiledMap;
  late JoystickComponent joystick;
  late HudButtonComponent jump_btn;
  late Player player;
  int score = 0;
  //16:9
  // final Vector2 camSize = Vector2(560, 315);
  //20:9
  final Vector2 camSize = Vector2(700, 315);
  final List<String> level = ['map1', 'map2'];
  int currentLevel = 0;

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    // debugMode = true;
    await images.loadAllImages();
    await loadSound();

    await loadGame();

    return super.onLoad();
  }

  Future<void> loadNewGame() async {
    removeAll(children);
    await loadGame();
  }

  Future<void> loadGame() async {
    await loadWorld();
    setJoyTick();
    setJumpBtn();
    setCamera();

    addAll([
      cameraComponent,
      mapGame,
    ]);
  }

  Future<void> loadNextGame() async {
    removeAll(children);
    currentLevel++;
    if(currentLevel >= level.length) {
      currentLevel = 0;
      // return;
    }
    await loadGame();

  }

  Future<void> loadWorld() async {
    player = Player();
    tiledMap = await TiledComponent.load('${level[currentLevel]}.tmx', Vector2.all(16));
    mapGame = MapGame(tiledMap, player);
    ui = UI();
    score = 0;
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


    cameraComponent.viewport.addAll([
      ui,
      joystick,
      jump_btn,
    ]);
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

  Future<void> loadSound() async {
    await FlameAudio.audioCache.loadAll([
      'bg_music.ogg',
      'landing_sound.mp3',
      'coin_sound.mp3',
      'Hit_sound.mp3',
      'ButtonClick_sound.wav',
      'GameLose_sound.wav',
      'WinGame_sound.mp3',
    ]);

    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('bg_music.ogg', volume: 0.2);
  }
}