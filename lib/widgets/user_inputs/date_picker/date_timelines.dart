import 'package:material_ui/material_ui.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:ui_library/widgets/user_inputs/date_picker/date_timeline_button.dart';

class DateTimelines extends StatelessWidget {
  const DateTimelines({
    super.key,
    required this.timelinePresetNotifier,
    required this.dateRangePickerController,
  });

  final ValueNotifier<int> timelinePresetNotifier;
  final DateRangePickerController dateRangePickerController;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder(
        valueListenable: timelinePresetNotifier,
        builder: (context, lastDays, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              DateTimelineButton(
                label: 'Today',
                isSelected: lastDays == 0,
                onTap: () {
                  timelinePresetNotifier.value = 0;
                  dateRangePickerController.selectedRange = PickerDateRange(
                    DateTime.now(),
                    DateTime.now(),
                  );
                },
              ),
              DateTimelineButton(
                label: 'Last 7 days',
                isSelected: lastDays == 7,
                onTap: () {
                  timelinePresetNotifier.value = 7;
                  dateRangePickerController.selectedRange = PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 6)),
                    DateTime.now(),
                  );
                },
              ),
              DateTimelineButton(
                label: 'Last 30 days',
                isSelected: lastDays == 30,
                onTap: () {
                  timelinePresetNotifier.value = 30;
                  dateRangePickerController.selectedRange = PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 29)),
                    DateTime.now(),
                  );
                },
              ),
              DateTimelineButton(
                label: 'Last 6 months',
                isSelected: lastDays == 180,
                onTap: () {
                  timelinePresetNotifier.value = 180;
                  dateRangePickerController.selectedRange = PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 179)),
                    DateTime.now(),
                  );
                },
              ),
              DateTimelineButton(
                label: 'Last Year',
                isSelected: lastDays == 365,
                onTap: () {
                  timelinePresetNotifier.value = 365;
                  dateRangePickerController.selectedRange = PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 364)),
                    DateTime.now(),
                  );
                },
              ),
              DateTimelineButton(
                label: 'All time',
                isSelected: lastDays == -1,
                onTap: () {
                  timelinePresetNotifier.value = -1;
                  dateRangePickerController.selectedRange = null;
                },
              ),
              DateTimelineButton(label: 'Custom', isSelected: lastDays == -2),
            ],
          );
        },
      ),
    );
  }
}
