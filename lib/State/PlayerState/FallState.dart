
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
      player.beingHit();
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