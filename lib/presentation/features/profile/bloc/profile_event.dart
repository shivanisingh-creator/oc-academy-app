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

class UpdateSpecialties extends ProfileEvent {
  final List<int> specialtyIds;
  final String firstName;
  final String lastName;
  final String? qualification;
  final String? profilePicPath;

  const UpdateSpecialties({
    required this.specialtyIds,
    required this.firstName,
    required this.lastName,
    this.qualification,
    this.profilePicPath,
  });

  @override
  List<Object> get props => [specialtyIds, firstName, lastName];
}
