import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/helpers/dialog_helpers.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/data/model/user_model.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/home/widgets/user_tile.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/buttons/outlined_button.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/dialogs/info_dialog.dart';
import 'package:locstream/views/widgets/input_forms/app_input_form.dart';
import 'package:locstream/views/widgets/loading_dialog.dart';
import 'package:locstream/views/widgets/no_result.dart';
import 'package:locstream/views/widgets/status_wrapper.dart';

class AddNewWatcher extends ConsumerStatefulWidget {
  static const routeName = 'add-new-watcher';
  static const path = routeName;

  const AddNewWatcher({super.key});

  @override
  ConsumerState<AddNewWatcher> createState() => _AddNewWatcherState();
}

class _AddNewWatcherState extends ConsumerState<AddNewWatcher> {
  final _searchController = TextEditingController();
  int _startAt = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final showLoading =
          ref.read(watchersViewModel).isSuccess == false ||
          (ref.read(watchersViewModel).data ?? []).isEmpty;

      if (showLoading) {
        await ref.read(watchersViewModel.notifier).fetch();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addNewWatcher = ref.watch(addNewWatcherViewModel);

    ref.listen(addNewWatcherViewModel, (previous, next) {
      if (next.isSuccess) {
        ref.read(watchersViewModel.notifier).add(user: next.data!);
      }
    });

    return Scaffold(
      appBar: AppAppBar(title: AppStrings.addWatcher),
      body: Padding(
        padding: AppHelpers.defaultPadding(),
        child: LoadingDialog(
          state: addNewWatcher,
          dismissOverlay: () {
            ref.invalidate(addNewWatcherViewModel);
          },
          child: Consumer(
            builder: (context, ref, child) {
              final watchers = ref.watch(watchersViewModel);

              return StatusWrapper(
                status: watchers.status,
                padding: EdgeInsets.zero,
                retryFunction: () async {
                  await ref.read(watchersViewModel.notifier).fetch();
                },
                message: watchers.errorMessage,
                child: _child(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _child() {
    return Column(
      spacing: 20,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppInputForm(
          controller: _searchController,
          prefix: Icon(Icons.search),
          hint: AppStrings.userName,
          onChanged: (userName) {
            _timer?.cancel();

            if (userName == null || userName.trim() == '') {
              ref.invalidate(findUsersViewModel);
            } else {
              _timer = Timer(Duration(seconds: 2), () async {
                await _findUsers();
              });
            }
          },
        ),

        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final searchResults = ref.watch(findUsersViewModel);

              if (searchResults.isInitial) {
                return Offstage();
              } else {
                return StatusWrapper(
                  status: searchResults.status,
                  // loadingChild: Flexible(
                  //   child: SingleChildScrollView(
                  //     child: ContainerShimmer(
                  //       height: 30,
                  //       width: double.infinity,
                  //       itemCount: 200,
                  //     ),
                  //   ),
                  // ),
                  retryFunction: () async {
                    await _findUsers();
                  },
                  message: searchResults.errorMessage,
                  child: searchResults.isSuccess
                      ? _results(searchResults.data ?? [])
                      : null,
                );
              }
            },
          ),
        ),

        SizedBox(),
      ],
    );
  }

  Widget _results(List<User> users) {
    if (users.isEmpty) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          child: NoResult(message: 'No users found'),
        ),
      );
    } else {
      return Consumer(
        builder: (context, ref, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              if (user.id == ref.read(profileViewModel).data!.id) {
                return Offstage();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserTile(
                    profilePicture: user.profilePicture,
                    userName: user.userName ?? '',
                  ),

                  // if (watcher.isLoading)
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 10.0),
                  //     child: AppLoadingIndicator(
                  //       width: 15,
                  //       height: 15,
                  //       strokeWidth: .7,
                  //     ),
                  //   )
                  // else
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Builder(
                      builder: (context) {
                        if ((ref.read(watchersViewModel).data ?? [])
                            .where((element) => element.data!.id == user.id)
                            .isNotEmpty) {
                          return AppTextField(
                            text: AppStrings.watching.toLowerCase(),
                            textStyle: AppTextStyle(
                              context: context,
                              fontSize: 11,
                              color: AppColors.complimentary,
                            ).fw400(),
                          );
                        }

                        return GestureDetector(
                          onTap: () async {
                            final add = await DialogHelpers.showAppDialog<bool?>(
                              context: context,

                              child: InfoDialog(
                                coverImage: Icon(Icons.info, size: 90),
                                title: AppStrings.addWatcher,
                                information:
                                    '${user.userName} ${AppStrings.addWatcherWarning}',
                                actionButton: Row(
                                  spacing: 20,
                                  children: [
                                    Flexible(
                                      child: AppOutlinedButton(
                                        onTap: () {
                                          NavigationService.pop(
                                            context: context,
                                            data: false,
                                          );
                                        },
                                        text: AppStrings.back,
                                      ),
                                    ),
                                    Flexible(
                                      child: PlainButton(
                                        onTap: () {
                                          NavigationService.pop(
                                            context: context,
                                            data: true,
                                          );
                                        },
                                        text: AppStrings.add,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            if (add == true) {
                              await ref
                                  .read(addNewWatcherViewModel.notifier)
                                  .add(user: user);
                            }
                          },
                          child: Builder(
                            builder: (context) {
                              return AppTextField(
                                text: AppStrings.add,
                                textStyle: AppTextStyle(
                                  context: context,
                                  fontSize: 11,
                                  color: AppColors.complimentary,
                                ).fw400(),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  Future<void> _findUsers() async {
    await ref
        .read(findUsersViewModel.notifier)
        .search(searchString: _searchController.text, startAt: _startAt);
  }
}
