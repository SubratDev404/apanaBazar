import 'dart:convert';
import 'package:apanabazar/Bloc/RegistrationBloc.dart';
import 'package:apanabazar/Model/RegistrationModel.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Registration extends StatelessWidget {
  
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
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Registering..." )),
        ],),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  bool _hidePassword = true;

  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  Future<RegistrationModel> registrationProcess() async {
    const login_url='https://api.apanabazar.com/api/register';
    final http.Response response = await http.post(
        Uri.parse(login_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: json.encode({
          'name': nameController.text.toString(),
          'contact': mobileController.text.toString(),
          'email': emailController.text.toString(),
          'password': passwordController.text.toString(),
          'password_confirmation': confirmPasswordController.text.toString()

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
       return RegistrationModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

      // Fluttertoast.showToast(
      //   msg: "Check Credentials",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
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
   // BackButtonInterceptor.add(myInterceptor);
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
  

  @override
  Widget build(BuildContext context) {
    
    final bloc = Bloc();

    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Registration',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w900),),
        elevation: 0,
        leading: Builder(
        builder: (BuildContext appBarContext) {
          return IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
              },
              icon: Icon(Icons.arrow_back_ios,color: themColor,)
          );
        },
      ),
        
      ),

      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(

            child: Column(
              children: [

                Container(
                  child: Column(
                    children: [
                      Hero(
                        tag: "hero",
                        child: Image.asset("assets/images/splash_screen_hero.png",width: 200,height: 100,)
                      )
                    ]
                  )    
                ),

                SizedBox(
                  height: 20,
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
                    stream: bloc.name,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.nameChanged,
                      keyboardType: TextInputType.name,
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        //border: OutlineInputBorder(),
                        border: InputBorder.none,
                        hintText: "Enter Name",
                        labelText: "Name",
                        errorText: snapshot.error
                      ),
                    ),
                  ),
                ),
                

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
                    stream: bloc.mobile,
                    builder: (context, snapshot) => TextField(
                      maxLength: 10,
                      maxLengthEnforced: true,
                      onChanged: bloc.mobileChanged,
                      keyboardType: TextInputType.phone,
                      controller: mobileController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        //border: OutlineInputBorder(),
                        border: InputBorder.none,
                        //border: OutlineInputBorder(),
                        hintText: "Mobile.No",
                        labelText: "Mobile No.",
                        errorText: snapshot.error
                      ),
                    ),
                  ),
                ),
                

                SizedBox(
                  height: 20,
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
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: InputBorder.none,
                        //border: OutlineInputBorder(),
                        hintText: "Enter email",
                        labelText: "Email",
                        errorText: snapshot.error
                      ),
                    ),
                  ),
                ),
                

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
                        hintText: "Enter assword",
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
                    stream: bloc.confirmPassword,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.confirmPasswordChanged,
                      keyboardType: TextInputType.text,
                      obscureText: _hidePassword,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: InputBorder.none,
                        hintText: "Enter Confirm Password",
                        labelText: "Confirm Password",
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
                            size: 17.0,
                          )
                        )
                      ),
                    ),
                  ),
                ),
                

                SizedBox(
                  height: 10,
                ),


                SizedBox(
                  width: MediaQuery.of(context).size.width/1.2,

                  child: ElevatedButton.icon(
                  
                    style: ElevatedButton.styleFrom(
                      primary: themColor,
                      onPrimary: Colors.white,
                      shadowColor: Colors.black54,
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      elevation: 10,
                    ),
                    icon: Icon(Icons.app_registration),
                    label: Text('Registration', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                    onPressed: 

                      // snapshot.hasData
                      //   ? 
                        () async{

                          try{

                            showLoaderDialog(context); //showing loader
                            var response=await registrationProcess();
                            var resToken=response.token.toString();
                            if(resToken!=""){
                              Navigator.pop(context);  //hide loader
                              Fluttertoast.showToast(
                                msg: "Registration Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );

                              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Login()));

                            }
                            else{}

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
                        },
                      // : null,
                      //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>AddressList()));
                    
                  ),
                ),

                SizedBox(
                  height: 20,
                ),


                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already Registered?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        child: Text("Login Now",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      )
                    ],
                  ),
                )


              ],
            )

          ),
        ),
      ),
      
    );
  }
}
