import 'package:flutter/services.dart';

class RemoveDiacriticsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Chuyển đổi text mới sang không dấu
    String text = removeDiacritics(newValue.text);
    // Chỉ cho phép chữ cái và khoảng trắng (A-Z, a-z, space)
    // Nếu bạn muốn cho phép cả số thì thêm 0-9 vào regex
    text = text.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');

    return newValue.copyWith(
      text: text.toUpperCase(), // Tự động viết hoa luôn nếu muốn
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String removeDiacritics(String str) {
    var withDiacritics = 'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđÀÁẢÃẠĂẰẮẲẴẶÂẦẤẨẪẬÈÉẺẼẸÊỀẾỂỄỆÌÍỈĨỊÒÓỎÕỌÔỒỐỔỖỘƠỜỚỞỠỢÙÚỦŨỤƯỪỨỬỮỰỲÝỶỸỴĐ';
    var withoutDiacritics = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }
}