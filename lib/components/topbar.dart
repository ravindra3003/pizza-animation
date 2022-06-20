import 'package:pizza_animation/services/size_config.dart';
import 'package:pizza_animation/utils/colors.dart';
import 'package:pizza_animation/utils/text_styles.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final int? selectedCard;
  const TopBar({
    Key? key,
    required this.selectedCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.toHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              child: Icon(
                Icons.chevron_left,
                size: 40.toFont,
                color: ColorConstants.Blue_Gray,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: 1,
                duration: Duration(milliseconds: 400),
                child: Text(
                  "Checkout",
                  style: CustomTextStyles.orderPizza(size: 30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
