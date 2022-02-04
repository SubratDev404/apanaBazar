import 'dart:async';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInCart/NoItemInCart.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Splash extends StatelessWidget {
  
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
      home: SplashScreen(),
      
    );
  }
}

class SplashScreen extends StatefulWidget {

  
  

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

 
//String finalemail;
class _SplashScreenState extends State<SplashScreen> {

  // static const platform = const MethodChannel("phonepe");

  //  void shouldShow() async{
  //   String isPhonePeAvailable;
  //   try{
  //       isPhonePeAvailable = await platform.invokeMethod("shouldShow");
  //   }catch(e){
  //       print(e);
  //   }
  //   print("PHONE PE /////////////////////////////////"+isPhonePeAvailable);

  //    Fluttertoast.showToast(
  //       msg: "Phone Pe",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //     );
  // }
  
  // var data = <String, dynamic> {
  //   "base64Body" : "",
  //   "checksum" : "",
  //   "apiEndPoint" : "",
  //   "x-callback-url" : ""
  // };

  @override
  void initState() {

    super.initState();


    //BackButtonInterceptor.add(myInterceptor);
   // shouldShow();
    startTimer();
     
    //Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login())));

    //getValidationData().whenComplete(() async{

  

    //   Timer(Duration(seconds: 4),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>(
      
    //     finalemail==null ? Login() : CurvedBottomNavigationBar()))));
      

    // });
  }

  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   Fluttertoast.showToast(
  //     msg: 'Sorry can not back here',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: themColor
  //   );
  //   //print("BACK BUTTON!"); // Do some stuff.
  //   return true;
  // }



  // Future getValidationData() async{
  //   final SharedPreferences oneTimeLoginPrefs = await SharedPreferences.getInstance();
  //   var obtainCredential1=oneTimeLoginPrefs.getString('oneTimeCredential1');
  //   setState(() {
  //     finalemail=obtainCredential1;
  //   });
  //   print(finalemail);
  // }



  void startTimer() {
    Timer(Duration(seconds: 2), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences loginPrefs = await SharedPreferences.getInstance();
    Splash.userToken=loginPrefs.getString("token");
    Splash.userUserid=loginPrefs.getString("userid");
    Splash.userEmail=loginPrefs.getString("email");
    Splash.userContactNo=loginPrefs.getString("contactNo");
    Splash.userName=loginPrefs.getString("name");

    var status = prefs.getBool('isLoggedIn') ?? false;
    //print(status);
    if (status) {
     // Navigation.pushReplacement(context, "/Home");
      //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
      Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text('Welcome To ...........',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:themColor,fontFamily: 'Lobster'),) , 
                 SizedBox(height: 2,),
                 Hero(
                   tag: "hero",
                   child: Image.asset("assets/images/splash_screen.png")),
                  SizedBox(height: 2,),
               // Text('MK Classes',textAlign: TextAlign.center, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:themColor,fontFamily: 'Lobster'),) , 
                  

              ],
            ),
          ),

        ),
      
      
    );
  }
}