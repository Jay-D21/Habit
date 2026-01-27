# Keep Google Credentials API classes for smart_auth plugin
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.api.** { *; }

# Keep Amplify classes
-keep class com.amplifyframework.** { *; }
-dontwarn com.amplifyframework.**

# Keep AWS SDK classes
-keep class com.amazonaws.** { *; }
-dontwarn com.amazonaws.**

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
