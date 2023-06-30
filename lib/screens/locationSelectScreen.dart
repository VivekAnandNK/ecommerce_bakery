import 'package:flutter/material.dart';
import 'package:maharani_bakery_app/data/data.dart';
import 'package:maharani_bakery_app/widgets/header_second.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/header.dart';
import '../widgets/header_third.dart';
import 'home_screen.dart';

class LocationSelectScreen extends StatefulWidget {
  static const String idScreen = "location";
  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  String _selectedLocation = 'Bagalkot';
  SharedPreferences? _prefs;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _initSharedPreferences();
  }

  // Future<void> _initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _selectedLocation = _prefs?.getString('selectedLocation') ?? '';
  //   });
  // }

  Future<void> _saveLocationToSharedPreferences(String location) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs?.setString('selectedLocation', location);
    locationName = _selectedLocation.toLowerCase();
    Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
  }


  Widget _buildLocationItem(String location) {
    final bool isSelected = location == _selectedLocation;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLocation = location;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                location.toUpperCase(),
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Candarai",
                ),
              ),
              Spacer(),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: Colors.black,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 150.0,),
              Text(
                'Select a Location',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Candarai"),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              _buildLocationItem('Ramdurg'),
              SizedBox(height: 10),
              _buildLocationItem('Mudhol'),
              SizedBox(height: 10),
              _buildLocationItem('Bagalkot'),
              SizedBox(height: 20),
              SizedBox(height: 20),


            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () async {
                    await _saveLocationToSharedPreferences(_selectedLocation);
                    Navigator.pushNamedAndRemoveUntil(context, Home.idScreen, (route) => false);
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Proceed',
                          style: TextStyle(
                            color: brandGold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward,
                          color: brandGold,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          HeaderThird(idScreen: "header", scaffoldKey: null,),

        ],
      ),
    );
  }
}
