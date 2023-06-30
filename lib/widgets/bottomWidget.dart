import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maharani_bakery_app/screens/returnAndRefundPolicyScreen.dart';
import 'package:maharani_bakery_app/screens/termsAndConditionsScreen.dart';
import 'package:maharani_bakery_app/widgets/Divider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../screens/privacyPolicyScreen.dart';



class BottomWidget extends StatelessWidget {
  BottomWidget({Key? key}) : super(key: key);


  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch');
    }
  }

  _makePhoneCall(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      displayToastMessage("Cant make the phone call.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        DividerWidget(),
        SizedBox(height: 20.0),

        !deliveryDetails["homeDelivery"] ? Column(
          children: [
            Text(
              '- No home delivery available today',
              style: TextStyle(
                  letterSpacing: 2.0, color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ) : Text(
          '** Home delivery available today **',
          style: TextStyle(
              letterSpacing: 2.0, color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 50.0),
        Container(
          color: Colors.black,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("assets/images/1.png", height: 130,),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("About Us",
              style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: "Candarai"
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Maharani Bakery is one of only a handful few enduring Craft Bakeries in Karnataka. We have assembled our notoriety on consolidating great quality conventional heating with great incentive for cash."
                  "We offer our clients a full scope of breads, forte breads, morning merchandise, cakes and baked goods."
                  "Our bread is heated day by day at our pastry shop and is conveyed to all our shops. We utilize profoundly gifted specialty dough punchers to guarantee each portion of bread is flawless without fail."
                  "Our pastry specialists work during that time with the goal that the portion of bread you purchase toward the beginning of the day is crisp out of the stove",
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Candarai"
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30.0,),
              animateWithFade(
                  'item.6',
                  Text("Our Guarantees",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Candarai"
                    ),
                  ),
                  400
              ),
              SizedBox(height: 20.0,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        animateWithSlide(
                            'item.2',
                            Image.asset("assets/images/ribbon.png",
                              height: 70.0,
                            ),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),

                        SizedBox(height: 30.0,),
                        animateWithSlide(
                            'item.3',
                            Image.asset("assets/images/delivery.png",
                              height: 40.0,
                            ),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),

                        SizedBox(height: 30.0,),

                        animateWithSlide(
                            'item.4',
                            Image.asset("assets/images/time.png",
                              height: 50.0,
                            ),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Quality\n",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text("You Can Trust",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai"
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.0,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Affordable\n",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text("Delivery",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai"
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("On Time\n",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text("Guarantee",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: "Candarai"
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.0,),

              animateWithFade(
                  "item.1",
                  Text("Contact Us",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: "Candarai"
                    ),
                  ),
                  400
              ),

              SizedBox(height: 10.0,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        animateWithSlide(
                            "item.10",
                            Icon(Icons.location_on, size: 30.0,),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 20.0,),
                        animateWithSlide(
                            "item.11",
                            Text("Our Office Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Candarai",
                                fontSize: 20.0,
                              ),
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 10.0,),
                        animateWithSlide(
                            "item.12",
                            Text("Maharani Bakery, Ramadurga, Karnataka 577536, India",
                              style: TextStyle(
                                fontFamily: "Candarai",
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),

                      ],
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        animateWithSlide(
                            "item.13",
                            Icon(Icons.email_outlined, size: 30.0,),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 20.0,),
                        animateWithSlide(
                            "item.14",
                            Text("General Enquiries",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Candarai",
                                fontSize: 20.0,
                              ),
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 10.0,),
                        animateWithSlide(
                            "item.15",
                            Text("$locationName@maharanibakery.com",
                              style: TextStyle(
                                fontFamily: "Candarai",
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        animateWithSlide(
                            "item.16",
                            Icon(Icons.phone_in_talk_sharp, size: 30.0,),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 20.0,),
                        animateWithSlide(
                            "item.17",
                            Text("Call Us",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Candarai",
                                fontSize: 20.0,
                              ),
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 10.0,),
                        animateWithSlide(
                            "item.18",
                            Text("+91 ${phoneNumber[locationName].replaceAll("+91", "").trim()}",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        animateWithSlide(
                            "item.19",
                            Icon(Icons.timer, size: 30.0,),
                            400,
                            Offset(-1.5, 0.0),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 20.0,),
                        animateWithSlide(
                            "item.20",
                            Text("Our Timings",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Candarai",
                                fontSize: 20.0,
                              ),
                            ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                        SizedBox(height: 10.0,),
                        animateWithSlide(
                            "item.21",
                            Text("${deliveryDetails["deliveryTime"].split(",")[0].split(":")[0]} - ${deliveryDetails["deliveryTime"].split(",")[0].split(":")[1]}: ${deliveryDetails["deliveryTime"].split(",")[1].split("-")[0]} - ${deliveryDetails["deliveryTime"].split(",")[1].split("-")[1]}",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Text("Mon - Sun: 10:00 AM - 09:00 PM",
                            //   style: TextStyle(
                            //     fontSize: 15.0,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            400,
                            Offset(0.0, 1.5),
                            Offset(0.0, 0.0)
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.0,),
              Stack(
                children: [
                  Image.asset("assets/images/location_${locationName}.png"),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //       onPressed: (){
                  //
                  //         // _launchUrl(Uri.parse("https://goo.gl/maps/Zww8zDkrpNZquZ2W6"), context);
                  //       },
                  //       child: SizedBox(
                  //         width: 115.0,
                  //         child: Row(
                  //           children: [
                  //             Text("Get Directions"),
                  //             Icon(Icons.directions)
                  //           ],
                  //         ),
                  //       )
                  //   ),
                  // ),
                ],
              ),


              SizedBox(height: 30.0,),


            ],


          ),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Center(
                child: Text("Useful Links",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Candarai"
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PrivacyPolicyPage())
                        );


                      },
                      child: Text("PRIVACY POLICY")
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ReturnRefundPolicyPage())
                        );
                      },
                      child: Text("RETURN AND REFUND POLICY")
                  ),
                ],
              ),
              SizedBox(height: 10.0,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TermsAndConditionsPage())
                        );
                      },
                      child: Text("TERMS AND CONDITIONS")
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Center(
                child: Text("Contact",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Candarai"
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text("Maharani Bakery, Ramadurga, Karnataka 577536, India",
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("+91 ${phoneNumber[locationName].replaceAll("+91", "").trim()}"),
                ],
              ),
              SizedBox(height: 5.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$locationName@maharanibakery.com"),
                ],
              ),
              SizedBox(height: 30.0,),
              Center(
                child: Text("Connect",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Candarai"
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async{
                        await _makePhoneCall("tel:$phoneNumber", context);
                      },
                      child: Icon(Icons.call, size: 40.0, color: Colors.blue,)
                  ),
                  SizedBox(width: 10.0,),
                  GestureDetector(
                    onTap: () async{
                      await _launchUrl(Uri.parse("whatsapp://send?phone==$phoneNumber"), context);
                    },
                    child: Image.asset("assets/images/whatsapp.png",
                      height: 40.0,
                    ),
                  ),

                ],
              ),
              SizedBox(height: 30.0,),
              Center(
                child: Text("Payments",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Candarai"
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/amex.png", height: 65.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/mastercard.png", height: 30.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/visa.jpg", height: 30.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/rupay.png", height: 30.0,),
                      SizedBox(width: 10.0,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/net.png", height: 30.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/emi.png", height: 30.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/cod.jpg", height: 50.0,),
                      SizedBox(width: 10.0,),
                      Image.asset("assets/images/paytm.png", height: 30.0,),
                      SizedBox(width: 10.0,),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/paypal.jpg", height: 40.0,),
                      SizedBox(width: 10.0,),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),

        DividerWidget(),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Copyrights ${int.parse(DateTime.now().toString().split("-")[0])}-${int.parse(DateTime.now().toString().split("-")[0]) + 1} Maharani Bakery.\nAll Rights Reserved.",
            textAlign: TextAlign.center,
          ),
        ),

      ],
    );
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }

  Widget animateWithSlide(String key, Widget childWidget, int milliSeconds, Offset beginOffset, Offset endOffset){
    return AnimateIfVisible(
      key: Key(key),
      duration: Duration(milliseconds: milliSeconds),
      builder: (
          BuildContext context,
          Animation<double> animation,
          ) =>
          SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: endOffset,
            ).animate(animation),
            child: childWidget,
          ),
    );
  }

  Widget animateWithFade(String key, Widget childWidget, int milliSeconds){
    return AnimateIfVisible(
      key: Key(key),
      duration: Duration(milliseconds: milliSeconds),
      builder: (
          BuildContext context,
          Animation<double> animation,
          ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: childWidget,
          ),
    );
  }


}
