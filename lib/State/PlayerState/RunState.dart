import 'package:flutter_game/State/PlayerState/IdleState.dart';

import '../../Entity/player.dart';
import 'FallState.dart';
import 'JumpState.dart';
import 'PlayerState.dart';

class RunState implements PlayerState {
  @override
  PlayerState update(Player player) {
    // TODO: implement update
    player.current = State.run;

    if (player.velocity.y < 0){
      return JumpState();
    }

    if (player.velocity.y > 0) {
      return Fallstate();
    }

    if (player.velocity.x == 0) {
      return IdleState();
    }

    return this;
  }

}