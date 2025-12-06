# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# WorkManager
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**