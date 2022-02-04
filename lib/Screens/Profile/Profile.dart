import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/ProfileModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/Password/ForgotPassword/ForgotPassword.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
 
  final String url= "https://api.apanabazar.com/api/profile/"+WelcomeScreen.userUserid;

  Future<ProfileModel> getPost() async {
    var response = await http.get(Uri.parse(url),

      headers:<String, String>
      {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      //print(body);
      return ProfileModel.fromJson(body);
    }
  }
}



class Profile extends StatelessWidget {
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
     home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final HttpService http = HttpService();

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //BackButtonInterceptor.add(myInterceptor);
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
    return Scaffold(
      backgroundColor: themColor,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
       // title: Center(child: Text('Profile',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
          },
        ),
      ),
     
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),
     
      body: 
      Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                themColor,
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Icon(
                      //   Icons.keyboard_arrow_left,
                      //   color: Colors.white,
                      // ),
                      
                      
                      InkWell(
                        onTap: (){
                          exit(0);
                        },
                        child: Row(
                          children: [
                            Text("Exit",style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'RobotoMono',fontWeight: FontWeight.w900)),
                            SizedBox(width: 4,),
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                          ]  
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: <Widget>[
                        // Stroked text as border.
                      Text(
                        'My Profile',textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = Colors.brown,
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 400,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.red[600],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Container(  
               
                                      padding: new EdgeInsets.only(top: 10,),  
                                      child: Card(  
                                        shape: RoundedRectangleBorder(  
                                          borderRadius: BorderRadius.circular(15.0),  
                                        ),  
                                        color: Colors.white,  
                                        elevation: 0,  
                                        child: FutureBuilder<ProfileModel>(
                                          future: http.getPost(),
                                          builder:(BuildContext context,AsyncSnapshot<ProfileModel> snapshot){

                                            if (snapshot.hasData) {
                                              ProfileModel profileModel = snapshot.data;
                                              return ListView(
                                                //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8, mainAxisSpacing: 4),
                                                padding: EdgeInsets.all(1),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  ListTile(
                                                    title: Column(
                                                      children: [

                                                        // ClipOval(
                                                        //   child: Image.network(profileModel.data.photo,width: 150,height: 250,)
                                                        // ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              //Text("Name: ",style: TextStyle(color: Colors.black45,fontSize: 18,fontFamily: 'Nisebuschgardens')),
                                                              Text(profileModel.data.name,style: TextStyle(color: Colors.black54,fontSize: 30,fontFamily: 'RaleWay',fontWeight: FontWeight.w700),),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Email: ",style: TextStyle(color: Colors.black45,fontSize: 18,fontFamily: 'RaleWay',fontWeight: FontWeight.w700)),
                                                              // Container(
                                                              //   height: 20,  //// stick height
                                                              //   width: 3,
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius:
                                                              //         BorderRadius.circular(100),
                                                              //     color: Colors.green
                                                              //   ),
                                                              // ),
                                                              Text(profileModel.data.email.toString(),style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'RaleWay',fontWeight: FontWeight.w700),),
                                                            ],
                                                          ),
                                                        ),

                                                        Divider(
                                                          color: Colors.black54,
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("Contact: ",style: TextStyle(color: Colors.black45,fontSize: 18,fontFamily: 'RaleWay',fontWeight: FontWeight.w700)),
                                                              // Container(
                                                              //   height: 20,  //// stick height
                                                              //   width: 3,
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius:
                                                              //         BorderRadius.circular(100),
                                                              //     color: Colors.green
                                                              //   ),
                                                              // ),
                                                              Text(profileModel.data.contact.toString(),style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'RaleWay',fontWeight: FontWeight.w700),),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    
                                                  )
                                                ],
                                  
                                              );
                                            }
                                            return Center(child: CircularProgressIndicator());

                          
                                          } //builder
                                        )

                                      
                                      ),  

                                    ),
                                    // Text(
                                    //   profileModel.data.name,
                                    //   style: TextStyle(
                                    //     color: themColor,
                                    //     fontFamily: 'Nunito',
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 25,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 20, // order pending
                                    // ),
                                    // Row(
                                    //   mainAxisAlignment:MainAxisAlignment.center,
                                        
                                    //   children: [
                                    //     Column(
                                    //       children: [
                                    //         Text(
                                    //           'Orders',
                                    //           style: TextStyle(
                                    //             color: Colors.grey[700],
                                    //             fontFamily: 'Nunito',
                                    //             fontSize: 25,
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           '10',
                                    //           style: TextStyle(
                                    //             color: Color.fromRGBO(
                                    //                 39, 105, 171, 1),
                                    //             fontFamily: 'Nunito',
                                    //             fontSize: 25,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //     Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //         horizontal: 25,
                                    //         vertical: 8,
                                    //       ),
                                    //       child: Container(
                                    //         height: 100,  //// stick
                                    //         width: 3,
                                    //         decoration: BoxDecoration(
                                    //           borderRadius:
                                    //               BorderRadius.circular(100),
                                    //           color: Colors.green
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Column(
                                    //       children: [
                                    //         Text(
                                    //           'Pending',
                                    //           style: TextStyle(
                                    //             color: Colors.grey[700],
                                    //             fontFamily: 'Nunito',
                                    //             fontSize: 25,
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           '1',
                                    //           style: TextStyle(
                                    //             color: Color.fromRGBO(
                                    //                 39, 105, 171, 1),
                                    //             fontFamily: 'Nunito',
                                    //             fontSize: 25,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 110,
                              right: 20,
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
                                },
                                child: Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  height: 180,
                                  child: Image.asset(
                                    'assets/images/profile.png',
                                    width: innerWidth * 0.45,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),


                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ForgotPassword()));
                        },
                        child: Row(
                          children: [
                            Text("ChangePassword",style: TextStyle(color: Colors.black,fontSize: 20,fontFamily: 'RobotoMono',fontWeight: FontWeight.w700)),
                            SizedBox(width: 4,),
                            Icon(
                              Icons.security_rounded,
                              color: Colors.black,
                            ),
                          ]  
                        ),
                      ),
                      ],
                    ),

                  ),

                 
                  /////
                  // Container(
                  //   height: 20,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(30),
                  //     color: Colors.white,
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15),
                  //     child: Column(
                  //       children: [
                  //         SizedBox(
                  //           height: 20,
                  //         ),
                  //         Text(
                  //           'My Orders',
                  //           style: TextStyle(
                  //             color: Color.fromRGBO(39, 105, 171, 1),
                  //             fontSize: 27,
                  //             fontFamily: 'Nunito',
                  //           ),
                  //         ),
                  //         Divider(
                  //           thickness: 2.5,
                  //         ),
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //         Container(
                  //           height: 40,
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey,
                  //             borderRadius: BorderRadius.circular(30),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 10,
                  //         ),
                  //         Container(
                  //           height: 40,
                  //           decoration: BoxDecoration(
                  //             color: Colors.grey,
                  //             borderRadius: BorderRadius.circular(30),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        )
      ],
    )
      // Stack(
      //   children: [
      //     Container(
      //       width: MediaQuery.of(context).size.width,
      //       height: MediaQuery.of(context).size.height,
      //       color: themColor,
      //     ),

      //     Padding(
      //       padding: EdgeInsets.only(top: 80 ),
      //       child: Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.height,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
      //           color: Colors.white
      //         ),

      //         child: Container(  
               
      //           padding: new EdgeInsets.only(top: 10,),  
      //           child: Card(  
      //             shape: RoundedRectangleBorder(  
      //               borderRadius: BorderRadius.circular(15.0),  
      //             ),  
      //             color: Colors.white,  
      //             elevation: 0,  
      //             child: FutureBuilder<ProfileModel>(
      //               future: http.getPost(),
      //               builder:(BuildContext context,AsyncSnapshot<ProfileModel> snapshot){

      //                 if (snapshot.hasData) {
      //                   ProfileModel profileModel = snapshot.data;
      //                   return ListView(
      //                     //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8, mainAxisSpacing: 4),
      //                     padding: EdgeInsets.all(1),
      //                     shrinkWrap: true,
      //                     scrollDirection: Axis.vertical,
      //                     children: [
      //                       ListTile(
      //                         title: Column(
      //                           children: [

      //                             ClipOval(child: Image.network(profileModel.data.photo,width: 150,height: 250,)),
      //                             Container(
      //                               child: Row(
      //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                 children: [
      //                                   Text("Name: "),
      //                                   Text(profileModel.data.name),
      //                                 ],
      //                               ),
      //                             ),
      //                             Container(
      //                               child: Row(
      //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                 children: [
      //                                   Text("Email: "),
      //                                   Text(profileModel.data.email),
      //                                 ],
      //                               ),
      //                             ),
      //                             Container(
      //                               child: Row(
      //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                 children: [
      //                                   Text("Mobile: "),
      //                                   Text(profileModel.data.contact),
      //                                 ],
      //                               ),
      //                             )
      //                           ],
      //                         )
                              
      //                       )
      //                     ],
             
      //                   );
      //                 }
      //                  return Center(child: CircularProgressIndicator());

     
      //               } //builder
      //             )

                 
      //           ),  

      //         ),

      //       ),
      //     )
      //   ],
      // ),

      
    );
  }
}