import 'package:final_project/features/account/data/service/token_service.dart';
import 'package:flutter/material.dart'; // Chuyển từ cupertino sang material để dùng đầy đủ hơn

import '../../data/models/news_model.dart';
import '../../data/service/news_service.dart';
import '../state/news_state.dart';

class NewsController extends ChangeNotifier {
  final NewsService _service = NewsService();
  final ScrollController scrollController = ScrollController();

  NewsState _state = const NewsState();
  NewsState get state => _state;

  // Biến khóa để tránh gọi API trùng lặp khi đang tải
  bool _isFetching = false;

  /// Hàm nội bộ để cập nhật state và thông báo cho UI
  void _updateState(NewsState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> fetchNews({bool isRefresh = false}) async {
    // Nếu đang tải thì không cho gọi thêm (tránh spam API)
    if (_isFetching) return;

    // Nếu đã có dữ liệu và không phải là làm mới (Refresh) thì không tải lại
    if (_state.newsList.isNotEmpty && !isRefresh) return;

    _isFetching = true;
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final token = await TokenService.getToken();

      // Kiểm tra Token an toàn thay vì dùng token! (tránh Null Check Error)
      if (token == null) {
        throw Exception("Vui lòng đăng nhập để xem tin tức");
      }

      final rawList = await _service.fetchNewsRaw(token);
      final news = rawList.map((e) => News.fromJson(e)).toList();

      _updateState(_state.copyWith(
        isLoading: false,
        newsList: news,
      ));
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    } finally {
      _isFetching = false;
    }
  }

  /// Hàm cuộn lên đầu trang
  void scrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    // BẮT BUỘC: Giải phóng ScrollController để tránh leak bộ nhớ
    scrollController.dispose();
    super.dispose();
  }
}