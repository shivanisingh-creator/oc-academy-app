part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileData extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class UpdateProfileLocal extends ProfileEvent {
  final UserLiteResponse user;
  const UpdateProfileLocal(this.user);
  @override
  List<Object> get props => [user];
}
