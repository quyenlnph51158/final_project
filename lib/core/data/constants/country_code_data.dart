import '../model/country_code_model.dart';

class CountryCodeData {
  static const List<CountryCodeModel> countries = [
    CountryCodeModel(name: "Vietnam", code: "VN", dialCode: "+84", flag: "🇻🇳"),
    CountryCodeModel(
        name: "United States", code: "US", dialCode: "+1", flag: "🇺🇸"),
    CountryCodeModel(name: "Japan", code: "JP", dialCode: "+81", flag: "🇯🇵"),
    CountryCodeModel(
        name: "South Korea", code: "KR", dialCode: "+82", flag: "🇰🇷"),
    CountryCodeModel(
        name: "Singapore", code: "SG", dialCode: "+65", flag: "🇸🇬"),
    CountryCodeModel(name: "Thailand", code: "TH", dialCode: "+66", flag: "🇹🇭"),
    CountryCodeModel(name: "Laos", code: "LA", dialCode: "+856", flag: "🇱🇦"),
    CountryCodeModel(
        name: "Cambodia", code: "KH", dialCode: "+855", flag: "🇰🇭"),
    CountryCodeModel(name: "China", code: "CN", dialCode: "+86", flag: "🇨🇳"),
    CountryCodeModel(name: "France", code: "FR", dialCode: "+33", flag: "🇫🇷"),
    CountryCodeModel(name: "Germany", code: "DE", dialCode: "+49", flag: "🇩🇪"),
    // Thêm các quốc gia khác...
  ];
}