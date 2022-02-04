import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Screens/Address/CreateAddress/CreateAddress.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoPreviousAddress extends StatelessWidget {
  

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
      home: NoItemInMyOrdersScreen(),
    );
  }
}

class NoItemInMyOrdersScreen extends StatefulWidget {
  
  @override
  _NoItemInMyOrdersScreenState createState() => _NoItemInMyOrdersScreenState();
}

class _NoItemInMyOrdersScreenState extends State<NoItemInMyOrdersScreen> {

  @override
    void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
  }

  @override
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
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),  // for change Drawer icon color
       
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CreateAddress()));
          },
        ),

        title:(
          // alignment: Alignment.center,
          Text('Back',style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      // endDrawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         accountName: Text("Hi ! "+WelcomeScreen.userName  ?? "user"),
      //         accountEmail: Text(WelcomeScreen.userEmail ?? "user@gmail.com"),
      //         // currentAccountPicture:
      //         // Image.network('https://hammad-tariq.com/img/profile.png'),
              
      //         decoration: BoxDecoration(color: themColor),
      //       ),
      //       ListTile(
      //         focusColor: themColor,
      //         leading: Icon(Icons.home),
      //         title: Text('Home',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //         onTap: () {

      //           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
               
      //         },
      //       ),
      //       ListTile(
      //         focusColor: themColor,
      //         leading: Icon(Icons.person),
      //         title: Text('Profile',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //         onTap: () {
      //           Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Profile()));
      //          // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
      //          // Navigator.pop(context);
      //         },
      //       ),

      //       ListTile(
      //         focusColor: themColor,
      //         leading: Icon(Icons.search),
      //         title: Text('Search',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //         onTap: () {
      //           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Search()));
      //         //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
      //          // Navigator.pop(context);
      //         },
      //       ),
      //       Divider(
      //         height: 2.0,
      //       ),

      //       ExpansionTile(
      //         leading: Icon(Icons.category),
      //         title: Text(
      //           "My Categories",
      //           style: TextStyle(
      //             fontSize: 18.0,
      //             fontWeight: FontWeight.bold
      //           ),
      //         ),

      //         children: [
      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.shopping_bag_rounded),
      //             title: Text('My Orders',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: () {
      //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrders()));
      //             //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
      //             // Navigator.pop(context);
      //             },
      //           ),

      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.favorite),
      //             title: Text('My WishList',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: (){
      //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
      //             },
      //           ),

      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.shopping_bag),
      //             title: Text('My Cart',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: (){
      //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
      //             },
      //           ),
      //         ],
      //       ),
           
      //       Divider(
      //         height: 2.0,
      //       ),
      //       ListTile(
      //         focusColor: themColor,
      //         leading: Icon(Icons.logout),
      //         title: Text('Sign Out',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //         onTap: (){
      //           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
      //         },
      //       ),

      //       ListTile(
      //         focusColor: themColor,
      //         leading: Icon(Icons.exit_to_app),
      //         title: Text('Exit',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //         onTap: ()=> exit(0),
      //       ),
      //       Divider(
      //         height: 2.0,
      //       ),
      
      //       // ListTile(
      //       //   focusColor: themColor,
      //       //   title: Text('Help and Settings',style: TextStyle(color: Colors.blueGrey),),
      //       // ),

      //       ExpansionTile(
      //         leading: Icon(Icons.help),
      //         title: Text(
      //           "Help and Settings",
      //           style: TextStyle(
      //             fontSize: 18.0,
      //             fontWeight: FontWeight.bold
      //           ),
      //         ),

      //         children: [

      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.person),
      //             title: Text('Customer Service',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: (){},
      //           ),

      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.help),
      //             title: Text('Guide',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: (){},
      //           ),

      //           ListTile(
      //             focusColor: themColor,
      //             leading: Icon(Icons.live_help),
      //             title: Text('Help',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
      //             onTap: (){},
      //           ),
      //         ]
      //       )    
      //     ]  
      //   ),
      // ),
      
      
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/no_address.png"),
              SizedBox(
                height: 10,
              ),
              Text('No Previous Address Found',style: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),)
            ],
            
          ),
        ),
      ),
      
    );
  }
}