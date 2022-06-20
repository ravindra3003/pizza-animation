import 'package:pizza_animation/services/size_config.dart';
import 'package:pizza_animation/utils/colors.dart';
import 'package:pizza_animation/utils/text_styles.dart';
import 'package:pizza_animation/view_models/pizza_view_model.dart';
import 'package:flutter/material.dart';

class PayNowWidget extends StatelessWidget {
  const PayNowWidget({
    Key? key,
    required this.selectedCard,
    required this.pizzaViewModel,
  }) : super(key: key);

  final int? selectedCard;
  final PizzaViewModel pizzaViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.toHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorConstants.Blue_Gray,
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Text(
            "Pay Now",
            style: CustomTextStyles.commonMontserrat(
              fontWeight: FontWeight.bold,
              size: 18,
              color: Colors.white,
            ),
          ),
          Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "24 min ",
                  style: CustomTextStyles.commonMontserrat(
                    fontWeight: FontWeight.bold,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text:
                      "• \₹${pizzaViewModel.pizzaPrice.toInt().toString()}.00",
                  style: CustomTextStyles.commonMontserrat(
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 20.toWidth),
        ],
      ),
    );
  }
}
