# the_leaderboard

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# For IOS

```dart
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  # Add this line explicitly
  pod 'PhoneNumberKit', '~> 3.6'

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  target 'RunnerTests' do
    inherit! :search_paths
  end
end
```

```cmd
flutter clean
cd ios
rm -rf Podfile.lock Pods
pod install
cd ..
flutter pub get
```

# Publish app in google play console

## Add a launcher icon
<li> install `flutter_launcher_icons` package </li>
<li> run this command: </li>

```bash
dart run flutter_launcher_icons:generate
```

<li>Set necessary information in `flutter_launcher_icons.yaml` file</li>
<li> Run this command:</li>

```bash
dart run flutter_launcher_icons
```

## Change app package name

<li> install `change_app_package_name` package </li>

<li> Run this command </li>

```bash
dart run change_app_package_name:main com.new.package.name
```

## Sign the app

<li>Create an upload keystore </li>

```bash
keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
        -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
        -alias upload
        
```

<li> Store the generated `upload-keystore.jks` file in `android/app` folder </li>

<li> Create a file in android folder named `key.properties` and write this </li>

```properties
storePassword=srNXtfiJOu
keyPassword=srNXtfiJOu
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

<li> Now, write this code in `/android/app/build.gradle.kts` </li>

```kts
import java.util.Properties
import java.io.FileInputStream

plugins {
   ...
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
   ...

   signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now,
            // so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

```
<li> Now write this command </li>

```bash
flutter build appbundle
```

# I need to implement


1. Twitter and instagram auth 