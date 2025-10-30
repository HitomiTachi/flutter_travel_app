// Stub file cho non-web platforms
// File này sẽ được thay thế bởi dart:html khi compile cho web
library local_storage_stub;

// Stub implementation để tránh lỗi compile trên non-web platforms
class Window {
  Storage get localStorage => _LocalStorage();
}

class _LocalStorage implements Storage {
  @override
  int get length => 0;

  @override
  void clear() {}

  @override
  String? operator [](String key) => null;

  @override
  void operator []=(String key, String value) {}

  @override
  void remove(String key) {}

  @override
  String? key(int index) => null;
}

abstract class Storage {
  int get length;
  void clear();
  String? operator [](String key);
  void operator []=(String key, String value);
  void remove(String key);
  String? key(int index);
}

final window = Window();
