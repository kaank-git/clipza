import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinkNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null; // Başlangıç değeri boş
  }

  // Dışarıdan yeni link geldiğinde tetiklenecek fonksiyon
  void setLink(String newLink) {
    state = newLink;
  }
}

final linkProvider = NotifierProvider<LinkNotifier, String?>(LinkNotifier.new);