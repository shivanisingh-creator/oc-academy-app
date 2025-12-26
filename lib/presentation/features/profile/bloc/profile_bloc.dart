import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';

import 'package:oc_academy_app/data/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final HomeRepository homeRepository;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  ProfileBloc({
    required this.homeRepository,
    required this.authRepository,
    required this.userRepository,
  }) : super(ProfileInitial()) {
    on<FetchProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await homeRepository.getUserLite();
        if (user != null) {
          emit(ProfileLoaded(user: user));
        } else {
          emit(const ProfileError(message: 'Failed to fetch user data.'));
        }
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await authRepository.logout();
      } catch (e) {
        // Log the error but proceed with logout from the app's perspective
        // as local tokens would have been cleared by authRepository.logout()
        print('Error during logout API call: $e');
      }
      emit(LogoutSuccess());
    });

    on<UpdateProfileLocal>((event, emit) {
      if (event.user.response != null) {
        emit(ProfileLoaded(user: event.user));
      }
    });
  }
}
