import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/datetime_extension.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/date_picker/date_range_picker.dart';
import 'package:ui_library/widgets/visual_layouts/base_text.dart';

class DateRangePickerButton extends HookWidget {
  const DateRangePickerButton({
    super.key,
    this.initialDateRange,
    this.onApplied,
  });

  final PickerDateRange? initialDateRange;
  final void Function(PickerDateRange? dateRange)? onApplied;

  @override
  Widget build(BuildContext context) {
    final timelinePresent = useState('All time');
    final dateRangePresent = useState('Select');
    final dateRangeNotifier = useValueNotifier<PickerDateRange?>(
      initialDateRange,
    );

    /// Updates button states with the selected date range and timeline preset.
    /// Formats dates for display and sets the appropriate timeline label.
    final void Function(PickerDateRange?) updateState = useCallback((range) {
      dateRangeNotifier.value = range;
      final startDate = range?.startDate;
      final endDate = range?.endDate;

      if (startDate != null && endDate != null) {
        dateRangePresent.value = startDate.formattedDate(
          excludeCurrentYear: true,
        );
        if (startDate.compareTo(endDate) != 0) {
          dateRangePresent.value +=
              '-${endDate.formattedDate(excludeCurrentYear: true)}';
        }

        final differenceInDays = endDate.difference(startDate).inDays;
        final isStartDateToday = startDate.isSameDay(DateTime.now());
        timelinePresent.value = switch (differenceInDays) {
          0 when isStartDateToday => 'Today',
          6 => 'Last 7 Days',
          29 => 'Last 30 Days',
          179 => 'Last 6 Months',
          364 => 'Last year',
          _ => 'Custom',
        };
      } else {
        timelinePresent.value = 'All time';
        dateRangePresent.value = 'Select';
      }
    });

    useEffect(() {
      updateState(initialDateRange);
      return null;
    });

    return InkWell(
      onTap: () => showDialog<void>(
        context: context,
        barrierColor: AppColors.black.withAlpha(204),
        builder: (_) => AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: ScreenUtil.I.responsiveValue(
              base: 45.widthPart(),
              screens: {
                {.compact, .phone}: 95.widthPart(),
                {.tablet}: 75.widthPart(),
                {.largeTablet}: 60.widthPart(),
              },
            ),
            child: DateRangePicker(
              onApplied: (dateRange) {
                updateState(dateRange);
                onApplied?.call(dateRange);
              },
              dateRange: dateRangeNotifier.value,
            ),
          ),
        ),
      ),
      borderRadius: UIHelpers.radiusC8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: UIHelpers.radiusC8,
          border: Border.all(width: 1.5, color: AppColors.gray),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: UIHelpers.paddingH16V8,
              child: BaseText.body(timelinePresent.value),
            ),
            Flexible(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.5, color: AppColors.gray),
                  ),
                ),
                child: Padding(
                  padding: UIHelpers.paddingV8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UIHelpers.spaceH16,
                      Flexible(
                        child: BaseText.body(
                          dateRangePresent.value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      UIHelpers.spaceH8,
                      const Icon(Icons.calendar_today_outlined),
                      UIHelpers.spaceH12,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
