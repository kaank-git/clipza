import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryNotifier extends Notifier<List<AssetEntity>> {
  @override
  List<AssetEntity> build() => [];

  Future<void> fetchVideos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth || ps.hasAccess) {
      final paths = await PhotoManager.getAssetPathList(type: RequestType.video);
      if (paths.isNotEmpty) {
        // Cihazdaki en son videoları geniş bir havuzda çek
        final allVideos = await paths.first.getAssetListPaged(page: 0, size: 500);

        // Sadece indirme servisimizin adlandırdığı (clipza_) dosyaları filtrele
        final clipzaVideos = allVideos.where((asset) {
          return asset.title != null && asset.title!.startsWith('clipza_');
        }).toList();

        state = clipzaVideos;
      }
    } else {
      PhotoManager.openSetting();
    }
  }
}

final galleryProvider = NotifierProvider<GalleryNotifier, List<AssetEntity>>(GalleryNotifier.new);