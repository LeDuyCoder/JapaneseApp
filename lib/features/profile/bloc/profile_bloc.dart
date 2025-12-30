import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:japaneseapp/features/profile/bloc/profile_event.dart';
import 'package:japaneseapp/features/profile/bloc/profile_state.dart';
import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';
import 'package:japaneseapp/features/profile/domain/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(LoadingProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    try{
      ProfileEntity profileEntity = await repository.getProfile();
      emit(LoadedProfileState(profileEntity: profileEntity));
    }catch(e){
      emit(ErrorProfileState(msg: e.toString()));
    }
  }
}
