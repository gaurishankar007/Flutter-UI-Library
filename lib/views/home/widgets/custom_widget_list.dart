import 'package:flutter/material.dart';
import 'package:ui_library/widgets/user_inputs/drop_down/dropdown_bottom_sheet.dart'
    as db;
import 'package:ui_library/widgets/user_inputs/drop_down/dropdown_button.dart';
import 'package:ui_library/widgets/user_inputs/drop_down/dropdown_menu.dart';
import 'package:ui_library/widgets/user_inputs/drop_down/dropdown_text_field.dart'
    as dtf;
import 'package:ui_library/widgets/user_inputs/form/base_text_field.dart'
    as btf;
import 'package:ui_library/widgets/user_inputs/form/otp_field.dart';
import 'package:ui_library/widgets/user_inputs/overlays/overlay_menu.dart';
import 'package:ui_library/widgets/visual_layouts/base_shimmer.dart';
import 'package:ui_library/widgets/visual_layouts/dialog/generic_dialog.dart';
import 'package:ui_library/widgets/visual_layouts/draggable/draggable_content.dart';
import 'package:ui_library/widgets/visual_layouts/stopwatch_timer.dart';

import '../../../main.dart';
import '../../../utils/ui_helpers.dart';
import '../../../widgets/animations/explicit/gradient_loading.dart';
import '../../../widgets/animations/implicit/resend_otp_button.dart';
import '../../../widgets/clippers/curve_container.dart';
import '../../../widgets/painters/dotted_circle.dart';
import '../../../widgets/painters/dotted_container.dart';
import '../../../widgets/user_inputs/bottom_sheet/bottom_sheet_body.dart';
import '../../../widgets/user_inputs/bottom_sheet/bottom_sheet_title.dart';
import '../../../widgets/user_inputs/bottom_sheet/generic_bottom_sheet.dart';
import '../../../widgets/user_inputs/button/secondary_button.dart';
import '../../../widgets/user_inputs/overlays/text_field_with_overlay.dart';
import '../../../widgets/visual_layouts/base_text.dart';
import '../../widget_view.dart';

class CustomWidgetList extends StatelessWidget {
  const CustomWidgetList({super.key});

