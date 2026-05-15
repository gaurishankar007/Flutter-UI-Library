import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ui_library/core/constants/app_colors.dart';
import 'package:ui_library/utils/extensions/datetime_extension.dart';
import 'package:ui_library/utils/screen_util/screen_util.dart';
import 'package:ui_library/utils/ui_helpers.dart';
import 'package:ui_library/widgets/user_inputs/button/primary_button.dart';
import 'package:ui_library/widgets/user_inputs/button/secondary_button.dart';
import 'package:ui_library/widgets/user_inputs/date_picker/date_timelines.dart';

class DateRangePicker extends HookWidget {
  const DateRangePicker({
    super.key,
    this.dateRange,
    this.minDate,
    this.maxDate,
    this.onApplied,
  });

  final PickerDateRange? dateRange;
  final DateTime? minDate;
  final DateTime? maxDate;
  final void Function(PickerDateRange? dateRange)? onApplied;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(DateRangePickerController.new);
    final timelinePresetNotifier = useValueNotifier(-1);

    /// Calculates which timeline preset matches the selected date range.
    /// Identifies preset types: Today (0), Last 7/30/180/365 days, or Custom (-2).
    final void Function(DateTime?, DateTime?) updateTimelinePreset =
        useCallback((startDate, endDate) {
          if (startDate != null) {
            final isStartDateToday = startDate.isSameDay(DateTime.now());
            if (endDate != null) {
              final differenceInDays = endDate.difference(startDate).inDays;
              timelinePresetNotifier.value = switch (differenceInDays) {
                0 when isStartDateToday => 0,
                6 => 7,
                29 => 30,
                179 => 180,
                364 => 365,
                _ => -2,
              };
            } else if (isStartDateToday) {
              timelinePresetNotifier.value = 0;
            } else {
              timelinePresetNotifier.value = -2;
            }
          } else {
            timelinePresetNotifier.value = -1;
          }
        }, [timelinePresetNotifier]);

    /// Applies the selected date range by invoking the callback and closing dialog.
    /// Ensures single-day selections have matching end date.
    final onApply = useCallback(() {
      final range = controller.selectedRange;
      if (range case PickerDateRange newRange) {
        if (newRange.endDate == null) {
          newRange = PickerDateRange(newRange.startDate, newRange.startDate);
        }
        onApplied?.call(newRange);
      } else {
        onApplied?.call(null);
      }
      Navigator.pop(context);
    });

    useEffect(() {
      if (dateRange != null) {
        controller.selectedRange = dateRange;
        updateTimelinePreset(dateRange?.startDate, dateRange?.endDate);
      }
      return null;
    }, [dateRange]);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: UIHelpers.radiusC8,
        border: Border.all(width: 1.5, color: AppColors.gray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ScreenUtil.I.isWithinPhoneView
                ? UIHelpers.paddingA8
                : UIHelpers.paddingA12,
            child: DateTimelines(
              timelinePresetNotifier: timelinePresetNotifier,
              dateRangePickerController: controller,
            ),
          ),
          Flexible(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5, color: AppColors.gray),
                ),
              ),
              child: Row(
                children: [
                  if (ScreenUtil.I.isWithinPhoneView)
                    UIHelpers.spaceH16
                  else
                    UIHelpers.spaceH32,
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        UIHelpers.spaceV2,
                        SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          headerHeight: 32,
                          backgroundColor: AppColors.white,
                          initialSelectedRange: dateRange,
                          controller: controller,
                          onSelectionChanged: (args) {
                            if (args.value
                                case final PickerDateRange pickerDateRange) {
                              updateTimelinePreset(
                                pickerDateRange.startDate,
                                pickerDateRange.endDate,
                              );
                            }
                          },
                          headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: AppColors.white,
                            textStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          minDate: minDate ?? DateTime(2020),
                          maxDate: maxDate ?? DateTime(2100),
                        ),
                        UIHelpers.spaceV12,
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SecondaryButton(
                              label: 'Cancel',
                              onTap: () => Navigator.pop(context),
                            ),
                            PrimaryButton(label: 'Apply', onTap: onApply),
                          ],
                        ),
                        UIHelpers.spaceV20,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (ScreenUtil.I.isWithinPhoneView)
            UIHelpers.spaceH12
          else
            UIHelpers.spaceH20,
        ],
      ),
    );
  }
}
