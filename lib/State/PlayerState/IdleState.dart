import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/State/PlayerState/PlayerState.dart';

import 'FallState.dart';
import 'JumpState.dart';
import 'RunState.dart';

class IdleState implements PlayerState {
  @override
  PlayerState update(Player player) {
    // TODO: implement update
    player.current = State.idle;

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