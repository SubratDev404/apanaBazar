import 'dart:convert';

import 'package:apanabazar/Model/VerifyUserModel.dart';
import 'package:apanabazar/Model/VeryfyOtpModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPassword.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPasswordChange.dart';
import 'package:apanabazar/Screens/SuccessPage/OtpVeried.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordOtpVerify extends StatelessWidget {

  static String forgotPasswordOtp;
 

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    return MaterialApp(

       builder: (context, child) {  // Preventing app text font size from Any device font size configuration
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordOtpVerifyScreen(),
      
    );
  }
}

class ForgotPasswordOtpVerifyScreen extends StatefulWidget {
 

  @override
  _ForgotPasswordOtpVerifyState createState() => _ForgotPasswordOtpVerifyState();
}

class _ForgotPasswordOtpVerifyState extends State<ForgotPasswordOtpVerifyScreen> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("OTP Verifying..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  bool _pinSuccess = false;
  bool _hideOTP = true;
  //TextEditingController _otpController;
  final _formKey = GlobalKey<FormState>();
  String otp;
  Future<VerifyOtpModel> veryfyOtpProcess(String otp) async {
    const verifyOtp_url='https://apanabazar.com/Gateway/verify_otp';
    final http.Response response = await http.post(
        Uri.parse(verifyOtp_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          'userid': ForgotPassword.userid.toString(),
          'otp': otp.toString()
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
      // print(response.body);
       return VerifyOtpModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

      Fluttertoast.showToast(
        msg: "Please fill Up All Details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

     // throw Exception('Failed to create album.');
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
     // BackButtonInterceptor.add(myInterceptor);
   // _otpController = TextEditingController();
    var string = ForgotPassword.userid.toString();

  }

  @override
  void dispose() {
   // _otpController.dispose();
   // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: themColor,
        title: Text('Back',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext appBarContext) {
            return IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
              },
              icon: Icon(Icons.arrow_back_ios,color: Colors.white,)
            );
          },
        ),
        
      ),

      body: 
        
        Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor,
              child: Container(
                
                // child: Align(
                //   alignment: Alignment.topRight,
                //   child: Padding(
                //     padding: EdgeInsets.only(right: 20),
                //     child: Text('Enter Otp here.....', style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                //   )
                // ),
                
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white
                ),
                
                
                child: SingleChildScrollView(
                   // reverse: true,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              SizedBox(height: 20,),

                              Text('Verification',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black54)),
                            
                              SizedBox(height: 10,),

                              Center(child: Text( 'Enter the verification code we just sent you  on your',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle( fontWeight: FontWeight.w700,color: Colors.black54))),
                               Center(child: Text('Email Address',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle( fontWeight: FontWeight.w700,color: Colors.black54,fontSize: 20))),
                              SizedBox(height: 20,),

                              OTPTextField(
                                
                                length: 6,
                                width: 320,
                                fieldWidth: 40,
                                style: TextStyle(fontSize: 30),
                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                onChanged: (pin){
                                  setState(() {
                                   otp=pin;
                                    
                                  });

                                },
                                onCompleted: (pin) {
                                  setState(() {
                                    
                                    otp=pin;
                                    _pinSuccess = true;
                                  });
                                },
                              ),

                                      
                            // Text.rich(
                            //   TextSpan(
                            //     children: [
                            //       TextSpan(
                            //         text: "If you didn't receive a code! ",
                            //         style: TextStyle(
                            //           color: Colors.black38,
                            //         ),
                            //       ),
                        
                            //     ],
                            //   ),
                            // ),
                              
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      
                            
                                
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10,right: 10,bottom: 20, top: 100),
                        //   child: Container(
                           
                        //     child: TextFormField(
                        //       controller: _otpController,  
                        //       obscureText: _hideOTP,
                        //      // autofillHints: [AutofillHints.oneTimeCode],              
                        //       keyboardType: TextInputType.number,
                              
                           
                        //       validator: (value) {
                        //         if (value.isEmpty) {
                        //           return 'This field is required';
                        //         }
                        //       },
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         hintText: "Enter OTP",
                        //         labelText: "OTP",
                        //         suffixIcon: IconButton(
                        //           onPressed: () {
                        //             setState(() {
                        //               _hideOTP = !_hideOTP;
                        //             });
                        //           },
                        //           icon: Icon(
                        //             _hideOTP
                        //             ? Icons.visibility_off
                        //             : Icons.visibility,
                        //             size: 17.0
                        //           )
                        //         )
                        //       )  
                              
                        //     ),
                        //   ),
                        // ),

                        

                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.05,
                          child: Container(
                            
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.email),
                              label: Text('Verify OTP', style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                              style: ElevatedButton.styleFrom(
                                
                                primary: themColor,
                                onPrimary: Colors.white,
                                shadowColor: Colors.white60,
                                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                elevation: 10,
                              ),
                              onPressed: _pinSuccess==true ?
                              () async{
                                // if (!_formKey.currentState.validate()) {
                                 
                                //   return;
                                // }
                               // else{
                                  try{

                                    //showLoaderDialog(context);
                                    var response= await veryfyOtpProcess(otp.toString());
                                    bool res=response.status;
                                    if(res==true){
                                     // Navigator.pop(context);
                                     // print("Verified otp done");
                                      ForgotPasswordOtpVerify.forgotPasswordOtp=otp.toString();

                                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>OtpVerified()));
                                      //_otpController.clear();
                                    }
                                  }
                                  catch(err){

                                    //Navigator.pop(context);
                                    Fluttertoast.showToast(
                                      msg: "Check Credentials",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                    );
                                                    
                                  } 
                               // }  
                              
                                
                                
                              } : null
                            ),
                          ),
                        ),

                        
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //  // child: Hero(
                        //   //  tag: "hero",
                        //     child: Image.asset("assets/images/forgotpassword.jpg",width: MediaQuery.of(context).size.width)
                        //  // ),
                        // ),
                        


                        
              
                      ],
                    ),
                  ),
                ),
                
              
            ),
          ]  
        ),
      
      
    );
  }
}