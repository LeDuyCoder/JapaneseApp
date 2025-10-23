# 🏫 Japanese Learning App

Ứng dụng học tiếng Nhật được xây dựng bằng **Flutter**, giúp người dùng học từ vựng, chữ cái, và luyện tập qua các bài học, chủ đề và bảng xếp hạng.  
Dự án được thiết kế theo hướng **Clean Architecture**, tách biệt rõ ràng giữa các tầng logic, dữ liệu và giao diện.


---

## ⚙️ Công nghệ & Thư viện chính

- **Flutter 3.24.1**
- **Dart 3.5.1 DevTools 2.37.2**
- **Firebase** (Authentication, Firestore, Storage)
- **Bloc / Cubit** để quản lý trạng thái
- **Intl** cho đa ngôn ngữ
- **Shared Preferences / Hive** để lưu dữ liệu local
- **Dio / Http** cho networking
- **Lottie / Rive** cho animation

---

## 🚀 Tính năng nổi bật

- 🧩 Học từ vựng, chữ cái Hiragana & Katakana
- 📚 Quản lý thư mục, chủ đề và bài học
- 🎯 Tính điểm & phần thưởng khi học
- 🏆 Bảng xếp hạng và thành tích
- 👤 Đăng nhập / Đăng ký bằng Firebase
- 🌐 Đa ngôn ngữ (có thư mục `l10n/`)
- ⚙️ Tuỳ chỉnh cài đặt học, giao diện và ngôn ngữ
- 📥 Tải xuống tài liệu và lưu offline

---

## 🧠 Kiến trúc & Quy ước

Ứng dụng áp dụng mô hình **Clean Architecture** gồm 3 tầng chính:

| Tầng | Thư mục | Mô tả |
|------|----------|-------|
| Presentation | `Screen/`, `Widget/`, `Theme/` | Giao diện người dùng, UI + State |
| Domain | `features/`, `Module/` | Logic nghiệp vụ, use case |
| Data | `Service/`, `DTO/`, `Config/` | Làm việc với API, Firebase, cơ sở dữ liệu |

Quản lý trạng thái bằng **Bloc**, chia rõ `Event`, `State` và `Bloc` trong thư mục `State/`.

---

