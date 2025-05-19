import 'package:flutter_game/Entity/player.dart';
import 'package:flutter_game/State/PlayerState/FallState.dart';
import 'package:flutter_game/State/PlayerState/StateOfPlayer.dart';

class JumpState implements StateOfPlayer {
  @override
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.jump;
    player.isHit = false;

    if (player.velocity.y > 0) {
      return Fallstate();
    }

    return this;
  }

}