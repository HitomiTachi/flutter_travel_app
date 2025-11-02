# 📚 Flutter Travels App - Documentation

Thư mục tài liệu cho dự án Flutter Travel App.

## 📖 Mock Data Documentation

### 1. [Mock Data Guide](MOCK_DATA_GUIDE.md)
**Hướng dẫn sử dụng Mock Data Providers**
- Architecture và design patterns
- Cách sử dụng `DestinationDataProvider` và `ArticleDataProvider`
- Code examples cho các use cases
- Firebase migration plan

### 2. [Mock Data Usage Map](MOCK_DATA_USAGE.md)
**Tracking file nào đang dùng provider nào**
- Danh sách đầy đủ files đang import mock providers
- Methods được sử dụng ở đâu
- Statistics và metrics
- Opportunities để tối ưu thêm

### 3. [Mock Data Cleanup History](MOCK_DATA_CLEANUP.md)
**Lịch sử clean up deprecated files**
- Quá trình xóa `destination_data.dart` và `article_data.dart`
- Impact analysis
- Breaking changes (nếu có)

---

## 🎯 Quick Links

### Cho Developer Mới
1. Đọc [MOCK_DATA_GUIDE.md](MOCK_DATA_GUIDE.md) → Hiểu cách dùng providers
2. Xem [MOCK_DATA_USAGE.md](MOCK_DATA_USAGE.md) → Tham khảo examples có sẵn

### Cho Maintainer
1. Xem [MOCK_DATA_USAGE.md](MOCK_DATA_USAGE.md) → Kiểm tra ai đang dùng gì
2. Đọc [MOCK_DATA_CLEANUP.md](MOCK_DATA_CLEANUP.md) → Hiểu lịch sử thay đổi

---

## 📂 Cấu trúc Mock Data

```
lib/data/mock/
├── destination_data_provider.dart  ← Destinations data
├── article_data_provider.dart      ← Articles data
├── map_locations.dart              ← Map markers
└── trip_plans_list_data_provider.dart ← Trip plans
```

**Single Source of Truth:** Mỗi provider là nguồn duy nhất cho data type của nó.

---

## 🚀 Workflow

### Khi thêm feature mới cần mock data:
1. Tạo method mới trong provider (ví dụ: `getDestinationsByTag()`)
2. Update [MOCK_DATA_GUIDE.md](MOCK_DATA_GUIDE.md) với example
3. Sau khi merge, update [MOCK_DATA_USAGE.md](MOCK_DATA_USAGE.md)

### Khi migrate sang Firebase:
1. Tạo Service tương ứng (ví dụ: `DestinationService`)
2. Replace provider calls bằng service calls
3. Document trong [MOCK_DATA_GUIDE.md](MOCK_DATA_GUIDE.md)

---

## 📊 Current Status

| Provider | Files Using | Firebase Ready | Status |
|----------|-------------|----------------|--------|
| DestinationDataProvider | 2 | ❌ | Mock only |
| ArticleDataProvider | 2 | ❌ | Mock only |
| TripPlansListDataProvider | ? | ❌ | Mock only |

---

## 🔍 Related Documentation

- **Main README:** `../README.md` (Project overview)
- **Firebase Setup:** Chưa có
- **API Documentation:** Chưa có

---

**Last Updated:** 2025-11-02
