import 'package:ui_library/utils/screen_util/screen_util.dart';

extension NumExtension<T extends num> on T {
  T get avoidNegativeValue => (this < 0 ? 0 : this) as T;

  T get scaledByDPR => (this * ScreenUtil.I.devicePixelRatio) as T;
}
