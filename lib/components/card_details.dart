import 'package:pizza_animation/components/cutlery.dart';
import 'package:pizza_animation/components/deliver_price.dart';
import 'package:pizza_animation/components/order_list.dart';
import 'package:pizza_animation/components/pay_now.dart';
import 'package:pizza_animation/services/size_config.dart';
import 'package:pizza_animation/utils/text_styles.dart';
import 'package:pizza_animation/view_models/ingridients_view_model.dart';
import 'package:pizza_animation/view_models/pizza_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatelessWidget {
  final Animation<double> spendContainerOpacity;
  final int? selectedCard;
  final Function onPayNow;
  const CardDetails({
    Key? key,
    required this.spendContainerOpacity,
    this.selectedCard,
    required this.onPayNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pizzaViewModel = context.watch<PizzaViewModel>();
    final ingridientsViewModel = context.watch<IngridientsViewModel>();

    return Expanded(
      child: FadeTransition(
        opacity: spendContainerOpacity,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 20.toWidth,
            right: 20.toWidth,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Delivery Time
                      Text(
                        "We will deliver in\n24 minutes to this address:",
                        style: CustomTextStyles.delivery(),
                      ),
                      SizedBox(height: 15.toHeight),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Atlanta shopping mall, Surat",
                            style: CustomTextStyles.delivery(size: 14.toFont),
                          ),
                          SizedBox(width: 10.toWidth),
                          Text(
                            "Change Address",
                            style: CustomTextStyles.changeAddress(),
                          ),
                        ],
                      ),

                      /// Pizza Order List
                      SizedBox(height: 15.toHeight),
                      Divider(color: Colors.black.withOpacity(0.2)),
                      OrderList(
                        pizzaViewModel: pizzaViewModel,
                        ingridientsViewModel: ingridientsViewModel,
                      ),
                      SizedBox(height: 5.toHeight),
                      Divider(color: Colors.black.withOpacity(0.2)),

                      /// Cutlery Count
                      Cutlery(),
                      Divider(color: Colors.black.withOpacity(0.2)),
                      SizedBox(height: 10.toHeight),

                      /// Delivery Price
                      DeliveryPrice(),
                      SizedBox(height: 20.toHeight),
                    ],
                  ),
                ),
              ),

              /// Pay Now widget
              GestureDetector(
                onTap: () => onPayNow(),
                child: PayNowWidget(
                  selectedCard: selectedCard,
                  pizzaViewModel: pizzaViewModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
