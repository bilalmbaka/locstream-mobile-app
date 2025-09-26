import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/view_models/auth/login_viewmodel.dart';
import 'package:locstream/view_models/auth/reset_password_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_otp_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_viewmodel.dart';
import 'package:locstream/view_models/notifications/push_notifications_viewmodel.dart';
import 'package:locstream/view_models/profile/change_password_viewmodel.dart';
import 'package:locstream/view_models/profile/edit_profile_viewmodel.dart';
import 'package:locstream/view_models/profile/find_users_viewmodel.dart';
import 'package:locstream/view_models/profile/profile_viewmodel.dart';

import 'core/services/push_notification/push_notification_service.dart';
import 'data/repository/authentication_repository.dart';
import 'data/repository/profile_repository.dart';
import 'domain/use_case/profile_usecase.dart';
import 'domain/use_case/auth_usecase.dart';

final _authUseCase = AuthUseCase(
  authRepo: AuthRepository(),
);

final _profileUseCase = ProfileUseCase(
  profileRepo: ProfileRepository(),
);


final signupViewModel = NotifierProvider<SignupViewmodel, SignupState>(
  () => SignupViewmodel(authUseCase: _authUseCase),
);

final signupOtpViewModel = NotifierProvider<SignupOtpViewmodel, SignupOtpState>(
  () => SignupOtpViewmodel(authUseCase: _authUseCase),
);

final profileViewModel = NotifierProvider<ProfileViewmodel, ProfileState>(
  () => ProfileViewmodel(profileUseCase: _profileUseCase),
);

final editProfileViewModel =
    NotifierProvider<EditProfileViewmodel, EditProfileState>(
  () => EditProfileViewmodel(profileUseCase: _profileUseCase),
);

final loginViewModel = NotifierProvider<LoginViewmodel, LoginState>(
  () => LoginViewmodel(loginUsecase: _authUseCase),
);

final resetPasswordViewModel =
    NotifierProvider<ResetPasswordViewmodel, ResetPasswordState>(
  () => ResetPasswordViewmodel(authUseCase: _authUseCase),
);

final changePasswordViewModel =
    NotifierProvider<ChangePasswordViewmodel, ChangePasswordState>(
  () => ChangePasswordViewmodel(authUseCase: _authUseCase),
);

final fetchingMoreUsersState = ValueNotifier<bool>(false);

final findUsersViewModel = NotifierProvider<FindUsersViewmodel, FindUsersState>(
  () => FindUsersViewmodel(profileUsecase: _profileUseCase),
);


final pushNotificationsViewModel =
    NotifierProvider<PushNotificationViewModel, void>(() =>
        PushNotificationViewModel(
            pushNotificationService: PushNotificationService(),
            profileUseCase: _profileUseCase));
