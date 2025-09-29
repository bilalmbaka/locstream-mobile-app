import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error_handlers/exception_handler.dart';
import '../../core/utils/base_state.dart';
import '../../data/model/user_model.dart';
import '../../domain/use_case/profile_usecase.dart';
import '../../view_models.dart';

typedef FindUsersState = BaseState<List<User>>;

class FindUsersViewmodel extends Notifier<FindUsersState> {
  FindUsersViewmodel({required this.profileUsecase});

  final ProfileUseCase profileUsecase;

  @override
  FindUsersState build() {
    return FindUsersState.initial();
  }

  Future<void> search({
    String? searchString,
    bool showLoading = true,
    bool fetchMore = false,
    int startAt = 0,
  }) async {
    try {
      if (showLoading) {
        state = BaseState.loading();
      }

      if (fetchMore) {
        fetchingMoreUsersState.value = true;
      }

      final users = await profileUsecase.findUsers(
        searchString: searchString,
        startAt: startAt,
      );

      fetchingMoreUsersState.value = false;

      if (fetchMore) {
        final current = [...(state.data ?? const <User>[])];

        for (User user in users) {
          if (current.contains(user) == false) {
            current.add(user);
          }
        }

        state = FindUsersState.success(current);
        return;
      }

      state = FindUsersState.success(users);
    } catch (e, s) {
      fetchingMoreUsersState.value = false;

      final errorMessage =
          AppExceptionHandler.handleException(e, stackTrace: s);

      if (showLoading) {
        state = FindUsersState.error(errorMessage);
      }
    }
  }
}
