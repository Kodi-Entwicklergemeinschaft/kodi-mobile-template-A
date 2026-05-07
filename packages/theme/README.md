# 🎨 Theme (`theme`)

A custom, highly flexible design system package for Flutter applications. This package centralizes all branding, colors, typography, and theme definitions, ensuring consistency and making light/dark mode implementation effortless.

## ✨ Features

* **Centralized Theming:** Define all `ThemeData` (Light & Dark) in a single package.
* **Custom Properties:** Extends the standard Flutter `ThemeData` using `ThemeExtension` to add custom brand properties (e.g., success colors, custom spacing).
* **Easy Switching:** Provides a `ThemeService` using `ChangeNotifier` to enable seamless Light/Dark mode switching via `Provider`.
* **Reusability:** Easily import and use your entire design system in multiple projects.

## 📦 Installation

Since this is a local package, you need to reference it using a `path` dependency in your main application's (`lend_mate`) `pubspec.yaml` file.

1.  **Add to `pubspec.yaml`:**
    In your main project's (`lend_mate`) `pubspec.yaml`:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      provider: ^6.0.0 # Required for the ThemeService
      
      # Reference your local theme package
      my_theme_package:
        path: ../my_theme_package 
        # NOTE: Adjust the path if your directory structure is different
    ```

2.  **Run `flutter pub get`:**
    ```bash
    flutter pub get
    ```

## 🚀 Quick Start

### 1. Define the Themes (In `my_theme_package`)

Ensure your theme package defines the themes and the custom extension.

**File: `my_theme_package/lib/app_theme_extension.dart`** (Your custom properties)

```dart
// Example of AppThemeExtension (Must be defined in your package)
import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // ... (copyWith and lerp methods here)
  final Color? successColor;
  final double extraSpacing;

  const AppThemeExtension({required this.successColor, required this.extraSpacing});

  // Recommended static method for easy access
  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }
  
  // ... copyWith and lerp implementations
}