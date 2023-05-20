import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/global/global_instance_or_variable.dart';
import 'package:foodfair_seller_app/screens/seller_menus_screen.dart';

import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      //in if now current user is registered and it is save lacallly with sharedPreferences
      if(firebaseAuth.currentUser != null){
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SellerMenusScreen()));
      }else{
           Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AuthScreen()));
      }
   
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

//error solve



  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("assets/images/splash.jpg"),
              ),

              const SizedBox(height: 10,),

              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Sell Food Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
