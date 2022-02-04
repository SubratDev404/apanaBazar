import 'dart:convert';

import 'package:apanabazar/Model/VerifyUserModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordScreen(),
      
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
 

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  bool _hideOTP = true;
  TextEditingController _otpController;
  final _formKey = GlobalKey<FormState>();

  Future<VerifyUserModel> loginProcess(String contact, String password) async {
    const login_url='https://apanabazar.com/Gateway/verify_user';
    final http.Response response = await http.post(
        Uri.parse(login_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: json.encode({
         
        }),
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
       return VerifyUserModel.fromJson(json.decode(response.body));
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
    _otpController = TextEditingController();
   
    }

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
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text('Change Your OTP here.....', style: TextStyle(color: themColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                        ),
                        
                                
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 20),
                          child: Container(
                           
                            child: TextFormField(
                              controller: _otpController,                
                              keyboardType: TextInputType.text,
                              obscureText: _hideOTP,
                              autofillHints: [AutofillHints.oneTimeCode],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is required';
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter OTP",
                                labelText: "OTP",
                                
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hideOTP = !_hideOTP;
                                    });
                                  },
                                  icon: Icon(
                                    _hideOTP
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                    size: 17.0
                                  )
                                )
                              )  
                              
                            ),
                          ),
                        ),

                        

                        ElevatedButton.icon(
                          icon: Icon(Icons.keyboard_arrow_right_outlined),
                          label: Text('Submot OTP', style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                          style: ElevatedButton.styleFrom(
                            primary: themColor,
                            onPrimary: Colors.white,
                            shadowColor: Colors.white60,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            elevation: 10,
                          ),
                          onPressed: () async{
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            
                            
                          }
                        ),

                        
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Hero(
                            tag: "hero",
                            child: Image.asset("assets/images/forgotpassword.jpg",width: MediaQuery.of(context).size.width,)
                          ),
                        ),
                        


                        
              
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