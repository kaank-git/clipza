import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const ClipzaApp());
}

class ClipzaApp extends StatelessWidget {
  const ClipzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clipza',
      debugShowCheckedModeBanner: false, // Sağ üstteki debug yazısını kaldırır
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.cardColor,
        ),
        useMaterial3: true,
        // Proje genelindeki yazı tipleri ve appbar ayarları
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
      home: const DummyHomeScreen(),
    );
  }
}

// Tasarımın rengini test etmek için geçici bir ekran
class DummyHomeScreen extends StatelessWidget {
  const DummyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipza', style: TextStyle(letterSpacing: 1.2)),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Clipza Hazır!',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Premium UI altyapısı kuruldu.',
                style: TextStyle(color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {},
                child: const Text('Başlayalım', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}