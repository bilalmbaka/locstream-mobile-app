import 'package:flutter/material.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/data/model/asset_model.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    this.profilePicture,
    required this.userName,
    this.nameAtBottom = false,
  });

  final Asset? profilePicture;
  final String userName;
  final bool nameAtBottom;

  @override
  Widget build(BuildContext context) {
    final children = [
      ProfilePicture(
        initials: userName[0],
        profilePicture: profilePicture?.url,
        initialsFontSize: 10,
        defaultWidgetPadding: 10,
        width: 30,
        height: 30,
      ),
      AppTextField(
        text: userName,
        maxLines: nameAtBottom ? 1 : null,
        overflow: nameAtBottom,
        textStyle: AppTextStyle(context: context, fontSize: 13).fw500(),
      ),
    ];

    if (nameAtBottom) {
      return Column(spacing: 10, children: children);
    }

    return Row(spacing: 10, children: children);
  }
}
