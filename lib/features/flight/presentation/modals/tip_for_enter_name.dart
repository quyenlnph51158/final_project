import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/design/flight/flight_layout_spacing.dart';
import '../../../../../core/design/flight/flight_shape.dart';
import '../../../../../core/design/flight/flight_size.dart';
import '../../../../../core/design/flight/flight_style.dart';
import '../../../../../core/utils/responsive_layout.dart';
import '../../../../app/l10n/app_localizations.dart';
import '../../data/models/name_tip_model.dart';

/// Hàm gọi hiển thị Bottom Sheet
void showInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (context) => const TipForEnterName(),
  );
}

class TipForEnterName extends StatelessWidget {
  const TipForEnterName({super.key});

  // Hàm trả về danh sách dữ liệu từ l10n
  List<NameTipModel> _getNameTips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      NameTipModel(
        title: l10n.tip1Title,
        description: l10n.tip1Desc,
        example: l10n.tip1Ex,
        firstName: 'DD',
        lastName: 'Jonson',
      ),
      NameTipModel(
        title: l10n.tip2Title,
        description: l10n.tip2Desc,
        example: l10n.tip2Ex,
        firstName: 'JohnAdam',
        lastName: 'Smith',
      ),
      NameTipModel(
        title: l10n.tip3Title,
        description: l10n.tip3Desc,
        example: l10n.tip3Ex,
        firstName: '',
        lastName: 'Thomas',
      ),
      NameTipModel(
        title: l10n.tip4Title,
        description: l10n.tip4Desc,
        example: l10n.tip4Ex,
        firstName: 'William Jr',
        lastName: 'Smith',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tips = _getNameTips(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: FlightShape.borderRadiusBottomSheet,
      ),
      height: FlightSize.bottomSheetHeight(context),
      child: Column(
        children: [
          _buildDragHandle(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: FlightLayoutSpacing.bottomSheetPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, l10n),
                  const SizedBox(height: 20),

                  // Dùng ListView.separated hoặc Column với map
                  ...tips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _InfoCard(data: tip),
                  )).toList(),

                  _buildWarningCard(
                    context,
                    title: l10n.checkInfoTitle,
                    desc: l10n.checkInfoDesc,
                  ),
                  const SizedBox(height: 16),
                  _buildWarningCard(
                    context,
                    title: l10n.wrongNameTitle,
                    desc: l10n.wrongNameDesc,
                  ),
                  const SizedBox(height: 24),
                  _buildUnderstandButton(context, l10n.understand),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDragHandle(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (_) => Navigator.pop(context),
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 20),
          height: FlightSize.dragHandleHeight,
          width: FlightSize.dragHandleWidth,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
  Widget _buildWarningCard(BuildContext context, {required String title, required String desc}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: FlightShape.borderRadiusLarge(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FlightStyle.sectionTitleBold(context).copyWith(fontSize: context.sp(18))),
          const SizedBox(height: 16),
          Text(desc, style: FlightStyle.labelGrey(context).copyWith(height: 1.5, color: const Color(0xFF555555))),
        ],
      ),
    );
  }
  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tipEnterNameTitle,
          style: FlightStyle.sectionTitleBold(context).copyWith(fontSize: context.sp(20)),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.tipEnterNameDesc,
          style: FlightStyle.labelGrey(context).copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  // Cập nhật các hàm build khác để nhận text từ tham số...
  Widget _buildUnderstandButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      height: FlightSize.btnUnderstandHeight,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: FlightShape.borderRadiusSmall(context)),
        ),
        child: Text(text, style: FlightStyle.buttonLarge(context).copyWith(fontSize: context.sp(16))),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final NameTipModel data;
  const _InfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(FlightLayoutSpacing.cardPaddingInner),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: FlightShape.borderRadiusLarge(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.title, style: FlightStyle.sectionTitleBold(context).copyWith(fontSize: context.sp(15))),
          const SizedBox(height: 8),
          Text(data.description, style: FlightStyle.labelGrey(context).copyWith(color: Colors.black87)),
          const SizedBox(height: 8),
          Text(data.example, style: FlightStyle.sectionTitleBold(context).copyWith(fontSize: context.sp(13))),
          const SizedBox(height: 16),
          _RowInputExample(firstName: data.firstName, lastName: data.lastName),
        ],
      ),
    );
  }

}

class _RowInputExample extends StatelessWidget {
  final String firstName, lastName;
  const _RowInputExample({required this.firstName, required this.lastName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        _FakeInput(label: l10n.titleSalutation, value: l10n.salutationMr, isDropdown: true),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _FakeInput(label: l10n.titleFirstName, value: firstName)),
            const SizedBox(width: 12),
            Expanded(child: _FakeInput(label: l10n.titleLastName, value: lastName)),
          ],
        ),
      ],
    );
  }
}


class _FakeInput extends StatelessWidget {
  final String label, value;
  final bool isDropdown;

  const _FakeInput({required this.label, required this.value, this.isDropdown = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: context.sp(11), color: Colors.black54)),
        const SizedBox(height: 4),
        Container(
          height: FlightSize.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: FlightShape.borderRadiusSmall(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: context.sp(14), color: Colors.black)),
              if (isDropdown) const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}