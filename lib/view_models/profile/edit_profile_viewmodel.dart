import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/user_model.dart';
import '../../domain/entities/profile_dto.dart';
import '../../domain/use_case/profile_usecase.dart';

typedef EditProfileState = BaseState<User>;

class EditProfileViewmodel extends Notifier<EditProfileState> {
  final ProfileUseCase profileUseCase;

  EditProfileViewmodel({required this.profileUseCase});

  @override
  EditProfileState build() {
    return BaseState.initial();
  }

  Future<void> editProfile(ProfileDto dto) async {
    try {
      state = BaseState.loading();

      // await Future.delayed(Duration(seconds: 5), () {
      //   throw UnimplementedError();
      // });

      final profile = await profileUseCase.updateProfile(dto);
      state = BaseState.success(profile);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = BaseState.error(errorMessage);
    }
  }
}
