part of '../common_components.dart';

/// A utility class to show standardized SnackBars across the application
class AppSnackBar {
  /// Shows a basic snackbar with the given message
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonText(titleText: message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an error snackbar with a red background
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        content: snackBarContent(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        showCloseIcon: true,
        closeIconColor: Colors.white,
      ),
    );
  }

  /// Shows a success snackbar with a green background
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 20),
        content: snackBarContent(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Shows a warning snackbar with an amber background
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: snackBarContent(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.amber,
      ),
    );
  }

  static Widget snackBarContent(String message) {
    return CommonText(
      titleText: message.replaceAll('Exception:', ''),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }
}
