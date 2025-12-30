import 'package:japaneseapp/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState{}

class LoadingProfileState extends ProfileState{}

class LoadedProfileState extends ProfileState{
  final ProfileEntity profileEntity;

  LoadedProfileState({required this.profileEntity});
}

class ErrorProfileState extends ProfileState{
  final String msg;

  ErrorProfileState({required this.msg});
}