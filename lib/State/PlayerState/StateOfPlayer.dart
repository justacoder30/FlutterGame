import 'package:flutter_game/Entity/player.dart';

abstract class StateOfPlayer {
  StateOfPlayer update(Player player);
}