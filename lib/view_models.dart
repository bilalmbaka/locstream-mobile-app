import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/services/location_service.dart';

import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/data/repository/maps_repositoty.dart';
import 'package:locstream/data/repository/share_location_repository.dart';
import 'package:locstream/domain/use_case/maps_usecase.dart';
import 'package:locstream/domain/use_case/share_location_use_case.dart';
import 'package:locstream/view_models/auth/login_viewmodel.dart';
import 'package:locstream/view_models/auth/logout_viewmodel.dart';
import 'package:locstream/view_models/auth/reset_password_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_otp_viewmodel.dart';
import 'package:locstream/view_models/auth/signup_viewmodel.dart';
import 'package:locstream/view_models/directions_viewmodel.dart';
import 'package:locstream/view_models/location_viewmodel.dart';
import 'package:locstream/view_models/notifications/push_notifications_viewmodel.dart';
import 'package:locstream/view_models/profile/change_password_viewmodel.dart';
import 'package:locstream/view_models/profile/check_username_availabilty.dart';
import 'package:locstream/view_models/profile/edit_profile_viewmodel.dart';
import 'package:locstream/view_models/profile/find_users_viewmodel.dart';
import 'package:locstream/view_models/profile/profile_viewmodel.dart';
import 'package:locstream/view_models/profile/suggest_username_viewmodel.dart';
import 'package:locstream/view_models/watchers/add_new_watcher_viewmodel.dart';
import 'package:locstream/view_models/watchers/watchers_viewmodel.dart';
import 'package:locstream/view_models/watchers/watching_viewmodel.dart';

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

final _shareLocationUseCase = ShareLocationUseCase(
  shareLocationRepo: ShareLocationRepository(),
);

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

final logoutViewModel = NotifierProvider<LogoutViewModel, LogoutState>(
  () => LogoutViewModel(authUseCase: _authUseCase),
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

final findUsersViewModel =
    NotifierProvider.autoDispose<FindUsersViewmodel, FindUsersState>(
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
      () => CheckUserNameAvailability(profileUseCase: _profileUseCase),
    );

final addNewWatcherViewModel =
    NotifierProvider<AddNewWatchersViewModel, AddNewWatcherState>(
      () =>
          AddNewWatchersViewModel(shareLocationUseCase: _shareLocationUseCase),
    );

final watchersViewModel = NotifierProvider<WatchersViewModel, WatchersState>(
  () => WatchersViewModel(shareLocationUseCase: _shareLocationUseCase),
);

final watchingViewModel = NotifierProvider<WatchingViewModel, WatchingState>(
  () => WatchingViewModel(shareLocationUseCase: _shareLocationUseCase),
);

final locationViewModel = NotifierProvider<LocationViewModel, LocationState>(
  () => LocationViewModel(
    profileUseCase: _profileUseCase,
    locationService: LocationService(),
  ),
);

final directionsViewModel =
    NotifierProvider<DirectionsViewmodel, DirectionsState>(
      () => DirectionsViewmodel(
        mapsUseCase: MapsUseCase(mapsRepository: MapsRepository()),
      ),
    );
