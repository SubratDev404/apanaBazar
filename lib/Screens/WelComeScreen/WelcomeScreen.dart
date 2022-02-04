import 'dart:async';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



class WelcomeScreen extends StatelessWidget {

  static String userToken,userUserid,userEmail,userName,userContactNo;
  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreenHome(),
    );
  }
}

class WelcomeScreenHome extends StatefulWidget {
  @override
  _WelcomeScreenHomeState createState() => _WelcomeScreenHomeState();
}

class _WelcomeScreenHomeState extends State<WelcomeScreenHome> {


  
  // var data = <String, dynamic> {
  //   "base64Body" : "",
  //   "checksum" : "",
  //   "apiEndPoint" : "",
  //   "x-callback-url" : ""
  // };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    
    startTimer();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Fluttertoast.showToast(
      msg: 'Sorry can not back here',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themColor
    );
    //print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  
  void startTimer() {
    Timer(Duration(seconds: 2), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    setState(() {
      WelcomeScreen.userToken=loginPrefs.getString("token");
      WelcomeScreen.userUserid=loginPrefs.getString("userid");
      WelcomeScreen.userEmail=loginPrefs.getString("email");
      WelcomeScreen.userContactNo=loginPrefs.getString("contactNo");
      WelcomeScreen.userName=loginPrefs.getString("name");
    });
   

    var status = prefs.getBool('isLoggedIn') ?? false;
   // print(status);
    if (status) {

    //  print("User id ///////////////////////////////////////////////////////"+WelcomeScreen.userUserid);
     // Navigation.pushReplacement(context, "/Home");
      //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CurvedBottomNavigationBar()));
    } else {
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
    //  Navigation.pushReplacement(context, "/Login");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset("assets/images/welcome_icon.gif"),
        ),
      ),
    );
  }
}