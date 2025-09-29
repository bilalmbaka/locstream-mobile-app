import 'package:flutter/material.dart';
import 'package:locstream/core/styling/colors.dart';
import 'package:locstream/core/styling/text_style.dart';
import 'package:locstream/views/widgets/app_text_field.dart';

class DrawerTile extends StatefulWidget {
  const DrawerTile({
    super.key,
    required this.context,
    required this.title,
    required this.onTap,
    this.showInfoIcon = false,
    this.isActive = false,
    this.info,
  });

  final BuildContext context;
  final String title;
  final VoidCallback onTap;
  final bool showInfoIcon;
  final String? info;
  final bool isActive;

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          color: AppColors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppTextField(
                        text: widget.title,
                        textStyle: AppTextStyle(
                          context: context,
                          fontSize: 13,
                        ).fw500(),
                      ),
                      if (widget.showInfoIcon)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showInfo = !_showInfo;
                              });
                            },
                            child: Icon(Icons.help, size: 15),
                          ),
                        ),
                    ],
                  ),

                  Icon(
                    widget.isActive
                        ? Icons.keyboard_arrow_down
                        : Icons.arrow_forward_ios_outlined,
                    size: widget.isActive ? 13 : 10,
                  ),
                ],
              ),

              if (_showInfo && widget.info != null)
                Positioned(
                  left: 85,
                  top: -60,
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: AppTextField(text: widget.info!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
