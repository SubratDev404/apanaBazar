import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: DrawerScreen(),
      
    
      
      
    );
  }
}

class DrawerScreen extends StatefulWidget {
  

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

       child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Hi ! "+WelcomeScreen.userName  ?? "user"),
                accountEmail: Text(WelcomeScreen.userEmail ?? "user@gmail.com"),
                // currentAccountPicture:
                // Image.network('https://hammad-tariq.com/img/profile.png'),
                
                decoration: BoxDecoration(color: themColor),
              ),
              ListTile(
                focusColor: themColor,
                leading: Icon(Icons.home,color: Colors.black54,size: 30,),
                title: Text('Home',style: TextStyle(color: themColor,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                onTap: () {

                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
                 
                },
              ),
              ListTile(
                focusColor: themColor,
                leading: Icon(Icons.person),
                title: Text('Profile',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Profile()));
                 // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
                 // Navigator.pop(context);
                },
              ),

              ListTile(
                focusColor: themColor,
                leading: Icon(Icons.search),
                title: Text('Search',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                onTap: () {
                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Search()));
                //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
                 // Navigator.pop(context);
                },
              ),
              Divider(
                height: 2.0,
              ),

              ExpansionTile(
                leading: Icon(Icons.category),
                title: Text(
                  "My Categories",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                children: [
                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.shopping_bag_rounded),
                    title: Text('My Orders',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: () {
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrdersModified()));
                    //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
                    // Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.favorite),
                    title: Text('My WishList',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: (){
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
                    },
                  ),

                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.shopping_bag),
                    title: Text('My Cart',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: (){
                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
                    },
                  ),
                ],
              ),
             
              Divider(
                height: 2.0,
              ),
              ListTile(
                focusColor: themColor,
                leading: Icon(Icons.logout),
                title: Text('Sign Out',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                onTap: ()async{
                  SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                  loginPrefs.clear();
                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
                },
              ),

              ListTile(
                focusColor: themColor,
                leading: Icon(Icons.exit_to_app),
                title: Text('Exit',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
                onTap: ()=> exit(0),
              ),
              Divider(
                height: 2.0,
              ),
        
              // ListTile(
              //   focusColor: themColor,
              //   title: Text('Help and Settings',style: TextStyle(color: Colors.blueGrey),),
              // ),

              ExpansionTile(
                leading: Icon(Icons.help),
                title: Text(
                  "Help and Settings",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

                children: [

                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.person),
                    title: Text('Customer Service',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: (){},
                  ),

                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.help),
                    title: Text('Guide',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: (){
                      
                    },
                  ),

                  ListTile(
                    focusColor: themColor,
                    leading: Icon(Icons.live_help),
                    title: Text('Help',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 12)),
                    onTap: (){},
                  ),
                ]
              )    
            ]  
          ),
        ),
      
    );
  }
}