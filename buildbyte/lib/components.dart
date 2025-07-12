import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DraggableComputerPart extends SpriteComponent with DragCallbacks {
  final List<SnapZone> snapZones;
  final VoidCallback? onTrash;
  final VoidCallback? onCase;
  final VoidCallback? onNothing;

  late final Vector2 originalPosition;
  late int oldPriority;

  DraggableComputerPart({this.onTrash, this.onCase,this.onNothing,
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    required int priority,
    required this.snapZones,
  }) : super(
         sprite: sprite,
         size: size,
         position: position,
         priority: priority,
       ) {
    originalPosition = position.clone();
    oldPriority = priority;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
    priority = 10;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    bool snapped=false;
    for(final snapTarget in snapZones){
      
      if((position - snapTarget.position).length < 30)
      {
        position = snapTarget.position.clone();
        priority = oldPriority;
        snapped=true;

        if(snapTarget.id=="trash")
        {
          onTrash!();
        }else if(snapTarget.id=="case")
        {
          onCase!();
        }else 
        {
          onNothing!();
        }
        break;
      }
    }
    if(!snapped)
    {
      position=originalPosition.clone();
    }
  }
}

class SnapZone extends RectangleComponent {
  final String? id;
  SnapZone({
    required Vector2 position,
    required Vector2 size,
    Color color = const Color(0x55FFFFFF), // semi-transparent white
    int priority = 9,
    this.id,
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
    super.id,
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

class Invoice{
  late Map<String,int> items;

  Invoice(){
    items = {};
    addItem('ram',2);
    addItem('graphics_card',1);
    addItem('motherboard',1);

  }
  void addItem(String name, int quantity) {
    if (items.containsKey(name)) {
      items[name] = items[name]! + quantity;
    } else {
      items[name] = quantity;
    }
  }
}