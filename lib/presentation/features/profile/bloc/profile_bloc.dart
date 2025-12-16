import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final HomeRepository homeRepository;

  ProfileBloc({required this.homeRepository}) : super(ProfileInitial()) {
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
  }
}
