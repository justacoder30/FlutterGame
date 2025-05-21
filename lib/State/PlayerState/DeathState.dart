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

    if(player.animationTicker!.done()) {
      player.game.loadNewGame();
      return IdleState();
    }

    return this;
  }

}