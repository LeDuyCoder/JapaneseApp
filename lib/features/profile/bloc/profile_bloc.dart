import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/profile/bloc/profile_event.dart';
import 'package:japaneseapp/features/profile/bloc/profile_state.dart';
import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';
import 'package:japaneseapp/features/profile/domain/repository/profile_repository.dart';

/// Bloc chịu trách nhiệm quản lý trạng thái cho màn hình Profile.
///
/// Bloc này thuộc **tầng presentation** và đóng vai trò:
/// - Nhận event từ UI
/// - Gọi domain layer thông qua [ProfileRepository]
/// - Emit state tương ứng để UI render
///
/// ## Luồng xử lý
/// ```text
/// UI
///  └── LoadProfileEvent
///        ↓
///   ProfileBloc
///        ↓
///   ProfileRepository (domain)
///        ↓
///   Emit ProfileState
/// ```
///
/// ## Nguyên tắc
/// - Bloc KHÔNG truy cập trực tiếp data source
/// - Bloc KHÔNG chứa logic lưu trữ hay framework
/// - Bloc chỉ điều phối luồng dữ liệu và trạng thái UI
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  /// Repository dùng để lấy dữ liệu hồ sơ người dùng.
  ///
  /// Đây là abstraction ở tầng domain,
  /// Bloc không quan tâm dữ liệu đến từ đâu (local / remote).
  final ProfileRepository repository;

  /// Khởi tạo [ProfileBloc] với trạng thái ban đầu là [LoadingProfileState].
  ///
  /// [repository] được inject để:
  /// - dễ test
  /// - đảm bảo separation of concerns
  ProfileBloc(this.repository) : super(LoadingProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  /// Xử lý sự kiện [LoadProfileEvent].
  ///
  /// Quy trình:
  /// 1. Gọi [ProfileRepository.getProfile]
  /// 2. Nếu thành công → emit [LoadedProfileState]
  /// 3. Nếu lỗi → emit [ErrorProfileState]
  Future<void> _onLoadProfile(
      LoadProfileEvent event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      final ProfileEntity profileEntity =
      await repository.getProfile();

      emit(
        LoadedProfileState(profileEntity: profileEntity),
      );
    } catch (e) {
      emit(
        ErrorProfileState(msg: e.toString()),
      );
    }
  }
}
