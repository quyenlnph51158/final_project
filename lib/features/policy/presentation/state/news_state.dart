import '../../data/models/news_model.dart';

class NewsState {
  final bool isLoading;
  final String? errorMessage;
  final List<News> newsList;

  const NewsState({
    this.isLoading = false,
    this.errorMessage,
    this.newsList = const [],
  });

  NewsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<News>? newsList,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      newsList: newsList ?? this.newsList,
    );
  }
}
