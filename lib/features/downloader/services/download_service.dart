import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class DownloadService {
  final Dio _dio = Dio();

  // Claude'un önerdiği Metadata Temizleyici Fonksiyon
  Future<String> _stripMetadata(String inputPath) async {
    final cleanPath = inputPath.replaceAll('.mp4', '_clean.mp4');
    final session = await FFmpegKit.execute(
      '-i "$inputPath" -c copy -map_metadata -1 -movflags +faststart "$cleanPath"',
    );
    final returnCode = await session.getReturnCode();
    if (returnCode == null || !returnCode.isValueSuccess()) {
      return inputPath; // Başarısız olursa orijinali döndür
    }
    return cleanPath;
  }

  Future<bool> downloadAndSaveVideo(String socialMediaUrl, Function(int received, int total) onProgress) async {
    try {
      final hasAccess = await Gal.requestAccess();
      if (!hasAccess) return false;

      // API IP adresini kendi adresinle eşleştiğinden emin ol
      const String apiUrl = "http://192.168.1.103:8000/api/extract";

      final response = await _dio.post(
        apiUrl,
        data: {"url": socialMediaUrl},
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );

      if (response.statusCode != 200 || response.data['success'] != true) {
        return false;
      }

      final String realVideoUrl = response.data['video_url'];
      final String platform = response.data['platform'] ?? 'Unknown';

      if (realVideoUrl.contains('.m3u8')) return false;

      final tempDir = await getTemporaryDirectory();
      final String fileName = 'clipza_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final tempFilePath = '${tempDir.path}/$fileName';

      // 1. ÇÖZÜM: Dio İndirme İsteğine Header Eklendi
      await _dio.download(
        realVideoUrl,
        tempFilePath,
        onReceiveProgress: onProgress,
        options: Options(
          headers: {
            'Referer': 'https://twitter.com/',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          },
        ),
      );

      final file = File(tempFilePath);
      if (await file.exists() && await file.length() > 1000) {

        // 2. ÇÖZÜM: Eğer video Twitter'dan geliyorsa metadata'sını temizle
        String finalPath = tempFilePath;
        if (platform == 'Twitter' || socialMediaUrl.contains('x.com') || socialMediaUrl.contains('twitter.com')) {
          finalPath = await _stripMetadata(tempFilePath);
        }

        final now = DateTime.now();
        await File(finalPath).setLastModified(now);
        await File(finalPath).setLastAccessed(now);

        await Gal.putVideo(finalPath);

        // İşlem bitince geçici dosyaları sil
        await File(finalPath).delete();
        if (finalPath != tempFilePath) await file.delete();

        return true;
      }

      return false;
    } catch (e) {
      debugPrint("İndirme Hatası: $e");
      return false;
    }
  }
}