  @override
  Widget build(BuildContext context) {
    final widgets = [
      _buildListTile(
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [GradientLoading(), GradientLoading.small()],
        ),
        title: "Gradient Loading",
      ),
      _buildListTile(
        widget: ResendOTPButton(
          onOTPSend: () async {
            await Future.delayed(Duration(seconds: 1));
          },
        ),
        title: "Resend OTP",
      ),

      _buildListTile(
        widget: CurveContainer(
          height: 200,
          width: 200,
          curveSide: CurveSide.top,
          curvePercentage: 30,
        ),
        title: "Curve Container",
      ),
      _buildListTile(
        widget: DottedContainer(
          borderRadius: BorderRadius.circular(12),
          strokeColor: Colors.blue,
          child: const SizedBox(
            height: 100,
            width: 200,
            child: Center(child: Text("Dotted Container")),
          ),
        ),
        title: "Dotted Container",
      ),
      _buildListTile(
        widget: const DottedCircle(
          radius: 100,
          color: Colors.red,
          dotsNumber: 12,
        ),
        title: "Dotted Circle",
      ),
      _buildListTile(
        widget: SecondaryButton(
          label: "Show Generic Bottom Sheet",
          onTap: () => showGenericBottomSheet(
            navigatorKey.currentContext!,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomSheetTitle(title: "Generic Bottom Sheet"),
                BottomSheetBody(
                  children: [BaseText("This is a generic bottom sheet")],
                ),
              ],
            ),
          ),
        ),
        title: "Generic Bottom Sheet",
      ),
      _buildListTile(
        widget: SecondaryButton(
          label: "Show Generic Dialog",
          onTap: () => showGenericDialog(
            navigatorKey.currentContext!,
            title: "Generic Dialog",
            children: [
              const BaseText("This is the content of the generic dialog."),
            ],
          ),
        ),
        title: "Generic Dialog",
      ),
      _buildListTile(
        widget: BaseDropdownMenu<String>(
          label: "Dropdown Menu",
          hintText: "Select an option",
          onSelected: (value) {},
          entries: const [
            DropdownMenuEntry(value: "1", label: "Option 1"),
            DropdownMenuEntry(value: "2", label: "Option 2"),
          ],
        ),
        title: "Dropdown Menu",
      ),
      _buildListTile(
        widget: DropDownButton<String>(
          selectedValue: 'Option 1',
          items: const [
            DropdownItem(value: 'Option 1', label: 'Option 1'),
            DropdownItem(value: 'Option 2', label: 'Option 2'),
            DropdownItem(value: 'Option 3', label: 'Option 3'),
          ],
          onChanged: (value) {},
        ),
        title: "Dropdown Button",
      ),
      _buildListTile(
        widget: db.DropdownBottomSheet<String>(
          title: "Select an option",
          items: const [
            db.DropdownItem(value: "1", label: "Option 1"),
            db.DropdownItem(value: "2", label: "Option 2"),
          ],
          onChanged: (value) {},
        ),
        title: "Dropdown Bottom Sheet",
      ),
      _buildListTile(
        widget: dtf.DropdownTextField<String>(
          hintText: "Choose an option",
          items: const [
            dtf.DropdownItem(value: "1", label: "Option 1"),
            dtf.DropdownItem(value: "2", label: "Option 2"),
          ],
          onChanged: (value) {},
        ),
        title: "Dropdown Text Field",
      ),
      _buildListTile(
        widget: TextFieldWithOverlay<String>(
          hintText: "Search something...",
          overlayItems: const ["Apple", "Banana", "Cherry"],
          overlayItemWidget: (item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BaseText(item),
            );
          },
        ),
        title: "Text Field with Overlay",
      ),
      _buildListTile(
        widget: btf.BaseTextField(hintText: 'Base Text Field', title: 'Label'),
        title: "Base Text Field (Form)",
      ),
      _buildListTile(
        widget: OTPField(
          controller: TextEditingController(),
          onChanged: (value) {},
          hasError: false,
        ),
        title: "OTP Field",
      ),
      _buildListTile(
        widget: OverlayMenu<String>(
          menuWidth: 230,
          targetWidget: BaseText.button("Open Overlay Menu"),
          menuItems: [
            OverlayMenuItem(value: "1", label: "Option A", onTap: (value) {}),
            OverlayMenuItem(value: "2", label: "Option B", onTap: (value) {}),
          ],
        ),
        title: "Overlay Menu",
      ),
      _buildListTile(
        widget: DraggableContent(
          alwaysVisibleChildren: [
            BaseText.heading5("Always Visible"),
            BaseText("This content is always visible."),
          ],
          expandedOnlyChildren: [
            BaseText.heading5("Expanded Only"),
            BaseText("This content appears when expanded."),
            SizedBox(height: 200),
            BaseText("More content..."),
          ],
        ),
        title: "Draggable Content",
      ),
      _buildListTile(
        widget: BaseShimmer(
          height: 100,
          width: 200,
          borderRadius: BorderRadius.circular(12),
        ),
        title: "Base Shimmer",
      ),
      _buildListTile(
        widget: StatefulBuilder(
          builder: (context, setState) {
            final stopwatch = Stopwatch()..start();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StopwatchTimer(stopwatch: stopwatch),
                UIHelpers.spaceV12,
                SecondaryButton(
                  label: "Restart",
                  onTap: () => setState(() => stopwatch.reset()),
                ),
              ],
            );
          },
        ),
        title: "Stopwatch Timer",
      ),
    ];

    return ListView.separated(
      itemCount: widgets.length,
      separatorBuilder: (_, _) => UIHelpers.spaceV12,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  ListTile _buildListTile({required String title, required Widget widget}) {
    return ListTile(
      onTap: () {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (builder) => WidgetView(title: title, widget: widget),
          ),
        );
      },
      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
