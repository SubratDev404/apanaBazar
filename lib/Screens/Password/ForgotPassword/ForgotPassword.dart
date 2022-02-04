import 'dart:convert';

import 'package:apanabazar/Model/VerifyUserModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/SuccessPage/VerifiedUser.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatelessWidget {
 
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
      home: ForgotPasswordScreen(),
      
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
 

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Sending OTP..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  
  TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<VerifyUserModel> veryfyUserProcess(String email) async {
    const login_url='https://apanabazar.com/Gateway/verify_user';
    final http.Response response = await http.post(
        Uri.parse(login_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          'userid': email,
         
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      setState(() {
        isLoading=false; 
      });

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
      // print(response.body);
       return VerifyUserModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");
    
      isLoading = false;
    
      // Fluttertoast.showToast(
      //   msg: "Please fill Up All Details",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

     // throw Exception('Failed to create album.');
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    _emailController = TextEditingController();
    //BackButtonInterceptor.add(myInterceptor);
  }
  
  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   _emailController.dispose();
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
                //     child: Text('Forgot Password ?', style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                //   )
                // ),
                
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 10),
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
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Text('Forgot Password?',overflow: TextOverflow.ellipsis,maxLines: 1, style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black54) ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Text('Enter the email address associated with your account.',overflow: TextOverflow.ellipsis,maxLines: 2 ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Text('We will email you a verification code to check your authenticity.',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black38,),),
                        ),
                                
                        Padding(
                          padding: EdgeInsets.only(left: 10,right: 10,bottom: 20, top: 20),
                          child: Container(
                           
                            child: TextFormField(
                              controller: _emailController,                
                              keyboardType: TextInputType.emailAddress,
                              
                              autofillHints: [AutofillHints.email],

                              validator: (val){
                                if(val.isEmpty){
                                  return "Email can't be empty";
                                }
                                else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                              // validator: (value) {
                              //   if (value.isEmpty || 
                              //     !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //     .hasMatch(value))  {
                              //     return 'This field is required';
                              //   }
                              // },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter Registered Email",
                                labelText: "Email",
                              )  
                              
                            ),
                          ),
                        ),

                        

                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.05,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.email),
                            label: Text('Verify Email', style: TextStyle(color:Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
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
                              else{
                                try{

                                  showLoaderDialog(context);

                                  isLoading=true;
                                  var  response= await veryfyUserProcess(_emailController.text.toString());
                                  bool res=response.status;
                                  if(res==true){
                                    Navigator.pop(context);
                                    isLoading=false;
                                    //print("Verified done");
                                  
                                    ForgotPassword.message=response.message;
                                    ForgotPassword.userid=response.userid;

                                    setState(() {
                                      ForgotPassword.email=_emailController.text.toString();
                              
                                    });

                                    // print("ForgotPassword");
                                    // print(ForgotPassword.email.toString());
                                    
                                  //   Fluttertoast.showToast(
                                  //   msg: ForgotPassword.message,
                                  //   toastLength: Toast.LENGTH_SHORT,
                                  //   gravity: ToastGravity.CENTER,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.red,
                                  //   textColor: Colors.white,
                                  //   fontSize: 16.0
                                  // );

                                  //   Fluttertoast.showToast(
                                  //   msg: ForgotPassword.email,
                                  //   toastLength: Toast.LENGTH_SHORT,
                                  //   gravity: ToastGravity.CENTER,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.red,
                                  //   textColor: Colors.white,
                                  //   fontSize: 16.0
                                  // );
                                  
                                    _emailController.clear();

                                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> VerifiedUser()));

                                  }
                                }
                                catch(err){
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
                              }  
                            
                            
                              
                              
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