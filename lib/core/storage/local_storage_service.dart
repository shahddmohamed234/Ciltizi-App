import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// [LocalStorageService] sınıfı, uygulamanın çevrimdışı (offline-first)
/// çalışabilmesi için yerel dosya tabanlı güvenilir JSON depolama hizmeti sunar.
class LocalStorageService {
  // Tekil örnek (Singleton) deseni
  static final LocalStorageService instance = LocalStorageService._internal();
  LocalStorageService._internal();

  /// Bellek içi önbellek (Memory Cache) - Web veya hızlı erişim için
  final Map<String, String> _memoryStore = {};

  /// Belirtilen dosya anahtarına ait yerel File nesnesini üretir
  Future<File?> _getFile(String boxName) async {
    if (kIsWeb) return null;
    try {
      Directory? baseDir;
      // Android ortamında uygulamanın dahili veri klasörünü kullan
      if (Platform.isAndroid) {
        final androidUserDir = Directory('/data/user/0/com.ciltizi.ciltizi/files');
        if (await androidUserDir.exists()) {
          baseDir = androidUserDir;
        } else {
          final androidDataDir = Directory('/data/data/com.ciltizi.ciltizi/files');
          if (await androidDataDir.exists()) {
            baseDir = androidDataDir;
          }
        }
      }
      baseDir ??= Directory.current;

      final storageDir = Directory('${baseDir.path}/.ciltizi_data');
      if (!await storageDir.exists()) {
        await storageDir.create(recursive: true);
      }
      return File('${storageDir.path}/$boxName.json');
    } catch (e) {
      debugPrint('Yerel dosya yolu alınırken hata: $e');
      return null;
    }
  }

  /// Veriyi belirtilen anahtarla (kutuyla) kaydeder
  Future<void> write(String key, dynamic data) async {
    final jsonStr = jsonEncode(data);
    _memoryStore[key] = jsonStr;

    final file = await _getFile(key);
    if (file != null) {
      try {
        await file.writeAsString(jsonStr, flush: true);
      } catch (e) {
        debugPrint('LocalStorage write hatası ($key): $e');
      }
    }
  }

  /// Belirtilen anahtara (kutuya) ait veriyi okur
  Future<dynamic> read(String key) async {
    // Önce belleğe bakalım
    if (_memoryStore.containsKey(key)) {
      return jsonDecode(_memoryStore[key]!);
    }

    final file = await _getFile(key);
    if (file != null && await file.exists()) {
      try {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          _memoryStore[key] = content;
          return jsonDecode(content);
        }
      } catch (e) {
        debugPrint('LocalStorage read hatası ($key): $e');
      }
    }

    return null;
  }

  /// Belirtilen anahtara ait veriyi siler
  Future<void> delete(String key) async {
    _memoryStore.remove(key);
    final file = await _getFile(key);
    if (file != null && await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        debugPrint('LocalStorage delete hatası ($key): $e');
      }
    }
  }
}
