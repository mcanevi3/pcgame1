import 'package:buildbyte/level.dart';
import 'package:buildbyte/menu.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  final game = ByteGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'PauseMenu': (context, game) => PauseMenu(game as ByteGame),
      },
    ),
  );
}

class ByteGame extends FlameGame with KeyboardEvents{
  bool isPaused = false;
  static const double width=700;
  static const double height=400;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(width, height));
    camera.moveTo(Vector2(width, height) / 2);
    overlays.add('PauseMenu');
  }

  void startGame() async{
    overlays.remove('PauseMenu');
    world = Level(game: this);
    debugPrint('Game Started!');
    isPaused = false;
  }

  void stopGame() {
    overlays.add('PauseMenu');
    debugPrint('Game Stopped!');
    world = World(); // empty world
    isPaused = true;
  }


  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      isPaused ? startGame() : stopGame();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
