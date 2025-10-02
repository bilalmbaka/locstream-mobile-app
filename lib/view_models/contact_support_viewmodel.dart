import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/enums.dart';
import 'package:locstream/domain/use_case/profile_usecase.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';

typedef ContactSupportState = BaseState<void>;

class ContactSupportViewModel extends Notifier<ContactSupportState> {
  final ProfileUseCase profileUseCase;

  ContactSupportViewModel({required this.profileUseCase});

  @override
  ContactSupportState build() {
    return ContactSupportState.initial();
  }

  Future<void> contact({required String title, required String body}) async {
    try {
      state = ContactSupportState.loading();
      await profileUseCase.contactSupport(
        title: title,
        body: body,
      );
      state = ContactSupportState(status: Status.success);
    } catch (e) {
      final errorMessage = AppExceptionHandler.handleException(e);

      state = ContactSupportState.error(errorMessage);
    }
  }
}
