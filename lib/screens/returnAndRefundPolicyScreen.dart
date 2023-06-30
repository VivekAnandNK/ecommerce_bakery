import 'package:flutter/material.dart';

import '../widgets/bottomWidget.dart';
import '../widgets/navigationBar.dart';

class ReturnRefundPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        'RETURN AND REFUND POLICY',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,

                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/1.png", height: 130,),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Thank you for shopping at our store. If you are not entirely satisfied with your purchase, we’re here to help.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Returns',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'At Maharani, we take pride in the quality and freshness of our baked goods. Due to the perishable nature of our products, we are unable to accept any returns or exchanges. We are committed to ensuring that our customers receive the freshest products possible, and as such, we cannot guarantee the safety or quality of any products that have been returned or exchanged. We appreciate your understanding in this matter and hope that you are completely satisfied with your purchase. If you have any questions or concerns, please do not hesitate to contact us.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Refunds',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.0),

                  Text(
                    'At Maharani, we are committed to providing our customers with the highest quality products and service. However, due to the perishable nature of our baked goods, we are unable to offer refunds on any products that have already been purchased. Once a purchase has been made, it is considered final and non-refundable. We apologize for any inconvenience this may cause, but we hope you understand that our products are made fresh and cannot be resold or reused once they have left our bakery. If you have any questions or concerns, please do not hesitate to contact us and we will do our best to address any issues you may have. Thank you for choosing Maharani], and we appreciate your business.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 100.0),

                ],


              ),
            ),
          ),
          NavigationsBar(idScreen: "privacy"),

        ],
      ),
    );
  }
}