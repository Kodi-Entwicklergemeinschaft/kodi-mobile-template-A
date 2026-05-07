part of 'theme.dart';

ThemeData getTheme({
  required Brightness brightness,
  Color? primaryColor,
  Color? secondaryColor,
}) {
  primaryColor = primaryColor ?? AppColors.primary;
  secondaryColor = secondaryColor ?? AppColors.secondary;

  ColorScheme? colorScheme;
  if (brightness == Brightness.dark) {
    colorScheme = ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: AppColors.light,
      error: AppColors.errorDarkMode,
    );
  } else {
    colorScheme = ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: AppColors.dark,
      error: AppColors.errorDarkMode,
    );
  }
  final isDark = colorScheme.brightness == Brightness.dark;
  final indicatorColor = isDark ? colorScheme.onSurface : colorScheme.primary;

  /// SELECT TEXT COLOR BASED ON MODE
  final textColor = isDark ? AppColors.fontLight : AppColors.fontDark;

  final baseTheme = ThemeData(
    fontFamily: 'Raleway',
    extensions: [
      ///Special case: (wrapped in opposite-colored container)
      // Dark theme → Dark font
      // Light theme → Light font
      AppTextColors(
        normal: isDark ? AppColors.fontLight : AppColors.fontDark,
        inverse: isDark ? AppColors.fontDark : AppColors.fontLight,
      ),
      AppContainerColors(
        normal: isDark ? AppColors.light : AppColors.dark, // Light BG
        inverse: isDark ? AppColors.dark : AppColors.light, // Dark BG
      ),
      AppErrorColors(
        normal: isDark ? AppColors.errorDarkMode : AppColors.errorLightMode,
        // Light BG
        inverse: isDark
            ? AppColors.errorLightMode
            : AppColors.errorDarkMode, // Dark BG
      ),
    ],
    brightness: brightness,
    primaryColor: colorScheme.primary,

    /// APP BAR
    appBarTheme: AppBarTheme(
      backgroundColor: isDark
          ? AppColors.dark
          : AppColors.light, // 🔥 Surface changes based on brightness
      foregroundColor: isDark
          ? AppColors
                .fontLight // White text/icons in dark mode
          : AppColors.fontDark, // Black text/icons in light mode
      shadowColor: isDark
          ? null // No shadow in dark mode
          : colorScheme.onSurface.withAlpha((0.2 * 255).toInt()),
    ),

    /// ICON BUTTON
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey; // disabled icon
          }
          return isDark
              ? AppColors
                    .fontLight // white in dark mode
              : AppColors.fontDark; // black in light mode
        }),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return isDark
                ? Colors.white.withAlpha((0.1 * 255).toInt())
                : Colors.black.withAlpha((0.1 * 255).toInt());
          }
          return Colors.transparent;
        }),
      ),
    ),

    ///CHOICE CHIP
    chipTheme: ChipThemeData(
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      labelStyle: const TextStyle(),
      // overridden by child text widget
      side: const BorderSide(color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    /// OutlinedButtonTheme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(0, 48)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),

        // BORDER COLOR + WIDTH
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: Colors.grey.withAlpha((0.4 * 255).toInt()),
              width: 1.2,
            );
          }

          if (states.contains(WidgetState.pressed)) {
            return BorderSide(
              color: colorScheme!.primary.withAlpha((0.8 * 255).toInt()),
              width: 1.5,
            );
          }

          return BorderSide(
            color: colorScheme!.primary, // normal border color
            width: 1.2,
          );
        }),

        // TEXT STYLE
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.withAlpha((0.6 * 255).toInt());
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.white; // YOUR SELECTED TEXT COLOR
          }
          return colorScheme!.primary; // normal text color
        }),

        // BACKGROUND COLOR (OutlinedButton is normally transparent)
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return colorScheme!.primary.withAlpha((0.06 * 255).toInt());
          }
          return Colors.transparent;
        }),
      ),
    ),

    /// ElevatedButtonThemeData
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(0, 48)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),

        // BORDER RADIUS
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),

        // BACKGROUND COLOR
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.withAlpha((0.3 * 255).toInt());
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme!.primary.withAlpha((0.3 * 255).toInt());
          }
          return Colors.blue; // normal bg
        }),

        // TEXT COLOR
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.white.withAlpha((0.6 * 255).toInt());
          }
          return Colors.white;
        }),

        // ELEVATION
        elevation: WidgetStateProperty.resolveWith<double>((states) {
          if (states.contains(WidgetState.disabled)) return 0;
          if (states.contains(WidgetState.pressed)) return 2;
          return 1;
        }),
      ),
    ),

    canvasColor: colorScheme.surface,
    scaffoldBackgroundColor: isDark
        ? AppColors
              .dark // DARK MODE SCAFFOLD
        : AppColors.light,

    // LIGHT MODE SCAFFOLD    cardColor: colorScheme.surface,

    ///RADIO
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => colorScheme?.primary,
      ),
    ),
    dividerColor: colorScheme.onSurface.withAlpha((0.12 * 255).toInt()),
    applyElevationOverlayColor: isDark,

    datePickerTheme: DatePickerThemeData(
      backgroundColor: isDark?AppColors.dark:AppColors.light,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: isDark?AppColors.dark:AppColors.light,
      shape: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(thickness: 0.8),
    bottomAppBarTheme: const BottomAppBarThemeData(
      shape: CircularNotchedRectangle(),
    ),

    colorScheme: colorScheme.copyWith(
      surface: colorScheme.surface,
      error: colorScheme.error,
    ),

    /// --- CUSTOM SWITCH THEME ---
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white; // ON thumb color
        }
        return Colors.grey; // OFF thumb color
      }),

      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme?.primary; // ON track color
        }
        return Colors.grey.shade600; // OFF track
      }),
    ),

    /// --- CUSTOM TEXT THEME USING RALEWAY ---
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      headlineLarge: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      titleLarge: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
        color: textColor,
      ),

      labelLarge: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    ),

    tabBarTheme: TabBarThemeData(
      indicatorColor: indicatorColor,
      labelColor: textColor,
    ),
  );

  return baseTheme;
}
