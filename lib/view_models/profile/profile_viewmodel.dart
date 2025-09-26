import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/user_model.dart';
import '../../domain/use_case/profile_usecase.dart';

typedef ProfileState = BaseState<User>;

class ProfileViewmodel extends Notifier<ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileViewmodel({required this.profileUseCase});

  @override
  ProfileState build() {
    return BaseState.initial();
  }

  set profile(User profile) {
    state = BaseState.success(profile);
  }

  Future<void> getProfile() async {
    try {
      state = BaseState.loading(data: state.data);
      final profile = await profileUseCase.getProfile();
      state = BaseState.success(profile);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage, data: state.data);
    }
  }
}
