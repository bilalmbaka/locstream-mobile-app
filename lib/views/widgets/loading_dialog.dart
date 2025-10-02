import 'package:flutter/material.dart';
import 'package:locstream/core/constants/constants.dart';
import 'package:locstream/core/constants/images.dart';
import 'package:locstream/core/constants/strings.dart';
import 'package:locstream/core/enums.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/core/utils/base_state.dart';
import 'package:locstream/views/widgets/app_text_field.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
    required this.child,
    required this.state,
    required this.dismissOverlay,
    this.image,
    this.showSuccessState,
    this.successMessage,
  });

  final Widget child;
  final BaseState state;
  final VoidCallback dismissOverlay;
  final String? image;
  final bool? showSuccessState;
  final String? successMessage;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: state.isInitial,
      onPopInvokedWithResult: (canPop, result) {
        // print("can pop ${canPop}");
        // print("current state is ${state.status}");

        if (canPop == false) {
          if (state.isError || state.isSuccess) {
            dismissOverlay();
            return;
          }
        }
      },
      child: Stack(
        children: [
          child,
          if (state.isLoading ||
              state.isError ||
              (state.isSuccess && showSuccessState == true))
            GestureDetector(
              onTap: () {
                if (state.isLoading == false) {
                  dismissOverlay();
                }
              },
              child: Container(
                decoration: BoxDecoration(color: AppColors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 300),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.symmetric(
                        vertical: 70,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dialogTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _loadingIndicator(state),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingIndicator(BaseState state) {
    return Builder(
      builder: (context) {
        if (state.isSuccess) {
          return Column(
            children: [
              Image.asset(Images.verified, width: 100, height: 100),
              if (successMessage != null) ...[
                AppConstants.mediumYSpace,
                AppTextField(
                  text: successMessage!,
                  textAlign: TextAlign.center,
                  textStyle: AppTextStyle(context: context).fw600(),
                ),
              ],
            ],
          );
        } else if (state.isError) {
          String image = Images.dataGif;

          if (state.status == Status.noNetwork) {
            image = Images.noInternet;
          }

          return Column(
            children: [
              Image.asset(this.image ?? image, width: 100, height: 100),
              AppConstants.mediumYSpace,
              AppTextField(
                text: state.errorMessage ?? AppStrings.somethingWentWrong,
                textStyle: AppTextStyle(context: context).fw600(),
              ),
            ],
          );
        } else {
          return Image.asset(Images.loadingGif, width: 100, height: 100);
        }
      },
    );
  }
}
