
import '../../Entity/player.dart';
import 'FallState.dart';
import 'HurtState.dart';
import 'IdleState.dart';
import 'JumpState.dart';
import 'StateOfPlayer.dart';

class RunState implements StateOfPlayer {
  @override
  //error
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.run;

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

    if (player.velocity.x == 0) {
      return IdleState();
    }
    return this;
  }

}