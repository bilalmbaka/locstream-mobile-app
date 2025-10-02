import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/utils/forms/text_validators.dart';
import 'package:locstream/core/utils/helpers/helpers.dart';
import 'package:locstream/view_models.dart';
import 'package:locstream/views/widgets/app_bars/general_app_bar.dart';
import 'package:locstream/views/widgets/buttons/plain_button.dart';
import 'package:locstream/views/widgets/input_forms/app_input_form.dart';
import 'package:locstream/views/widgets/loading_dialog.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  static const routeName = 'contact-support';
  static const path = routeName;

  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _details = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Contact support',
        actions: [
          GestureDetector(
            onTap: () {
              AppHelpers.launchWebSite("mailto:jhondoe@gmail.com");
            },
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ladingPageGradientGreen,
              ),
              child: Icon(Icons.mail, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final contactSupport = ref.watch(contactSupportViewModel);

          return LoadingDialog(
            state: contactSupport,
            dismissOverlay: () {
              ref.invalidate(contactSupportViewModel);
            },
            showSuccessState: true,
            successMessage:
                'Thank you for reaching out, we will get back to you via your registered email.',
            child: AppHelpers.wrapChildWithLayoutBuilder(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 30,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 30,
                      children: [
                        AppInputForm(
                          title: 'Title',
                          controller: _title,
                          validator: AppTextValidators.isEmpty,
                        ),
                        AppInputForm(
                          title: 'Details',
                          controller: _details,
                          expands: true,
                          validator: AppTextValidators.isEmpty,
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                  PlainButton(
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;

                      await ref
                          .read(contactSupportViewModel.notifier)
                          .contact(title: _title.text, body: _details.text);
                    },
                    text: AppStrings.continueText,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
