import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/State/PlayerState/IdleState.dart';
import 'package:flutter_game/State/PlayerState/JumpState.dart';
import 'package:flutter_game/State/PlayerState/StateOfPlayer.dart';

import 'StateOfPlayer.dart';

class Hurtstate implements StateOfPlayer {
  @override
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.hurt;
    player.isHit = false;
    player.damageTaken = 0;
    player.velocity.x = 0;

    if(player.velocity.y < 0) {
      return JumpState();
    }

    if (player.animationTicker!.isLastFrame) {
      return IdleState();
    }

    return this;
  }

}