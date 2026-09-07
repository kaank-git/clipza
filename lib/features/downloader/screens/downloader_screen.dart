import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../link_provider.dart';
import '../providers/download_provider.dart';
import '../../gallery/providers/gallery_provider.dart';

class DownloaderScreen extends ConsumerStatefulWidget {
  const DownloaderScreen({super.key});

  @override
  ConsumerState<DownloaderScreen> createState() => _DownloaderScreenState();
}

class _DownloaderScreenState extends ConsumerState<DownloaderScreen> {
  final TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Arka planda yakalanan linki girdi alanına otomatik aktarır
    ref.listen<String?>(linkProvider, (previous, next) {
      if (next != null && next != _linkController.text) {
        _linkController.text = next;
      }
    });

    final currentLink = ref.watch(linkProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Clipza', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Video İndir',
                style: TextStyle(color: AppColors.textWhite, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Instagram veya Twitter linkini buraya yapıştır',
                style: TextStyle(color: AppColors.textGrey, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Premium Link Girdi Alanı
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: TextField(
                  controller: _linkController,
                  style: const TextStyle(color: AppColors.textWhite),
                  onChanged: (value) => ref.read(linkProvider.notifier).setLink(value),
                  decoration: InputDecoration(
                    hintText: 'https://...',
                    hintStyle: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.5)),
                    prefixIcon: const Icon(Icons.link_rounded, color: AppColors.primary),
                    suffixIcon: currentLink != null && currentLink.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppColors.textGrey),
                      onPressed: () {
                        _linkController.clear();
                        ref.read(linkProvider.notifier).setLink('');
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Link varsa gösterilecek Önizleme Alanı
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: (currentLink != null && currentLink.isNotEmpty)
                    ? _buildPreviewCard()
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Önizleme Kartı ve İndirme Butonu
  Widget _buildPreviewCard() {
    final isLoading = ref.watch(downloadStateProvider);
    final progress = ref.watch(downloadProgressProvider); // Yüzdeyi dinle

    return Container(
      key: const ValueKey('preview'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_library_rounded, color: AppColors.textGrey, size: 48),
                SizedBox(height: 12),
                Text('Video Hazır', style: TextStyle(color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Yükleniyorsa İlerleme Çubuğu, Değilse Buton Göster
          isLoading
              ? Column(
            children: [
              LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                backgroundColor: AppColors.background,
                color: AppColors.primary,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 12),
              Text(
                '%${(progress * 100).toInt()} Tamamlandı',
                style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
              ),
            ],
          )
              : SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                final currentLink = ref.read(linkProvider);
                if (currentLink == null || currentLink.isEmpty) return;

                ref.read(downloadStateProvider.notifier).setLoading(true);
                ref.read(downloadProgressProvider.notifier).setProgress(0.0);

                // Test linkini kaldırdık, kullanıcının yapıştırdığı gerçek linki kendi API'mize yolluyoruz
                final success = await ref.read(downloadServiceProvider).downloadAndSaveVideo(
                  currentLink, // Burada artık currentLink kullanılıyor
                      (received, total) {
                    if (total != -1) {
                      ref.read(downloadProgressProvider.notifier).setProgress(received / total);
                    }
                  },
                );

                ref.read(downloadStateProvider.notifier).setLoading(false);
                ref.read(downloadProgressProvider.notifier).setProgress(0.0);

                if (success) {
                  ref.read(galleryProvider.notifier).fetchVideos();
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Video Galeriye Kaydedildi!' : 'İndirme Başarısız veya Dosya Bozuk!'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Şimdi İndir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}