import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/download_service.dart';

final downloadServiceProvider = Provider((ref) => DownloadService());

class DownloadStateNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setLoading(bool isLoading) => state = isLoading;
}

// İndirme yüzdesini (0.0 ile 1.0 arası) tutacak yeni yapı
class DownloadProgressNotifier extends Notifier<double> {
  @override
  double build() => 0.0;
  void setProgress(double progress) => state = progress;
}

final downloadStateProvider = NotifierProvider<DownloadStateNotifier, bool>(DownloadStateNotifier.new);
final downloadProgressProvider = NotifierProvider<DownloadProgressNotifier, double>(DownloadProgressNotifier.new);