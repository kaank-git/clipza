import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/routing/app_router.dart';

void main() {
  // Tüm uygulamayı ProviderScope ile sarıyoruz
  runApp(const ProviderScope(child: ClipzaApp()));
}

class ClipzaApp extends StatelessWidget {
  const ClipzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router kullanarak GoRouter'ı devreye sokuyoruz
    return MaterialApp.router(
      title: 'Clipza',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.cardColor,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textWhite),
          titleTextStyle: TextStyle(
            color: AppColors.textWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}