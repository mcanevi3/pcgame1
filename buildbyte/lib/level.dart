import 'dart:convert';
import 'package:buildbyte/components.dart';
import 'package:buildbyte/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Level extends World{
  final ByteGame game;
  final List<SnapZone> zoneObjects = [];

  late TextComponent pointsText;
  int points=0;
  
  Level({required this.game});
  
  @override
  Future<void> onLoad() async {
    await loadLevel(
      this,
      'assets/levels/level1.json',
      game,
    );

    pointsText = TextComponent(
    text: points.toString(),
    position: Vector2(20, 20),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: TextStyle(
        color: Color(0xFF000000),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    priority: 100,
    );

    add(pointsText);
  }

   Future<void> loadLevel(
    World world,
    String jsonPath,
    ByteGame game,
  ) async {
    final jsonString = await rootBundle.loadString(jsonPath);
    final data = json.decode(jsonString);
    
    // Background
    await _loadBackground(data, world);
    // trash
    await _loadTrash(data, game, world);
    // case
    await _loadCase(data, game, world);
    // SnapZones
    _loadZones(data, world);

    // A test ram
    final comp=data['components'];
    final ram=comp["ram"];
    var sprite = await _loadSprite(
        game,
        ram['image'],
        Rect.fromLTWH(
          ram['src'][0].toDouble(),
          ram['src'][1].toDouble(),
          ram['src'][2].toDouble(),
          ram['src'][3].toDouble(),
        ),
      );
    final srcZone = zoneObjects[2];
    
    world.add(
      DraggableComputerPart(
        sprite: sprite,
        size: srcZone.size,
        position: srcZone.position,
        priority: 10,
        snapZones: zoneObjects,
        onCase: () {
          print("case");
          points+=10;
          pointsText.text = points.toString();
          
        },onTrash: () {
          points-=10;
          pointsText.text = points.toString();
        },onNothing: (){
          print("nothing");
        }
      ),
    );

    // info panel
    sprite=await _loadSprite(game,"panel_glass.png",Rect.fromLTWH(10, 10, 100, 100));
    world.add(SpriteComponent(
      sprite: sprite,
      size: Vector2(100,100),
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
      priority: 100,
    ));

  }

   void _loadZones(dynamic data, World world) {
    final List snapZones = data['zones'];
    
    for (final zone in snapZones) {
      final color = Color(int.parse(zone['color'].replaceFirst('#', '0x')));
      final sz = SnapZone(
        position: Vector2(
          zone['position'][0].toDouble(),
          zone['position'][1].toDouble(),
        ),
        size: Vector2(zone['size'][0].toDouble(), zone['size'][1].toDouble()),
        color: color,
      );
      world.add(sz);
      zoneObjects.add(sz);
    }
  }

   Future<void> _loadCase(dynamic data, ByteGame game, World world) async {
    // case
    final caseInfo = data['case'];
    final caseSprite = await _loadSprite(game,caseInfo['image'],Rect.fromLTWH(
          caseInfo['src'][0].toDouble(),
          caseInfo['src'][1].toDouble(),
          caseInfo['src'][2].toDouble(),
          caseInfo['src'][3].toDouble(),
      ));
    final caseSize = Vector2(
       caseInfo['size'][0].toDouble(),
       caseInfo['size'][1].toDouble(),
     );
    final casePos = Vector2(
       caseInfo['position'][0].toDouble(),
       caseInfo['position'][1].toDouble(),
     );
    ImageSnapZone caseComponent = ImageSnapZone(
      sprite: caseSprite,
      size: caseSize,
      position: casePos,
      priority: 1,
      id:"case"
    );
    world.add(caseComponent!);
    zoneObjects.add(caseComponent!);
  }

   Future<void> _loadTrash(dynamic data, ByteGame game, World world) async {
  
    // trash
    final tInfo = data['trash'];
    final tSprite = await _loadSprite(game,tInfo['image'],Rect.fromLTWH(
          tInfo['src'][0].toDouble(),
          tInfo['src'][1].toDouble(),
          tInfo['src'][2].toDouble(),
          tInfo['src'][3].toDouble(),
      ));
    final tSize = Vector2(
       tInfo['size'][0].toDouble(),
       tInfo['size'][1].toDouble(),
     );
    final tPos = Vector2(
       tInfo['position'][0].toDouble(),
       tInfo['position'][1].toDouble(),
     );
    final trash = ImageSnapZone(
      sprite: tSprite,
      size: tSize,
      position: tPos,
      priority: 1,
      id: 'trash',
    );
    world.add(trash);
    zoneObjects.add(trash);
  }

   Future<void> _loadBackground(dynamic data, World world) async {
    // Background
    final bgInfo = data['background'];
    final bgSprite = await Sprite.load(bgInfo['image']);
    final bgSize = Vector2(
      bgInfo['size'][0].toDouble(),
      bgInfo['size'][1].toDouble(),
    );
    final background = SpriteComponent(
      sprite: bgSprite,
      size: bgSize,
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
      priority: -2,
    );
    world.add(background);
  }

   Future<Sprite> _loadSprite(
    ByteGame game,
    String path,
    Rect region,
  ) async {
    final image = await game.images.load(path);
    return Sprite(
      image,
      srcPosition: Vector2(region.left, region.top),
      srcSize: Vector2(region.width, region.height),
    );
  }

}
