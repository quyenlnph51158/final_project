
# android/app/proguard-rules.pro

# Giữ nguyên các class trong thư mục models để không bị lỗi parse JSON
-keep class com.example.final_project.features.**.models.** { *; }
-keep class com.example.final_project.core.data.model.** { *; }

# Giữ lại các phương thức chuyển đổi JSON
-keepclassmembers class * {
    *** fromJson(...);
    *** toJson(...);
}

# Giữ lại các class của Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
# Bỏ qua các cảnh báo thiếu class của Google Play Core
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Nếu bạn gặp lỗi liên quan đến các lớp nội bộ của Flutter
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Giữ lại các class quan trọng để không bị xóa nhầm
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }