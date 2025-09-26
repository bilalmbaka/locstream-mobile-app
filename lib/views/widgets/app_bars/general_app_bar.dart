import 'package:flutter/material.dart';

import '../../../core/services/navigation_service.dart';
import '../../../core/styling/text_style.dart';
import '../app_text_field.dart';

class AppAppBar<T> extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.returnValue,
    this.title,
    this.actions,
  });

  final T? returnValue;
  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      title: title != null
          ? AppTextField(
              text: title!,
              textStyle: AppTextStyle(context: context).fw900(),
            )
          : null,
      leading: GestureDetector(
          onTap: () =>
              NavigationService.pop<T?>(context: context, data: returnValue),
          child: Icon(
            Icons.arrow_back_ios,
            size: 22,
          )),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
