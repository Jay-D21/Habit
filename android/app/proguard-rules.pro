# ====== smart_auth plugin — deprecated Credentials API (classes not in dependencies) ======
-dontwarn com.google.android.gms.auth.api.credentials.Credential$Builder
-dontwarn com.google.android.gms.auth.api.credentials.Credential
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialPickerConfig
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequest
-dontwarn com.google.android.gms.auth.api.credentials.CredentialRequestResponse
-dontwarn com.google.android.gms.auth.api.credentials.Credentials
-dontwarn com.google.android.gms.auth.api.credentials.CredentialsClient
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest$Builder
-dontwarn com.google.android.gms.auth.api.credentials.HintRequest

# ====== Google Identity / Credentials ======
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.libraries.identity.** { *; }
-keep class androidx.credentials.** { *; }
-dontwarn com.google.android.libraries.identity.**

# ====== Amplify ======
-keep class com.amplifyframework.** { *; }
-dontwarn com.amplifyframework.**

# ====== AWS SDK ======
-keep class com.amazonaws.** { *; }
-dontwarn com.amazonaws.**

# ====== Flutter ======
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# ====== Google Mobile Ads ======
-keep class com.google.android.gms.ads.** { *; }

# ====== Firebase ======
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# ====== Drift / SQLite ======
-keep class * extends com.google.common.util.concurrent.AbstractFuture { *; }
-keepclassmembers class * extends drift.** { *; }

# ====== Riverpod ======
-keep class * extends riverpod.** { *; }
-keepclassmembers class * {
    @riverpod.annotation.* <methods>;
}

# ====== JSON / Gson ======
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ====== General suppressions ======
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
