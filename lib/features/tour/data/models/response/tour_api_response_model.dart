class ApiResponse {
  final int status; // 1: Thành công, 0: Thất bại
  final String message;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? errors; // Chứa chi tiết lỗi xác thực

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors,
  });

  // Hàm tạo Model từ JSON nhận về
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Lấy giá trị cho data và errors
    final dynamic rawData = json['data'];
    final dynamic rawErrors = json['errors'];

    return ApiResponse(
      // 1. Sửa lỗi status: type 'Null' is not a subtype of type 'int' in type cast
      status: (json['status'] as int?) ?? 0,

      message: json['message'] as String,

      // 2. KHẮC PHỤC LỖI HIỆN TẠI (List<dynamic> vs Map)
      // data: Chỉ gán nếu nó là Map<String, dynamic>, nếu không thì gán null
      data: (rawData is Map<String, dynamic>)
          ? rawData
          : null,

      // errors: Chỉ gán nếu nó là Map<String, dynamic>, nếu không thì gán null
      // Thường xảy ra khi validation lỗi và server trả về List lỗi
      errors: (rawErrors is Map<String, dynamic>)
          ? rawErrors
          : null,
    );
  }
}