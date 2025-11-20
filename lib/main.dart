import 'package:flutter/material.dart';

import 'core/themes/theme.dart';
import 'utils/screen_util/screen_util.dart';
import 'views/animations/explicit/animated_prompt.dart';
import 'views/animations/explicit/animation_polygon.dart';
import 'views/animations/explicit/bouncing_position.dart';
import 'views/animations/explicit/bouncing_size.dart';
import 'views/animations/explicit/cube_3d.dart';
import 'views/animations/explicit/drawer_3d.dart';
import 'views/animations/explicit/ticker_animation.dart';
import 'views/animations/explicit/transform_clip_path.dart';
import 'views/animations/explicit/transform_rotation.dart';
import 'views/animations/explicit/transitions.dart';
import 'views/animations/implicit/animated_list_view.dart';
import 'views/animations/implicit/animated_widgets.dart';
import 'views/animations/implicit/hero_animations.dart';
import 'views/animations/implicit/tween_builders.dart';
import 'views/home/home_view.dart';

void main() {
  runApp(const CustomUIComponents());
}

class CustomUIComponents extends StatelessWidget {
  const CustomUIComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.I.configureScreen(constraints.biggest);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter UI Library',
          theme: lightTheme,
          navigatorKey: navigatorKey,
          initialRoute: "/",
          routes: {
            "/": (context) => const HomeView(),
            ...implicitAnimations,
            ...explicitAnimations,
          },
        );
      },
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

Map<String, WidgetBuilder> get implicitAnimations {
  return {
    "/Animated Widget": (context) => const AnimatedWidgets(),
    "/Tween Builder": (context) => const TweenBuilders(),
    "/Hero Animation": (context) => const HeroAnimation(),
    "/Animated List View": (context) => const AnimatedListView(),
  };
}

Map<String, WidgetBuilder> get explicitAnimations {
  return {
    "/Ticker": (context) => const TickerAnimation(),
    "/Transition Animation": (context) => const TransitionAnimation(),
    "/Bouncing Position": (context) => const BouncingPosition(),
    "/Bouncing Size": (context) => const BouncingSize(),
    "/Transform Rotation": (context) => const TransformRotation(),
    "/Transform Clip Path": (context) => const TransformClipPath(),
    "/Cube 3D": (context) => const Cube3D(),
    "/Animation With Polygon": (context) => const AnimationWithPolygon(),
    "/Drawer 3D": (context) => const Drawer3D(),
    "/Animated Prompt": (context) => const AnimatedPrompt(),
  };
}
