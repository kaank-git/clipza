import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future<bool> downloadAndSaveVideo(String videoUrl, Function(int received, int total) onProgress) async {
    try {
      final hasAccess = await Gal.requestAccess();
      if (!hasAccess) return false;

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/clipza_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Dio ile indirirken onReceiveProgress üzerinden yüzdeyi UI'a aktarıyoruz
      await _dio.download(
        videoUrl,
        tempFilePath,
        onReceiveProgress: onProgress,
      );

      final file = File(tempFilePath);
      // Dosya gerçekten var mı ve içi dolu mu kontrolü (Sessiz hataları önler)
      if (await file.exists() && await file.length() > 1000) {
        await Gal.putVideo(tempFilePath);
        await file.delete();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("İndirme Hatası: $e");
      return false;
    }
  }
}