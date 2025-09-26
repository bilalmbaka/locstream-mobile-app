import 'package:flutter/material.dart';

import '../../../core/styling/colors.dart';
import '../../../core/utils/helpers/helpers.dart';

class TransactionLoadingShimmers extends StatelessWidget {
  const TransactionLoadingShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(10, (index) {
          return AppHelpers.defaultShimmer(
            context: context,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10),
              height: 50,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        })
      ],
    );
  }
}
