import 'dart:convert';

import 'package:apanabazar/Model/ForgotChangePasswordModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPassword.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPasswordOtpVerify.dart';
import 'package:apanabazar/Screens/SuccessPage/PasswordChangeSuccessfully.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordChange extends StatelessWidget {
 
  static String message,userid,email;

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
      home: ForgotPasswordChangeScreen(),
      
    );
  }
}

class ForgotPasswordChangeScreen extends StatefulWidget {
 

  @override
  _ForgotPasswordChangeScreenState createState() => _ForgotPasswordChangeScreenState();
}

class _ForgotPasswordChangeScreenState extends State<ForgotPasswordChangeScreen> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Updating Password..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  bool _hideNewPasword = true;
  bool _hideNewConfirmPassword = true;

  TextEditingController _newPasswordController;
  TextEditingController _newPasswordConfirmController;
  final _formKey = GlobalKey<FormState>();

  Future<ForgotChangePasswordModel> forgotChanePassworProcess(String password) async {
    const resetPassword_url='https://apanabazar.com/Gateway/password_reset';
    final http.Response response = await http.post(
        Uri.parse(resetPassword_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          'userid': ForgotPassword.userid.toString(),
          'otp': ForgotPasswordOtpVerify.forgotPasswordOtp.toString(),
          'password': _newPasswordConfirmController.text.toString()
         
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
      return ForgotChangePasswordModel.fromJson(json.decode(response.body));
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
    _newPasswordController = TextEditingController();
    _newPasswordConfirmController = TextEditingController();
   // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
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

      body: Form(
        key: _formKey,
        child: Stack(
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
                //     child: Text('Please Change password here.....', style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Change Password',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black54)),
                            
                        SizedBox(height: 10,),

                        Center(child: Text('Enter Your',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle( fontWeight: FontWeight.w700,color: Colors.black54))),
                        Center(child: Text('New Password',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle( fontWeight: FontWeight.w700,color: Colors.black54,fontSize: 20))),
                        SizedBox(height: 20,),

                                
                        // Padding(
                        //   padding: EdgeInsets.only(left: 10,right: 10,bottom: 20, top: 100),
                        //   child: Container(
                           
                        //     child: TextFormField(
                        //       controller: _newPasswordController,                
                        //       keyboardType: TextInputType.text,
                        //       autofillHints: [AutofillHints.name],
                        //       obscureText: _hideNewPasword,
                        //       validator: (value) {
                        //         if (value.isEmpty) {
                        //           return 'Password is required';
                        //         }
                        //       },
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         hintText: "Enter new Password",
                        //         labelText: "New Password",
                        //         suffixIcon: IconButton(
                        //           onPressed: () {
                        //             setState(() {
                        //               _hideNewPasword = !_hideNewPasword;
                        //             });
                        //           },
                        //           icon: Icon(
                        //             _hideNewPasword
                        //             ? Icons.visibility_off
                        //             : Icons.visibility,
                        //             size: 17.0
                        //           )
                        //         )
                        //       )  
                        //     )  
                              
                        //   ),
                          
                        // ),

                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 20, top: 20),
                          child: Container(
                           
                            child: TextFormField(
                              controller: _newPasswordConfirmController,                
                              keyboardType: TextInputType.text,
                              autofillHints: [AutofillHints.name],
                              obscureText: _hideNewConfirmPassword,
                              validator: (value) {
                                if (value.isEmpty ) {
                                  return 'New Password is required';
                                }

                                if(_newPasswordController.text.toString() !=_newPasswordConfirmController.toString()){
                                  return 'Password Miss Match';
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter New Password",
                                labelText: "New Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hideNewConfirmPassword = !_hideNewConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _hideNewConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                    size: 17.0
                                  )
                                )
                              )  
                              
                            ),
                          ),
                        ),

                        

                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.05,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.security),
                            label: Text('Submit New Password', style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                            style: ElevatedButton.styleFrom(
                              
                              primary: themColor,
                              onPrimary: Colors.white,
                              shadowColor: Colors.white60,
                              shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              elevation: 10,
                            ),
                            onPressed: () async{
                              // if (!_formKey.currentState.validate()) {
                               
                              //   return;
                              // }
                              // else{
                               
                                try{
                                  //CircularProgressIndicator();
                                  showLoaderDialog(context);
                                  var response= await forgotChanePassworProcess(_newPasswordConfirmController.text.toString());
                                  bool res=response.status;
                                  if(res==true){
                                  
                                    Navigator.pop(context);
                                    //print("Password Change done");
                                    //ForgotPasswordOtpVerify.forgotPasswordOtp=_otpController.text.toString();

                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>PasswordChangeSuccessfully()));
                                    //_otpController.clear();
                                  }
                                }
                                catch(err){
                                  Navigator.pop(context);
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
                           
                            
                              
                              
                            }
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
      ),
      
    );
  }
}