import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/domain/use_case/profile_usecase.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef DeleteAccountState = BaseState<void>;

class DeleteAccountViewmodel extends Notifier<DeleteAccountState> {
  final ProfileUseCase profileUseCase;

  DeleteAccountViewmodel({required this.profileUseCase});

  @override
  DeleteAccountState build() {
    return DeleteAccountState.initial();
  }

  Future<void> deleteAccount() async {
    try {
      state = DeleteAccountState.loading();
      final profile = await profileUseCase.deleteAccount();
      state = DeleteAccountState.success(profile);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = DeleteAccountState.error(errorMessage);
    }
  }
}
