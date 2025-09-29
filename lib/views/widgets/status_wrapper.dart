import 'package:flutter/material.dart';
import 'package:locstream/views/widgets/loading_indicator.dart';

import '../../../core/utils/extensions/integer_extensions.dart';
import '../../../core/utils/helpers/helpers.dart';
import '../../core/enums.dart';
import 'buttons/plain_button.dart';

class StatusWrapper extends StatelessWidget {
  const StatusWrapper(
      {super.key,
      required this.status,
      this.showErrorState = true,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.mainAxisSize = MainAxisSize.max,
      this.showSuccessWidget = false,
      this.showLoadingForInitialState = false,
      this.loadingChild,
      this.message,
      this.padding,
      this.child,
      this.retryFunction,
      this.retryWidget});

  final Status status;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final String? message;
  final bool showLoadingForInitialState;
  final Widget? retryWidget;
  final bool showSuccessWidget;
  final Widget? loadingChild;
  final EdgeInsets? padding;
  final Function? retryFunction;
  final bool showErrorState;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (status == Status.success && child != null) {
      return child!;
    }

    return Padding(
      padding: padding ?? AppHelpers.defaultPadding(),
      child: Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(),
          if (status == Status.loading ||
              (showLoadingForInitialState && status == Status.initial))
            (loadingChild != null)
                ? loadingChild!
                : const Center(
                    child: AppLoadingIndicator(),
                  ),
          if (showErrorState && (status == Status.error)) ...[
            Icon(Icons.error),
            if (message != null) ...[
              20.h,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (retryFunction != null) ...[
                20.h,
                PlainButton(
                  width: 150,
                  onTap: () => retryFunction!(),
                  text: "Retry",
                )
              ]
            ]
          ],
          if (showErrorState && status == Status.noNetwork) ...[
            Icon(Icons.wifi_off),
            if (message != null) ...[
              20.h,
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (retryFunction != null) ...[
                20.h,
                PlainButton(
                  onTap: () => retryFunction!(),
                  text: "Retry",
                )
              ]
            ]
          ]
        ],
      ),
    );
  }
}
