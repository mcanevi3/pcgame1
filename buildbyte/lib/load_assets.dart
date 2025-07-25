import 'dart:convert';
import 'package:buildbyte/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class AssetLoader{
  static String? filePath;

  static Future<dynamic> loadJSON(String path) async {
    String jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

   static Future<Sprite> loadSpriteFromImage(
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

  static Future<Sprite> spriteFromJSON(ByteGame game,String name) async{
      
      dynamic data=await AssetLoader.loadJSON(filePath!);
      String path=data[name]["image"];
      dynamic reg=data[name]["src"];
      Rect region=Rect.fromLTWH(reg[0].toDouble(),
          reg[1].toDouble(),
          reg[2].toDouble(),
          reg[3].toDouble());
      return loadSpriteFromImage(game, path, region);
  }

  static Future<Sprite> caseSprite(ByteGame game)=>spriteFromJSON(game,"case");
  static Future<Sprite> trashSprite(ByteGame game)=>spriteFromJSON(game,"trash");
  static Future<Sprite> backgroundSprite(ByteGame game)=>spriteFromJSON(game,"background");

  static Future<SpriteComponent> caseSpriteComponent(ByteGame game)async{
    dynamic data=await AssetLoader.loadJSON(filePath!);
    dynamic caseSize=data["case"]["size"];
    dynamic casePosition=data["case"]["position"];
    return  SpriteComponent(
      sprite: await caseSprite(game),
      size: Vector2(caseSize[0].toDouble(),caseSize[1].toDouble()),
      anchor: Anchor.topLeft,
      position: Vector2(casePosition[0].toDouble(),casePosition[1].toDouble()),
      priority: 1,
    );
  }

  static Future<SpriteComponent> trashSpriteComponent(ByteGame game)async{
    dynamic data=await AssetLoader.loadJSON(filePath!);
    dynamic trashSize=data["trash"]["size"];
    dynamic trashPosition=data["trash"]["position"];
    return  SpriteComponent(
      sprite: await trashSprite(game),
      size: Vector2(trashSize[0].toDouble(),trashSize[1].toDouble()),
      anchor: Anchor.topLeft,
      position: Vector2(trashPosition[0].toDouble(),trashPosition[1].toDouble()),
      priority: 1,
    );
  }

  // components
  static Future<Sprite> getSprite(dynamic game,String name) async {
    dynamic data=await AssetLoader.loadJSON(filePath!);
    dynamic components=data["components"];

    String path=components[name]["image"];
    dynamic reg=components[name]["src"];
    Rect region=Rect.fromLTWH(reg[0].toDouble(),
          reg[1].toDouble(),
          reg[2].toDouble(),
          reg[3].toDouble());
    return loadSpriteFromImage(game, path, region);
  }

  static Future<SpriteComponent> getSpriteComponent(dynamic game,String name,Vector2 size,Vector2 position) async {
    return SpriteComponent(
      sprite: await getSprite(game,name),
      size: size,
      anchor: Anchor.topLeft,
      position: position,
      priority: 1,
    );

  }

}
