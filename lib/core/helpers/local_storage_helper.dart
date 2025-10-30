import 'package:hive_flutter/hive_flutter.dart';
<<<<<<< HEAD
=======
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert' show jsonEncode, jsonDecode;

// Conditional import cho web
import 'local_storage_stub.dart' if (dart.library.html) 'dart:html' as html;
>>>>>>> 72ffec4 (Initial commit)

class LocalStorageHelper {
  LocalStorageHelper._internal();
  static final LocalStorageHelper _shared = LocalStorageHelper._internal();

<<<<<<< HEAD
  factory LocalStorageHelper(){
=======
  factory LocalStorageHelper() {
>>>>>>> 72ffec4 (Initial commit)
    return _shared;
  }

  Box<dynamic>? hiveBox;
<<<<<<< HEAD
  static initLocalStorageHelper() async{
    _shared.hiveBox = await Hive.openBox('Travel App');
  }

  static dynamic getValue(String key){
    return _shared.hiveBox?.get(key);
  }

  static setValue(String key, dynamic val){
    _shared.hiveBox?.put(key, val);
  }
}
=======

  static initLocalStorageHelper() async {
    if (kIsWeb) {
      // Trên web, sử dụng HTML5 localStorage thay vì Hive
      // Không cần init gì cả, localStorage đã sẵn sàng
      return;
    } else {
      // Trên mobile, sử dụng Hive
      _shared.hiveBox = await Hive.openBox('Travel App');
    }
  }

  static dynamic getValue(String key) {
    if (kIsWeb) {
      // Sử dụng localStorage trên web
      try {
        final value = html.window.localStorage[key];
        if (value == null) return null;
        // Cố gắng parse JSON nếu có thể
        try {
          return jsonDecode(value);
        } catch (e) {
          // Nếu không phải JSON, trả về string
          return value;
        }
      } catch (e) {
        return null;
      }
    } else {
      return _shared.hiveBox?.get(key);
    }
  }

  static setValue(String key, dynamic val) {
    if (kIsWeb) {
      // Sử dụng localStorage trên web
      try {
        final storage = html.window.localStorage;
        if (val == null) {
          storage.remove(key);
        } else if (val is String || val is num || val is bool) {
          storage[key] = val.toString();
        } else {
          // Convert object thành JSON string
          storage[key] = jsonEncode(val);
        }
      } catch (e) {
        print('Error saving to localStorage: $e');
      }
    } else {
      _shared.hiveBox?.put(key, val);
    }
  }
}
>>>>>>> 72ffec4 (Initial commit)
