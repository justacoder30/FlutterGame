import 'package:flame_audio/flame_audio.dart';

import '../../Entity/player.dart';
import 'HurtState.dart';
import 'IdleState.dart';
import 'StateOfPlayer.dart';
import 'RunState.dart';

class Fallstate implements StateOfPlayer {
  @override
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.fall;

    if(player.isHit) {
      player.hp -= player.damageTaken;
      player.hitSound.start(volume: 1);
      return Hurtstate();
    }

    if(player.isOnGround) {
      if (player.velocity.x !=0) {
        return RunState();
      }
      return IdleState();
    }

    return this;
  }

}