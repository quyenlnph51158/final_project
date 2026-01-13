import 'package:flutter/material.dart';
import 'package:final_project/core/constants/colors.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:final_project/features/policy/data/models/policy_infomation.dart';
import 'package:final_project/features/policy/data/service/policy_service.dart';
import 'package:final_project/shared/widgets/custom_app_bar.dart';
import 'package:final_project/shared/widgets/app_footer.dart';
import 'package:final_project/shared/widgets/app_drawer.dart';
import 'package:final_project/app/l10n/app_localizations.dart';
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
  String? _errorMessage;
  final PolicyService _policyService = PolicyService();
  Policy? _policy;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController(); // Giữ lại nếu cần cho màn hình lớn hơn
  TravelTab _selectedTab = TravelTab.tour;
  FlightTab _selectedFlightTab = FlightTab.flight;
  void _scrollToForm() {
    final double headerHeight = MediaQuery
        .of(context)
        .size
        .height * 0.35;
    final double targetScrollPosition = headerHeight - 10;

    _scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  void _handleFlightTabSelected(FlightTab tab) {
    setState(() => _selectedFlightTab = tab);
    _scrollToForm();
  }

  void _handleDrawerTabSelected(TravelTab tab) {
    setState(() => _selectedTab = tab);
    _scrollToForm();
  }

  void _handleDrawerHomeSelected() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
  @override
  void initState() {
    super.initState();
    // 1. GỌI HÀM TẢI DỮ LIỆU TẠI ĐÂY
    _fetchPolicyInfo();
  }

  Future<void> _fetchPolicyInfo() async {
    final l10n = AppLocalizations.of(context)!;
    // Sử dụng widget.postId
    final int postId = widget.postId;

    // Kiểm tra postId hợp lệ trước khi gọi API
    if (postId == 0) {
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.policy_searchCodeArticleCode(postId);
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Xóa lỗi cũ
    });

    try {
      // Gọi service với tham số từ Widget
      final Policy policyData = await _policyService.fetchPolicy(postId: postId);

      setState(() {
        _policy = policyData;
        _isLoading = false;
        _errorMessage = null;
      });

      if (_policy != null) {
        print('Dữ liệu chính sách đã được tải: ${_policy!.title}');
      } else {
        print('Dữ liệu trống sau khi tải.');
        setState(() {
          _errorMessage = l10n.policy_loadDataPolicyFailed;
        });
      }
    } catch (e) {
      print('LỖI KHI TẢI CHÍNH SÁCH: $e');
      setState(() {
        _errorMessage = '${l10n.policy_loadDetailPolicyFailed} ${e.toString()}';
        _isLoading = false;
      });
    }
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
    final l10n = AppLocalizations.of(context)!;
    String appBarTitle = l10n.policy_detail;
    if (_policy != null) {
      appBarTitle = _policy!.title; // Cập nhật tiêu đề nếu có dữ liệu
    }

    return Scaffold(
      endDrawer: AppDrawer(
        onTabSelected: _handleDrawerTabSelected,
        onHomeSelected: _handleDrawerHomeSelected,
        onTabFlightSelected: _handleFlightTabSelected,
      ),
      body: _buildBody(),
    );
  }

  // Hàm xây dựng nội dung Body dựa trên trạng thái (tải, lỗi, dữ liệu)
  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      // TRẠNG THÁI 1: ĐANG TẢI
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      // TRẠNG THÁI 2: LỖI
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.policy_loadDataFailed} \n$_errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchPolicyInfo, // Nút thử lại
                child: Text(l10n.error_retryButton),
              ),
            ],
          ),
        ),
      );
    }

    if (_policy != null) {
      final policy = _policy!;
      return SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(backgroundColor: kPrimaryColor,), // AppBar/Header của bạn
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      policy.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            _buildHtmlContent(policy.content),
            const SizedBox(height: 40),
            AppFooter(),
          ],
        ),
      );
    }
    return Center(child: Text(l10n.error_noDataFound));
  }
}