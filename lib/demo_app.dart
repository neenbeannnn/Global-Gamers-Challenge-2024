import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:demo_app/components/player.dart';
import 'package:demo_app/components/level.dart';
import 'package:flutter/painting.dart';

class DemoApp extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    //Loads images into cache
    await images.loadAllImages();

    final world = Level(player: player, levelName: 'Level-01');

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.priority = 0;
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 1,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      knobRadius: 50,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      case JoystickDirection.upLeft:
        player.horizontalMovement = -1;
        player.hasJumped = true;
        break;
      case JoystickDirection.upRight:
        player.horizontalMovement = 1;
        player.hasJumped = true;
        break;
      case JoystickDirection.up:
        player.hasJumped = true;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
