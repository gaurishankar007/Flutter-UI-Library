import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

part 'screen_metrics.dart';
part 'screen_type.dart';

/// Provides screen size measurements
class ScreenUtil {
  factory ScreenUtil() => _singleton;
  ScreenUtil._();
  static final ScreenUtil _singleton = ScreenUtil._();
  static ScreenUtil I = ScreenUtil();

  double _width = 0;
  double _height = 0;
  double _devicePixelRatio = 0;
  double _statusBarHeight = 0;
  Orientation _orientation = Orientation.portrait;
  ScreenType _type = ScreenType.unknown;

  double get height => _height;
  double get width => _width;

  /// Physical pixels on the screen ↔️ Logical (Flutter) pixels you work with.
  ///
  /// 🔍 Example:
  ///
  /// Let’s say you're working on a phone with:
  /// - A screen resolution of 1080 × 1920 (physical pixels)
  /// - And the screen size in Flutter is 360 × 640 logical pixels
  /// - Then the devicePixelRatio = 1080 / 360 = 3.0
  double get devicePixelRatio => _devicePixelRatio;

  /// Height of the system top status bar
  double get statusBarHeight => _statusBarHeight;

  ScreenType get type => _type;

  Orientation get orientation => _orientation;

  /// Set screen dimensions, orientation, screen type, etc.
  void configureScreen([ScreenMetrics? screenMetrics]) {
    screenMetrics ??= _getScreenDetails();

    _height = screenMetrics.logicalSize.height;
    _width = screenMetrics.logicalSize.width;
    _devicePixelRatio = screenMetrics.devicePixelRatio;
    _statusBarHeight = 0;
    _type = _getScreenType();
    _orientation = _height > _width
        ? Orientation.portrait
        : Orientation.landscape;
  }

  ScreenMetrics _getScreenDetails() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalSize = view.physicalSize;
    final devicePixelRatio = view.devicePixelRatio;
    final logicalSize = Size(
      physicalSize.width / devicePixelRatio,
      physicalSize.height / devicePixelRatio,
    );

    return ScreenMetrics(
      logicalSize: logicalSize,
      physicalSize: physicalSize,
      devicePixelRatio: devicePixelRatio,
    );
  }

  ScreenType _getScreenType() {
    if (width <= 360) {
      return ScreenType.compact;
    } else if (width <= 600) {
      return ScreenType.phone;
    } else if (width <= 840) {
      return ScreenType.tablet;
    } else if (width <= 1024) {
      return ScreenType.largeTablet;
    }
    return ScreenType.desktop;
  }

  void setPhoneViewGlobalOrientation({bool allowLandscape = false}) {
    final shortestSide = _width < _height ? _width : _height;
    final isPhoneView = shortestSide <= 600;
    if (isPhoneView) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        if (allowLandscape) ...[
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      ]);
    }
  }

  /// Get the required number within the limitation
  double _limitedNumber(double number, {double? min, double? max}) {
    if (min != null && number < min) {
      return min;
    } else if (max != null && number > max) {
      return max;
    }
    return number;
  }

  /// Required percentage of height with limitation
  double heightPart(double percentage, {double? min, double? max}) {
    final double height = percentage / 100 * _height;
    if (min == null && max == null) {
      return height;
    }
    return _limitedNumber(height, min: min, max: max);
  }

  /// Required percentage of width with limitation
  double widthPart(double percentage, {double? min, double? max}) {
    final double width = percentage / 100 * _width;
    if (min == null && max == null) {
      return width;
    }
    return _limitedNumber(width, min: min, max: max);
  }

  /// The first matching screen type value is returned otherwise use [base].
  T responsiveValue<T>({
    required T base,
    required Map<Set<ScreenType>, T> screens,
  }) {
    for (final entry in screens.entries) {
      if (entry.key.contains(_type)) {
        return entry.value;
      }
    }
    return base;
  }

  /// Get adapted values for compact and small screens otherwise use [base]
  T mobileValue<T>({required T base, required T mobile}) => responsiveValue(
    base: base,
    screens: {
      {.compact, .phone}: mobile,
    },
  );

  /// Whether the screen falls within smartphone view or not
  bool get isWithinPhoneView => _type.index <= ScreenType.phone.index;

  /// Whether the screen's shortest side is within phone view, even in landscape.
  bool get isWithinActualPhoneView {
    final shortestSide = _width < _height ? _width : _height;
    return shortestSide <= 600;
  }

  /// Whether the screen falls within the tablet view or not
  bool get isWithinTabletView => _type.index <= ScreenType.tablet.index;

  /// Whether the screen is desktop view or not
  bool get isDesktopView {
    if (kIsWeb) {
      return _type == ScreenType.desktop;
    } else {
      return _type == ScreenType.desktop &&
          _orientation == Orientation.landscape;
    }
  }

  /// View horizontal padding
  double get horizontalSpace => responsiveValue(
    base: 24,
    screens: {
      {.compact, .phone}: 16,
      {.desktop}: 32,
    },
  );

  /// View vertical padding
  double get verticalSpace => mobileValue(base: 32, mobile: 16);

  /// View horizontal padding
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: horizontalSpace);

  /// View horizontal padding
  EdgeInsets get verticalPadding =>
      EdgeInsets.symmetric(vertical: verticalSpace);

  /// View padding
  EdgeInsets screenPadding() => EdgeInsets.symmetric(
    horizontal: horizontalSpace,
    vertical: verticalSpace,
  );

  /// Width of the screen excluding left and right screen padding.
  double availableWidth({double extraSpace = 0}) =>
      width - (horizontalSpace * 2) - extraSpace;

  /// Spacing between the grid items.
  /// 12 grid columns for desktop and 4 grid columns for tablet/mobile view.
  double gridSpace() => mobileValue(base: 20, mobile: 16);

  /// Width of the each grid items.
  /// 12 grid columns for desktop and 4 grid columns for tablet/mobile view.
  double gridWidth() {
    final crossAxisCount = isDesktopView ? 12 : 4;
    return (availableWidth() - (gridSpace() * (crossAxisCount - 1))) /
        crossAxisCount;
  }
}

extension NumScreenUtilExtension<T extends num> on T {
  /// Required percentage of height with limitation
  double heightPart({double? min, double? max}) =>
      ScreenUtil.I.heightPart(toDouble(), min: min, max: max);

  /// Required percentage of width with limitation
  double widthPart({double? min, double? max}) =>
      ScreenUtil.I.widthPart(toDouble(), min: min, max: max);
}
