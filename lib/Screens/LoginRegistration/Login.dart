import 'dart:convert';
import 'dart:ui';

import 'package:apanabazar/Bloc/LoginBloc.dart';
import 'package:apanabazar/Model/LoginModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Registration.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPassword.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/colors.dart';

class Login extends StatelessWidget {
  
  static String token,name,email,contactNo;
  static int userid;
  
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
      home: LoginRegistrationScreen(),     
    );
  }
}

class LoginRegistrationScreen extends StatefulWidget {
  
  @override
  _LoginRegistrationScreenState createState() => _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends State<LoginRegistrationScreen> {

  final style = TextStyle(fontSize: 50,fontWeight: FontWeight.w900);

  bool _visible=false; // for hiding widget

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Fetching Credentials..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  TextEditingController emailOrMobileController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _hidePassword = true;

  Future<LoginModel> loginProcess(String contact, String password) async {
    const login_url='https://api.apanabazar.com/api/login';
    final http.Response response = await http.post(
        Uri.parse(login_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: json.encode({
          'contact': contact,
          'password': password,
        }),
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
     
    if (response.statusCode == 200) {

      

    
      return LoginModel.fromJson(json.decode(response.body));
    } else {
       
     
      // Fluttertoast.showToast(
      //   msg: "Please Check Login Credentials",
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

      Future.delayed(const Duration(seconds: 5), () { //asynchronous delay
        if (this.mounted) { //checks if widget is still active and not disposed
          setState(() { //tells the widget builder to rebuild again because ui has updated
            _visible=true; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
          });
        }
      });
      super.initState();
      //BackButtonInterceptor.add(myInterceptor);
  }

  // @override
  // void dispose() {
  //   BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  // }

  

  @override
  Widget build(BuildContext context) {

    final bloc = Bloc();

    return Scaffold(
    
      body: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.only(left: 18,right: 18,top: 100),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("Welcome To Apana Bazar....",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500,color: themColor,fontFamily: 'Roboto'),),

                //Text("Log In",style: GoogleFonts.pacifico( textStyle: style),),
                Text("Log In",style: TextStyle( fontFamily: "AkayaKanadaka",fontSize: 50,color: Colors.black87),),

                SizedBox(
                  height: 40,
                ),

                Text("Email/Phone No",style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey),),

                SizedBox(
                  height: 10,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEFF3F6),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(6,2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0

                      ),
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        offset: Offset(-6,-2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0
                      )
                    ]
                  ),
                
                  child: StreamBuilder<String>(
                    stream: bloc.email,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.emailChanged,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailOrMobileController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: InputBorder.none,
                        //border: OutlineInputBorder(),
                        hintText: "Enter email or Mobile.No",
                        labelText: "Email or Mobile No.",
                        errorText: snapshot.error
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),


                Text("Password",style: TextStyle( fontSize: 18,fontWeight: FontWeight.w500,color: Colors.grey),),

                SizedBox(
                  height: 10,
                ),



                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEFF3F6),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        offset: Offset(6,2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0

                      ),
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        offset: Offset(-6,-2),
                        blurRadius: 6.0,
                        spreadRadius: 3.0
                      )
                    ]
                  ),
                
                  child: StreamBuilder<String>(
                    stream: bloc.password,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.passwordChanged,
                      keyboardType: TextInputType.text,
                      obscureText: _hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: InputBorder.none,
                        //border: OutlineInputBorder(),
                        hintText: "Enter password",
                        labelText: "Password",
                        errorText: snapshot.error,
                              
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                            icon: Icon(
                              _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                              size: 17.0)
                            )
                      ),
                    ),
                  ),
                ),

           



                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0,right: 10),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ForgotPassword()));
                      },
                      child: Text(
                        "Forgot Your Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontFamily: 'RaleWay',
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                                                  
                SizedBox(
                  height: 20.0,
                ),


                 
                Visibility(
                  maintainSize: true, 
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _visible, 
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/1.05,

                   

                    child: ElevatedButton.icon(
                      
                      style: ElevatedButton.styleFrom(
                        
                        primary: themColor,
                        onPrimary: Colors.white,
                        shadowColor: Colors.black54,
                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        elevation: 10,
                      ),
                      icon: Icon(Icons.login),
                      label: Text('Login', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                      onPressed:  
                      
                      () async{
                                
                       

                        try{
                          //showLoaderDialog(context); //showing loader
                          var response= await loginProcess(emailOrMobileController.text.toString(),passwordController.text.toString());
                          // bool res=response.status;
                              
                          var res=response.response;
                          Login.token=response.token;
                          Login.userid=response.user.id;
                          Login.name=response.user.name.toString();
                          Login.email=response.user.email.toString();
                          Login.contactNo=response.user.contact.toString();
                          
                          // print("got it employe");
                          // print(Login.token);
                          // print("user id");
                          // print(response.user.id);
                          // print(Login.name);
                          // print(Login.email);
                              
                          if(res==true){
                            
                          // Navigator.pop(context);  //hiding loader
                           // LoginNotification();
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs?.setBool("isLoggedIn", true);

                            final SharedPreferences oneTimeLoginPrefs = await SharedPreferences.getInstance();
                            oneTimeLoginPrefs.setString("oneTimeCredential1",emailOrMobileController.text.toString() );
                            oneTimeLoginPrefs.setString("oneTimeCredential2",passwordController.text.toString());
                            
                            SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                            loginPrefs.setString("token",Login.token.toString());
                            loginPrefs.setString("userid",Login.userid.toString());
                            loginPrefs.setString("email",Login.email.toString());
                            loginPrefs.setString("contactNo",Login.contactNo.toString());
                            loginPrefs.setString("name",Login.name.toString());

                            //generateToast("Login Successfully",themColor);
                              
                            Fluttertoast.showToast(
                              msg: "Login Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                              
                            
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                          }
                              
                          // else if(res==false){
                          //   Fluttertoast.showToast(
                          //     msg: "Check Credentials2",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.CENTER,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.green,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0
                          //   );
                          // }
                          // else{

                          //   // Fluttertoast.showToast(
                          //   //   msg: "Check Credentials2",
                          //   //   toastLength: Toast.LENGTH_SHORT,
                          //   //   gravity: ToastGravity.CENTER,
                          //   //   timeInSecForIosWeb: 1,
                          //   //   backgroundColor: Colors.green,
                          //   //   textColor: Colors.white,
                          //   //   fontSize: 16.0
                          //   // );
                              
                          // }
                        }
                        catch(err){
                          Fluttertoast.showToast(
                            msg: "Wrong Credentials",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                              
                        }
                      }
                       //: null,
                      
                      
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Registration()));
                        },
                        child: Text("Register Now",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      )
                    ],
                  ),
                ),
              
      
            ],
          ),
        ),
      )  
        
      
    );
  }

  void generateToast(String message, MaterialAccentColor color){

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
    );

  }
}

// void LoginNotification() async{
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 1,
//       channelKey: 'key1',
//       title: 'This is a notification',
//       body: "You have Successfully Logged in Apana Bazar",
//       bigPicture: "https://images.freeimages.com/images/large-previews/99f/green-tick-in-circle-1147519.jpg",
//       notificationLayout: NotificationLayout.BigPicture
//     )
//   );
// }