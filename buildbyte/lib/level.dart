import 'package:buildbyte/components.dart';
import 'package:buildbyte/load_assets.dart';
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

    // pointsText = TextComponent(
    // text: points.toString(),
    // position: Vector2(20, 20),
    // anchor: Anchor.topLeft,
    // textRenderer: TextPaint(
    //   style: TextStyle(
    //     color: Color(0xFF000000),
    //     fontSize: 18,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // priority: 100,
    // );

    // add(pointsText);

    // final invoice=Invoice();
    // final invoiceComp=TextComponent(
    // text: "RAM:${invoice.items['ram'].toString()}\nMotherboard:${invoice.items['motherboard'].toString()}\nGPU:${invoice.items['graphics_card']}",
    // position: Vector2(120, 2),
    // anchor: Anchor.topLeft,
    // textRenderer: TextPaint(
    //   style: TextStyle(
    //     color: Color(0xFF000000),
    //     fontSize: 18,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    // priority: 100,
    // );
    // add(invoiceComp);

  }

   Future<void> loadLevel(
    World world,
    String jsonPath,
    ByteGame game,
  ) async {
    AssetLoader.filePath=jsonPath;
    // Background
    await _loadBackground();
    // trash
    await _loadTrash();
    // case
    await _loadCase();
    // SnapZones
    _loadZones();

    // A test ram
    Sprite ram1=await AssetLoader.getSprite(game, "ram");
    add(
      DraggableComputerPart(
        sprite: ram1,
        size: Vector2(100,100),
        position: Vector2(50, 50),
        priority: 10,
        snapZones: zoneObjects,
        onCase: () {
          points+=10;
          pointsText.text = points.toString();
          
        },onTrash: () {
          points-=10;
          pointsText.text = points.toString();
        },onNothing: (){
        }
      ),
    );

    // // info panel
    // var sprite=await _loadSprite(game,"panel_glass.png",Rect.fromLTWH(0, 0, 100, 100));
    // world.add(SpriteComponent(
    //   sprite: sprite,
    //   size: Vector2(600,100),
    //   anchor: Anchor.topLeft,
    //   position: Vector2.zero(),
    //   priority: 100,
    // ));

  }

   void _loadZones() async{
    dynamic data=await AssetLoader.loadJSON(AssetLoader.filePath!);
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
      add(sz);
      zoneObjects.add(sz);
    }
  }

   Future<void> _loadCase() async {
    dynamic data=await AssetLoader.loadJSON(AssetLoader.filePath!);
    final caseInfo = data['case'];
    final caseSprite = await AssetLoader.caseSprite(game);
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
    add(caseComponent);
    zoneObjects.add(caseComponent);
  }

   Future<void> _loadTrash() async {
    dynamic data=await AssetLoader.loadJSON(AssetLoader.filePath!);
    final tInfo = data["trash"];
    final tSprite = await AssetLoader.trashSprite(game);
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
    add(trash);
    zoneObjects.add(trash);
  }

   Future<void> _loadBackground() async {
    
    final background = SpriteComponent(
      sprite: await AssetLoader.backgroundSprite(game),
      size: Vector2(ByteGame.width,ByteGame.height),
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
      priority: -2,
    );
    add(background);
  }


}
