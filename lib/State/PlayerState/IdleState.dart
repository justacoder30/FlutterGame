import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/State/PlayerState/HurtState.dart';
import 'package:flutter_game/State/PlayerState/StateOfPlayer.dart';

import 'FallState.dart';
import 'JumpState.dart';
import 'RunState.dart';

class IdleState implements StateOfPlayer {
  @override
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.idle;

    if(player.isHit) {
      player.beingHit();
      return Hurtstate();
    }

    if (player.velocity.y < 0){
      return JumpState();
    }

    if (player.velocity.y > 0) {
      return Fallstate();
    }

    if (player.velocity.x != 0) {
      return RunState();
    }

    return this;
  }
}