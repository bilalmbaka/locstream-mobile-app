import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/domain/use_case/auth_usecase.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef UserNameSuggestionState = BaseState<List<String>>;

class SuggestUserNameViewModel extends Notifier<UserNameSuggestionState> {
  SuggestUserNameViewModel({required this.authUseCase});

  final AuthUseCase authUseCase;

  @override
  UserNameSuggestionState build() {
    return UserNameSuggestionState.initial();
  }

  Future<void> suggest({required String email}) async {
    try {
      state = BaseState.loading();

      final users = await authUseCase.suggestUserNames(email: email);

      state = UserNameSuggestionState.success(users);
    } catch (e, s) {
      final errorMessage = AppExceptionHandler.handleException(
        e,
        stackTrace: s,
      );

      state = UserNameSuggestionState.error(errorMessage, e: e);
    }
  }

  void reset() => state = BaseState.initial();
}
