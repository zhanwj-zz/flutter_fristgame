
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'button_controller.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';

void main() {
//Flame.device.fullScreen();
 WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Scaffold(
      body: 
      GameWidget(
        game: MyGame(),
        overlayBuilderMap: {
         'ButtonController': (BuildContext context, MyGame game) {
          return   ButtonController(
            game: game,
          ); 
        }
      },
    ),
  )
  ));
}

class MyGame extends FlameGame with TapDetector,HasCollisionDetection {
  late SpriteAnimation rightAnimation; //向右移动动画
  late SpriteAnimation idleAnimation; //站立时动画
  late SpriteAnimation leftAnimation; //向左运动动画
  late SpriteAnimation rightupAnimation;
  late SpriteAnimation leftupAnimation;
  late SpriteAnimation rightsdownAnimation;
  late SpriteAnimation leftdownAnimation;

  late double mapWidth;
  late double mapHeight;

  //late SpriteComponent background1;
  late JiegeComponent jiege;

  int direction = 0;


    

  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final backgroundMap =await TiledComponent.load('map.tmx', Vector2.all(16));
    add(backgroundMap);

    mapHeight=backgroundMap.tileMap.map.width*16;
    mapWidth=backgroundMap.tileMap.map.height*16;

    final friendGroup=backgroundMap.tileMap.getLayer<ObjectGroup>('Friends');

    for(var friendBox in friendGroup!.objects){
      add(FriendComponent()
      ..position=Vector2(friendBox.x, friendBox.y)
      ..width=friendBox.width
      ..height=friendBox.height
      ..debugMode=true
      );
      
      
    }
    
    //mapWidth =backgroundMap.tileMap;

    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.load('zhijie.mp3');
    FlameAudio.bgm.play('zhijie.mp3');
    overlays.add('ButtonController');

    // Sprite backgroundSprite = await loadSprite('backgroud.png');
    // background1 = SpriteComponent()
    //   ..sprite = backgroundSprite
    //   ..size = backgroundSprite.originalSize;
    //add(background1);

    final spriteSheet = SpriteSheet(
        image: await images.load('player.png'), srcSize: Vector2(48, 48));

    rightAnimation = spriteSheet.createAnimation(row: 1, stepTime: 0.05, to: 6);
    idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: .2, to: 6);
    leftAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.05, to: 6 - 1);
    leftupAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.05, to: 6 - 1);
    rightupAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: 0.05, to: 6);
    leftdownAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: 0.05, to: 6 - 1);
    rightAnimation = spriteSheet.createAnimation(row: 1, stepTime: 0.05, to: 6);
    jiege = JiegeComponent()
      ..animation = idleAnimation
      ..position = Vector2(200, 400)
      ..debugMode=true
      ..size = Vector2.all(200);

    await add(jiege);
    
    camera.followComponent(jiege
        // worldBounds:
        //     Rect.fromLTWH(0, 0, background1.size.x, background1.size.y)
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (direction) {
      case 0:
        jiege.animation = rightAnimation;
        if (jiege.x < mapWidth) {
          jiege.x += 3;
        }
        break;
      case 1:
        jiege.animation = rightupAnimation;
        if (jiege.y > 200) {
          jiege.y -= 3;
        }
        break;
      case 2:
        jiege.animation = leftAnimation;
        if (jiege.x > 200) {
          jiege.x -= 3;
        }
        break;
      case 3:
        jiege.animation = leftdownAnimation;
        if (jiege.y <mapHeight) {
          jiege.y += 3;
        }
        break;
      case 4:
        jiege.animation = idleAnimation;

        break;
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    direction += 1;
    if (direction > 4) {
      direction = 0;
    }
    if (debugMode) {
          print('change animation');
        }
      }
  
      
}


class FriendComponent extends PositionComponent with GestureHitboxes,CollisionCallbacks{
  FriendComponent(){
    add(RectangleHitbox());
  }
  
  @override
  void onCollisionEnd(PositionComponent other){
    print('我嫩爹');
    super.onCollisionEnd(other);
  }
}

class JiegeComponent extends SpriteAnimationComponent with GestureHitboxes,CollisionCallbacks{
  JiegeComponent(){
    add(RectangleHitbox());
  }
}