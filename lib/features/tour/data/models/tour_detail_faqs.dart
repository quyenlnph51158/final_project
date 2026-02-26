class TourDetailFaqs {
  final int id;
  final String? question;
  final String? answer;

  const TourDetailFaqs({
    required this.id,
    this.question,
    this.answer,
  });

  factory TourDetailFaqs.fromJson(Map<String, dynamic> json) {
    return TourDetailFaqs(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
    );
  }
}