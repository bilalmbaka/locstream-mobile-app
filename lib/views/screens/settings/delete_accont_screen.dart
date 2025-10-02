import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/images.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/services/navigation_service.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/helpers/dialog_helpers.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/screens/authentication/login_screen.dart';
import 'package:locstream/views/screens/settings/contact_support_screen.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/dialogs/info_dialog.dart';
import 'package:locstream/views/widgets/input_forms/app_input_form.dart';
import 'package:locstream/views/widgets/loading_dialog.dart';
import 'package:locstream/views/widgets/media/image_view.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  static const routeName = 'delete-account';
  static const path = routeName;

  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _otherReasonTextController = TextEditingController();

  final List<String> deletionReasons = [
    "Uses too much battery",
    "Too invasive",
    "I don't like the app",
    "Terrible app",
    "Uses too much space",
    "Too resource intensive",
    "No particular reason",
    "Too expensive",
  ];
  String? selectedReason = "No particular reason";

  @override
  Widget build(BuildContext context) {
    final deleteAccount = ref.watch(deleteAccountViewModel);

    ref.listen(deleteAccountViewModel, (previous, next) {
      if (next.isSuccess) {
        NavigationService.jumpToScreen(
          context: context,
          routeName: LoginScreen.routeName,
        );
      }
    });

    return Scaffold(
      appBar: AppAppBar(title: AppStrings.deleteAccount),
      body: LoadingDialog(
        state: deleteAccount,
        dismissOverlay: () {
          ref.invalidate(deleteAccountViewModel);
        },
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              RadioGroup<String>(
                groupValue: selectedReason,
                onChanged: (String? reason) {
                  if (reason != null) {
                    setState(() {
                      selectedReason = reason;
                    });
                  }
                },
                child: Column(
                  children: [
                    ...deletionReasons.map((reason) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedReason = reason;
                          });
                        },
                        child: Row(
                          spacing: 10,
                          children: [
                            Radio(value: reason),
                            AppTextField(
                              text: reason,
                              textStyle: AppTextStyle(
                                context: context,
                                fontSize: 12,
                              ).fw900(),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Padding(
                padding: AppHelpers.defaultPadding(top: 0, bottom: 0),
                child: AppInputForm(
                  height: 150,
                  title: AppStrings.otherReason,
                  controller: _otherReasonTextController,
                  hint: AppStrings.letUsKnow,
                  expands: true,
                ),
              ),

              Padding(
                padding: AppHelpers.defaultPadding(top: 0, bottom: 0),
                child: PlainButton(
                  onTap: () async {
                    final delete = await DialogHelpers.showAppDialog<bool?>(
                      context: context,
                      child: InfoDialog(
                        coverImage: ImageView(
                          image: Images.moody,
                          width: 70,
                          height: 70,
                          color: AppColors.white,
                        ),
                        information:
                            "Instead of deleting you account why not contact us so we could help resolve your issue.",
                        actionButton: Column(
                          spacing: 10,
                          children: [
                            PlainButton(
                              onTap: () {
                                NavigationService.pop(
                                  context: context,
                                  data: true,
                                );
                              },
                              backgroundColor: AppColors.redMain,
                              text: AppStrings.delete,
                            ),
                            PlainButton(
                              onTap: () {
                                NavigationService.pop(
                                  context: context,
                                  data: false,
                                );
                              },
                              text: AppStrings.contactSupport,
                            ),
                          ],
                        ),
                      ),
                    );

                    if (delete == true) {
                      await ref
                          .read(deleteAccountViewModel.notifier)
                          .deleteAccount();
                    }

                    if (delete == false) {
                      NavigationService.pushToScreen(
                        context: context,
                        routeName: ContactSupportScreen.routeName,
                      );
                    }
                  },
                  backgroundColor: AppColors.redMain,
                  text: AppStrings.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
