import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/view_models/auth/login_viewmodel.dart';
import 'package:locstream/view_models/auth/reset_password_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_otp_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_viewmodel.dart';
import 'package:locstream/view_models/notifications/push_notifications_viewmodel.dart';
import 'package:locstream/view_models/profile/change_password_viewmodel.dart';
import 'package:locstream/view_models/profile/check_username_availabilty.dart';
import 'package:locstream/view_models/profile/edit_profile_viewmodel.dart';
import 'package:locstream/view_models/profile/find_users_viewmodel.dart';
import 'package:locstream/view_models/profile/profile_viewmodel.dart';
import 'package:locstream/view_models/profile/suggest_username_viewmodel.dart';

import 'core/services/push_notification/push_notification_service.dart';
import 'data/repository/authentication_repository.dart';
import 'data/repository/profile_repository.dart';
import 'domain/use_case/profile_usecase.dart';
import 'domain/use_case/auth_usecase.dart';

final _authUseCase = AuthUseCase(
  authRepo: AuthRepository(),
  profileRepo: ProfileRepository(),
);

final _profileUseCase = ProfileUseCase(profileRepo: ProfileRepository());

final signupViewModel = NotifierProvider<SignupViewModel, SignupState>(
  () => SignupViewModel(authUseCase: _authUseCase),
);

final signupOtpViewModel = NotifierProvider<SignupOtpViewModel, SignupOtpState>(
  () => SignupOtpViewModel(authUseCase: _authUseCase),
);

final profileViewModel = NotifierProvider<ProfileViewModel, ProfileState>(
  () => ProfileViewModel(profileUseCase: _profileUseCase),
);

final editProfileViewModel =
    NotifierProvider<EditProfileViewmodel, EditProfileState>(
      () => EditProfileViewmodel(profileUseCase: _profileUseCase),
    );

final loginViewModel = NotifierProvider<LoginViewModel, LoginState>(
  () => LoginViewModel(loginUseCase: _authUseCase),
);

final resetPasswordViewModel =
    NotifierProvider<ResetPasswordViewmodel, ResetPasswordState>(
      () => ResetPasswordViewmodel(authUseCase: _authUseCase),
    );

final changePasswordViewModel =
    NotifierProvider<ChangePasswordViewModel, ChangePasswordState>(
      () => ChangePasswordViewModel(authUseCase: _authUseCase),
    );

final fetchingMoreUsersState = ValueNotifier<bool>(false);

final findUsersViewModel = NotifierProvider<FindUsersViewmodel, FindUsersState>(
  () => FindUsersViewmodel(profileUsecase: _profileUseCase),
);

final pushNotificationsViewModel =
    NotifierProvider<PushNotificationViewModel, void>(
      () => PushNotificationViewModel(
        pushNotificationService: PushNotificationService(),
        profileUseCase: _profileUseCase,
      ),
    );

final isDialogLoading = ValueNotifier<BaseState>(BaseState.initial());

final suggestUserNameViewModel =
    NotifierProvider<SuggestUserNameViewModel, UserNameSuggestionState>(
      () => SuggestUserNameViewModel(authUseCase: _authUseCase),
    );

final checkUserNameAvailabilityViewModel =
    NotifierProvider<CheckUserNameAvailability, UserNameAvailabilityState>(
      () => CheckUserNameAvailability(profileUseCase:  _profileUseCase),
    );
