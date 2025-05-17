import 'package:flutter_game/State/PlayerState/IdleState.dart';

import '../../Entity/player.dart';
import 'PlayerState.dart';

class Fallstate implements PlayerState {
  @override
  PlayerState update(Player player) {
    // TODO: implement update
    player.current = State.fall;

    if(player.isOnGround) {
      return IdleState();
    }

    return this;
  }

}