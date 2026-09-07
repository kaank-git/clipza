import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryNotifier extends Notifier<List<AssetEntity>> {
  @override
  List<AssetEntity> build() => [];

  Future<void> fetchVideos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth || ps.hasAccess) {
      // İşletim sisteminin dosyayı galeriye işlemesi için çok kısa bir süre tanıyoruz
      await Future.delayed(const Duration(milliseconds: 500));
      PhotoManager.clearFileCache();

      final paths = await PhotoManager.getAssetPathList(type: RequestType.video);

      if (paths.isNotEmpty) {
        // paths.first cihazdaki "Tüm Videolar" (Recent) havuzunu temsil eder
        final allVideos = await paths.first.getAssetListPaged(page: 0, size: 500);

        // Sadece indirdiğimiz (adı clipza_ ile başlayan) dosyaları filtrele
        final clipzaVideos = allVideos.where((asset) {
          final title = asset.title ?? '';
          return title.contains('clipza_');
        }).toList();

        state = clipzaVideos;
      } else {
        state = [];
      }
    } else {
      PhotoManager.openSetting();
    }
  }
}

final galleryProvider = NotifierProvider<GalleryNotifier, List<AssetEntity>>(GalleryNotifier.new);