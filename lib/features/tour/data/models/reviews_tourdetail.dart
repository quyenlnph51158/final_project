
class Reviews{
  final int rating;
  final String name;
  final String comment;
  final String positive;
  final String negative;
  const Reviews({
    required this.rating,
    required this.name,
    required this.comment,
    required this.positive,
    required this.negative
  });
  factory Reviews.fromJson(Map<String,dynamic> json){
    return Reviews(
      rating: json['rating'] as int? ?? 0,
      name: json['name']?.toString() ??'',
      comment: json['comment']?.toString() ??'',
      positive: json['positive']?.toString() ??'',
      negative: json['negative']?.toString()??''
    );
  }
}