import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DraggableComputerPart extends SpriteComponent with DragCallbacks {
  late final Vector2 originalPosition;
  final Vector2 snapTarget;
  late int oldPriority;
  DraggableComputerPart({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    required int priority,
    required this.snapTarget,
  }) : super(
         sprite: sprite,
         size: size,
         position: position,
         priority: priority,
       ) {
    originalPosition = position.clone();
    oldPriority = priority;
  }

  bool get isNearSnapTarget => (position - snapTarget).length < 30;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
    priority = 10;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    position = isNearSnapTarget ? snapTarget.clone() : originalPosition.clone();
    priority = oldPriority;
  }
}

class SnapZone extends RectangleComponent {
  SnapZone({
    required Vector2 position,
    required Vector2 size,
    Color color = const Color(0x55FFFFFF), // semi-transparent white
    int priority = 9,
  }) : super(
         position: position,
         size: size,
         paint: Paint()..color = color,
         priority: priority,
       );
}

class ImageSnapZone extends SnapZone {
  late SpriteComponent imageComponent;

  ImageSnapZone({
    required Sprite sprite,
    required super.position,
    required super.size,
    super.color = const Color(0x55FFFFFF),
    super.priority = 9,
  }) {
    imageComponent = SpriteComponent(
      sprite: sprite,
      size: size,
      position: Vector2.zero(),
      anchor: Anchor.topLeft,
      priority: priority + 1,
    );
    add(imageComponent);
  }
}