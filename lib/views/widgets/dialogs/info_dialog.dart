import 'package:flutter/widgets.dart';

import '../../../core/constants/images.dart';
import '../../../core/styling/text_style.dart';
import '../../../core/utils/extensions/integer_extensions.dart';
import '../app_text_field.dart';
import '../media/image_view.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog(
      {super.key, required this.information, this.title, this.actionButton,this.dismissible = true});

  final String? title;
  final String information;
  final Widget? actionButton;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: dismissible,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageView(
              image: Images.info,
              width: 40,
              height: 40,
            ),
            if (title != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: AppTextField(
                  text: title!,
                  textStyle: AppTextStyle(context: context, fontSize: 14).fw900(),
                ),
              ),
            10.h,
            AppTextField(
              text: information,
              textStyle: AppTextStyle(context: context, fontSize: 13).fw600(),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null)
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: actionButton!,
              )
          ],
        ),
      ),
    );
  }
}
