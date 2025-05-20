import '../../Entity/player.dart';
import 'IdleState.dart';
import 'StateOfPlayer.dart';

class DeathState implements StateOfPlayer {
  @override
  StateOfPlayer update(Player player) {
    // TODO: implement update
    player.current = State.death;
    player.velocity.x = 0;
    player.isHit = false;

    if(player.animationTicker!.isLastFrame) {
      player.reSpawn();
      return IdleState();
    }

    return this;
  }

}