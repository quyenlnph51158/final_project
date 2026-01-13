class SchedulesTourDetail{
  final String name;
  final String description;
  const SchedulesTourDetail({
    required this.name,
    required this.description
  });
  factory SchedulesTourDetail.fromJson(Map<String,dynamic> json){
    return SchedulesTourDetail(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? ''
    );
  }
}