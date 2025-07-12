
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Level extends World with HasGameReference<FlameGame> {
  @override
  Future<void> onLoad() async {
    debugPrint("Level loaded");

    await _addBackground('bg2.png', Vector2(844, 390));

    final caseSprite = await _loadSprite('case1.png', Rect.fromLTWH(250, 250, 700, 700));
    final caseComponent = SpriteComponent(
      sprite: caseSprite,
      size: Vector2(128, 128),
      position: Vector2(300, 130),
    );
    add(caseComponent);

    final mbSprite = await _loadSprite('motherboard1.png', Rect.fromLTWH(250, 250, 600, 600));
    final mbComponent = DraggableMotherboard(
      sprite: mbSprite,
      size: Vector2(128, 128),
      position: Vector2(100, 120),
      priority: 1,
      snapTarget: caseComponent.position.clone(),
    );
    add(mbComponent);

    final gcSprite = await _loadSprite('graphics_card1.png', Rect.fromLTWH(250, 250, 600, 600));
    final gcComponent = DraggableMotherboard(
      sprite: gcSprite,
      size: Vector2(128, 128),
      position: Vector2(100, 120),
      priority: 2,
      snapTarget: caseComponent.position.clone(),
    );
    add(gcComponent);

    final ramSprite = await _loadSprite('ram1.png', Rect.fromLTWH(40, 250, 900, 600));
    final ramComponent = DraggableMotherboard(
      sprite: ramSprite,
      size: Vector2(128, 128),
      position: Vector2(100, 120),
      priority: 3,
      snapTarget: caseComponent.position.clone(),
    );
    add(ramComponent);
  }

  Future<void> _addBackground(String imagePath, Vector2 size) async {
    final bgSprite = await Sprite.load(imagePath);
    final background = SpriteComponent(
      sprite: bgSprite,
      size: size,
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
      priority: -1,
    );
    add(background);
  }

  Future<Sprite> _loadSprite(String path, Rect region) async {
    final image = await game.images.load(path);
    return Sprite(
      image,
      srcPosition: Vector2(region.left, region.top),
      srcSize: Vector2(region.width, region.height),
    );
  }
}


class DraggableMotherboard extends SpriteComponent with DragCallbacks {
  late final Vector2 originalPosition;
  final Vector2 snapTarget;
  late int oldPriority;
  DraggableMotherboard({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    required int priority,
    required this.snapTarget,
  }) : super(sprite: sprite, size: size, position: position,priority: priority) {
    originalPosition = position.clone();
    oldPriority=priority;
  }

  bool get isNearSnapTarget => (position - snapTarget).length < 30;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
    priority=10;
    
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    position = isNearSnapTarget ? snapTarget.clone() : originalPosition.clone();
    priority=oldPriority;
  }
}
