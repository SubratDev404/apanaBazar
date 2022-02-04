

import 'package:apanabazar/Screens/SplashScreen/SplashScreen.dart';
import 'package:apanabazar/onboarding/NewOnBoarding/onboardingpage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';




int initScreen;

Future<void> main() async{
 
 //StatusBar Color start
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light
  ));
   //StatusBar Color end
  WidgetsFlutterBinding.ensureInitialized();
  // AwesomeNotifications().initialize(
  //   null, 
  //   [
  //     NotificationChannel(
  //       channelKey: 'key1',
  //       channelName: 'Apana Bazar',
  //       channelDescription: 'Apana Bazar Description',
  //       defaultColor: Color(0XFFdc173e),
  //       ledColor: Colors.white,
  //       enableLights: true,

  //     )
  //   ]
  // );
  SharedPreferences preferences=await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

   

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(


        primarySwatch: mycolor,
      ),

     

      initialRoute: initScreen==0 || initScreen==null ? 'onboard' : 'SplashScreen',

      routes: {
        'SplashScreen' : (context)=>Splash(),
        'onboard' : (context)=>OnboardingPage(),
      },

      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const MaterialColor mycolor = const MaterialColor(
    0XFFdc173e,
    const <int, Color>{
      50:  const Color(0xFFdc173e),
      100: const Color(0xFFdc173e),
      200: const Color(0xFFdc173e),
      300: const Color(0xFFdc173e),
      400: const Color(0xFFdc173e),
      500: const Color(0XFFdc173e),
      600: const Color(0xFFdc173e),
      700: const Color(0xFFdc173e),
      800: const Color(0xFFdc173e),
      900: const Color(0xFFdc173e),
    },
  );



