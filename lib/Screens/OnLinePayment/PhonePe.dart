import 'dart:convert';
import 'package:apanabazar/Model/Base64JsonEncode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';

class PhonePe extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhonePeScreen()
    );
  }
}

class PhonePeScreen extends StatefulWidget {


  @override
  _PhonePeScreenState createState() => _PhonePeScreenState();
}

class _PhonePeScreenState extends State<PhonePeScreen> {

  static const platform = const MethodChannel('flutter.native/helper');
  String _responseFromNativeCode = 'Waiting for Response...';
  Future<void> responseFromNativeCode() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });
  }

  void startPaymentTransaction() async {
    var data = < String,
        dynamic > {
      // "base64Body": "ewogICAibWVyY2hhbnRJZCI6IlNJVEFOU0hVVUFUIiwKICAgInRyYW5zYWN0aW9uSWQiOiJUWDEyMzQ1Njc4OTU0MzIiLAogICAiYW1vdW50IjoxMDAsCiAgICJtZXJjaGFudE9yZGVySWQiOiJPRDEyMzQiCn0=",
      "base64Body": "ewogICAgIm1lcmNoYW50SWQiOiAiVUFUTUVSQ0hBTlQiLAogICAgInRyYW5zYWN0aW9uSWQiOiAiVFgxMjM0NTY3ODkwIiwKICAgICJhbW91bnQiOiAxLAogICAgIm1lcmNoYW50T3JkZXJJZCI6ICJPRDEyMzQiLAp9",
      //"base64Body": "ewogICAgIm1lcmNoYW50SWQiOiAiVUFUTUVSQ0hBTlQiLAogICAgInRyYW5zYWN0aW9uSWQiOiAiVFgxMjM0NTY3ODcwIiwKICAgICJhbW91bnQiOiAxLAogICAgIm1lcmNoYW50T3JkZXJJZCI6ICJPRDEyNjQiLAp9",
      "checksum": "7fd77b77c1f60ff0131ade1e9a7c1ac4e612fc4f2707101d046d4e67b14effed###1",
      "apiEndPoint": "/v4/debit",
      "x-callback-url": ""
    };
    String uiCallbackValue;
    try {
      uiCallbackValue = await platform.invokeMethod("startPaymentTransaction", data);

    } catch (e) {
      print(e);
    }
    print(uiCallbackValue);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseFromNativeCode();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            RaisedButton(
              child: Text('Call Native Method'),
              onPressed: (){

                var bytes = utf8.encode("sitanshu"); // data being hashed
                var digest = sha256.convert(bytes);
                print("Digest as hex string: $digest");


                var encoded1 = base64.encode(utf8.encode('I like dogs'));
                print('Encoded 1: $encoded1');


                // User user = User('bezkoder', 21);
                // String jsonUser = jsonEncode(user);
                // print("<<<<<<<<<<<<<<<<<<<Base 64 encode/////////////////////////////");
                // print(jsonUser);

              },
            ),
            Text(_responseFromNativeCode),

            RaisedButton(
                child: Text('Start Transction'),
                onPressed: () {
                  // currentDate();
                  // randomNumberGeneration();
                  startPaymentTransaction();
                }
            ),

          ],
        )
      ),

    );
  }
}
