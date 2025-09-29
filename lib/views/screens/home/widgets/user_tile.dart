import 'package:flutter/material.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/data/model/asset_model.dart';
import 'package:locstream/views/widgets/app_text_field.dart';
import 'package:locstream/views/widgets/profile_picture.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, this.profilePicture, required this.userName});

  final Asset? profilePicture;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        ProfilePicture(
          initials: userName[0],
          profilePicture: profilePicture?.url,
          initialsFontSize: 10,
          defaultWidgetPadding: 10,
        ),
        AppTextField(
          text: userName,
          textStyle: AppTextStyle(context: context, fontSize: 13).fw500(),
        ),
      ],
    );
  }
}
