// import 'package:autism_visual_schedule/pages/login_page.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
// import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(const MyApp());
  runApp(GameWidget(game: MyGame()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     );
//   }
// }

final style = TextStyle(color: BasicPalette.white.color);
final regular = TextPaint(style: style);

class MyGame extends FlameGame with TapDetector, DoubleTapDetector {
  SpriteComponent background = SpriteComponent();
  SpriteComponent boy1 = SpriteComponent();
  SpriteComponent boy2 = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50.0, 50.0);
  bool playingMusic = false;
  int trackNumber = 1;

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 36));
  TextComponent instructions = TextComponent();
  final String instructionString = 'play: single tap\n'
      'stop: single tap\n'
      'next song: double tap';

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    const characterSize = 200.0;
    const textSize = 200.0;

    // load background
    background
      ..sprite = await loadSprite('background.jpg')
      ..size = Vector2(size[0], size[1] - 100);
    add(background);

    // load characters
    boy1
      ..sprite = await loadSprite('aarnav.png')
      ..y = screenHeight - characterSize - textSize
      ..anchor = Anchor.topCenter
      ..size = Vector2(characterSize, characterSize);
    add(boy1);

    boy2
      ..sprite = await loadSprite('sarjak.png')
      ..y = screenHeight - characterSize - textSize
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter
      ..size = Vector2(characterSize, characterSize);
    add(boy2);

    dialogButton
      ..sprite = await loadSprite('play_button.png')
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10)
      ..anchor = Anchor.topCenter
      ..size = buttonSize;
    add(dialogButton);

    instructions
      ..text = '$instructionString\n Track Number: $trackNumber'
      ..y = 100
      ..x = 20
      ..textRenderer = regular;
    add(instructions);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (boy1.x < size[0] / 2 - 100) {
      boy1.x += 30 * dt;
    }
    if (boy2.x > size[0] / 2 - 50) {
      boy2.x -= 30 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    dialogTextPaint.render(canvas, 'Hello guys', Vector2(10, size[1] - 100));
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!playingMusic) {
      playBackGroundAudio();
    } else {
      stopBackgroundAudio();
    }
  }

  @override
  void onDoubleTap() {
    trackNumber += 1;
    if (trackNumber > 4) {
      trackNumber = 1;
    }
    instructions.text = '$instructionString\n'
        'Track Number: $trackNumber\n'
        'status: Track Changed';
    // playBackGroundAudio();
  }

  void stopBackgroundAudio() {
    try {
      FlameAudio.bgm.stop();
    } catch (error) {
      // print(error);
    }
    instructions.text = '$instructionString\n'
        'Track Number: $trackNumber\n'
        'status: stopped';
    playingMusic = false;
  }

  void playBackGroundAudio() {
    try {
      switch (trackNumber) {
        case 1:
          FlameAudio.play('helloAarnav.mp3');
          break;
        case 2:
          FlameAudio.play('helloPranshu.mp3');
          break;
        case 3:
          // FlameAudio.bgm.play('helloSarjak.mp3');
          FlameAudio.play('helloSarjak.mp3');
          break;
        case 4:
          FlameAudio.play('helloShrimat.mp3');
          break;
      }
    } catch (error) {
      // print(error);
    }
    playingMusic = true;
    instructions.text = '$instructionString\n'
        'Track Number: $trackNumber\n'
        'status: playing';
  }
}

class DialogButton extends SpriteComponent
    with TapCallbacks, DoubleTapCallbacks {
  bool playingMusic = false;
  int trackNumber = 1;
  // @override
  // void onTapDown(TapDownEvent event) {
  //   try {
  //     if (!playingMusic) {
  //       switch (trackNumber) {
  //         case 1:
  //           FlameAudio.bgm.play('helloAarnav.mp3');
  //           playingMusic = true;
  //           break;
  //         case 2:
  //           FlameAudio.bgm.play('helloPranshu.mp3');
  //           playingMusic = true;
  //           break;
  //         case 3:
  //           FlameAudio.bgm.play('helloSarjak.mp3');
  //           playingMusic = true;
  //           break;
  //         case 4:
  //           FlameAudio.bgm.play('helloShrimat.mp3');
  //           playingMusic = true;
  //           break;
  //       }
  //     } else {
  //       FlameAudio.bgm.stop();
  //       playingMusic = false;
  //     }
  //   } catch (error) {
  //     // print(error);
  //   }
  // }

  // @override
  // void onDoubleTapUp(DoubleTapEvent event) {
  //   trackNumber += 1;
  //   if (trackNumber > 4) {
  //     trackNumber = 1;
  //   }
  // }
}
