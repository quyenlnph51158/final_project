import 'package:final_project/features/policy/presentation/controller/policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:final_project/features/policy/data/models/policy_infomation.dart';
import 'package:final_project/features/policy/data/service/policy_service.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:provider/provider.dart';
import 'package:final_project/app/l10n/app_localizations.dart';

import '../../../../shared/widgets/app_drawer.dart';
import '../state/policy_state.dart';

// Giả định kHeaderTextColor là một màu cụ thể đã được định nghĩa
class PolicyScreen extends StatefulWidget {
  final int postId;

  // Giữ lại tham số bắt buộc và mặc định
  const PolicyScreen({
    super.key,
    this.postId = 0,
  });

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      context.read<PolicyController>().initData(l10n, widget.postId);
    });
  }


  // Hàm Helper để render nội dung HTML (Đã giữ nguyên)
  Widget _buildHtmlContent(String htmlContent) {
    final cleanedContent = htmlContent.replaceAll('\r\n', '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: HtmlWidget(
        cleanedContent,
        textStyle: const TextStyle(
          fontSize: 15.0,
          height: 1.6,
          color: Colors.black87,
        ),
        customStylesBuilder: (element) {
          if (element.localName == 'table') {
            return {'width': '100%', 'border-collapse': 'collapse'};
          }
          if (element.localName == 'a') {
            return {'color': 'blue'};
          }
          return null;
        },
        onTapUrl: (url) {
          debugPrint('Đã nhấn vào URL: $url');
          return true;
        },
        customWidgetBuilder: (element) {
          if (element.localName == 'table') {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HtmlWidget(
                element.outerHtml,
                textStyle: const TextStyle(fontSize: 13.0, color: Colors.black87),
                customStylesBuilder: (e) {
                  return {
                    'border': '1px solid #ddd',
                    'padding': '8px',
                    'text-align': 'left',
                  };
                },
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PolicyController>();
    final state = controller.state;

    return Scaffold(
      endDrawer: AppDrawer(
        onTabSelected: (_) {},
        onHomeSelected: () {},
        onTabFlightSelected: (_) {},
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                backgroundColor: kPrimaryColor,
                image: 'https://www.wonderingvietnam.com/assets/img/logo_wondering.svg',
              ),

              /// TITLE (nếu có data)
              if (state.policy != null && !state.isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text(
                    state.policy!.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

              /// CONTENT
              _buildContent(state),

              /// FOOTER
              const SizedBox(height: 40),
              const AppFooter(),
            ],
          ),
        ),
      ),
    );
  }



  // Hàm xây dựng nội dung Body dựa trên trạng thái (tải, lỗi, dữ liệu)
  Widget _buildContent(PolicyState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              '${l10n.policy_loadDataFailed}\n${state.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<PolicyController>()
                    .initData(l10n, widget.postId);
              },
              child: Text(l10n.error_retryButton),
            ),
          ],
        ),
      );
    }

    if (state.policy == null) {
      return Center(child: Text(l10n.error_noDataFound));
    }

    final policy = state.policy!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HTML CONTENT
        _buildHtmlContent(policy.content),
      ],
    );
  }

}