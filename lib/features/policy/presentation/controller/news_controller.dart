import 'package:flutter/cupertino.dart';

import '../../data/models/news_model.dart';
import '../../data/service/news_service.dart';
import '../state/news_state.dart';

class NewsController extends ChangeNotifier {
  final NewsService _service = NewsService();
  final ScrollController scrollController = ScrollController();
  NewsState _state = const NewsState();
  NewsState get state => _state;

  Future<void> fetchNews() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final rawList = await _service.fetchNewsRaw();
      final news = rawList.map((e) => News.fromJson(e)).toList();

      _state = _state.copyWith(
        isLoading: false,
        newsList: news,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }

    notifyListeners();
  }
}
