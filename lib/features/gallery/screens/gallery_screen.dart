import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/gallery_provider.dart';
import 'package:go_router/go_router.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran açıldığında videoları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(galleryProvider.notifier).fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(galleryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Galerim', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
      ),
      body: videos.isEmpty
          ? const Center(
        child: Text('Henüz video bulunmuyor.', style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 9 / 16,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final asset = videos[index];
          return GestureDetector(
            onTap: () async {
              // Asset'i gerçek bir dosya nesnesine çevir
              final file = await asset.file;
              if (file != null && context.mounted) {
                context.push('/video_player', extra: file);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Video kapak fotoğrafını (thumbnail) asenkron olarak yükle
                  FutureBuilder<Uint8List?>(
                    future: asset.thumbnailDataWithSize(const ThumbnailSize(250, 250)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      }
                      return Container(color: AppColors.cardColor);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 32),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Text(
                      _formatDuration(asset.duration),
                      style: const TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}