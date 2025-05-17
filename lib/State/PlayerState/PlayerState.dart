import 'package:flutter_game/Entity/player.dart';

abstract class PlayerState {
  PlayerState update(Player player);
}