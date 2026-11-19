import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/app_pages.dart';
import 'utils/app_colors.dart';

/// Agar RefreshIndicator bisa ditarik dengan mouse di Flutter Web.
class _DragDenganMouse extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {...super.dragDevices, PointerDeviceKind.mouse};
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Game News',
      debugShowCheckedModeBanner: false,
      scrollBehavior: _DragDenganMouse(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.accent,
          onSecondaryContainer: AppColors.primary,
          surface: AppColors.background,
          onSurface: AppColors.primary,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.secondary,
            side: const BorderSide(color: AppColors.secondary),
          ),
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: AppColors.secondary),
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
