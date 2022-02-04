import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoItemInSubCategoryList extends StatelessWidget {
  

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
      home: NoItemInSubCategoryListScreen(),
    );
  }
}

class NoItemInSubCategoryListScreen extends StatefulWidget {
  
  @override
  _NoItemInSubCategoryListScreenState createState() => _NoItemInSubCategoryListScreenState();
}

class _NoItemInSubCategoryListScreenState extends State<NoItemInSubCategoryListScreen> {

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
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),  // for change Drawer icon color
       
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CurvedBottomNavigationBar()));
          },
        ),

        title:(
          // alignment: Alignment.center,
          Text('Go To Home',style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
        ),
      ),

      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),
      
      
      // body: Container(
      //   child: Center(
      //     child: Image.asset("assets/images/empty_wishlist.png"),
      //   ),
      // ),

      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Row(
              //   children: <Widget>[
              //     Text(
              //       "eshiett1995",
              //       textAlign: TextAlign.left,
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //     SizedBox(
              //       width: 100,
              //     ),
              //     Expanded(
              //         child: Text(
              //       "4:33amkKKKSmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm",
              //       textDirection: TextDirection.ltr,
              //       textAlign: TextAlign.right,
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ))
              //   ],
              // ),

              ///////////// Testing start ////////////////////////
              // Card(
              //   elevation: 4,
              //   child: Container(
              //     padding: EdgeInsets.all(6),
              //     child: Row(
              //       children: <Widget>[
              //         Container(
              //           height: 110,
              //           width: 90,
              //           child: Image.network(
              //             'https://placeimg.com/250/250/any',
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //         SizedBox(
              //           width: 5.0,
              //         ),
              //         Flexible(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: <Widget>[
              //               MergeSemantics(
              //                 child: Row(
              //                   children: <Widget>[
              //                     Icon(
              //                       Icons.crop_square,
              //                       color: Colors.red,
              //                       size: 18,
              //                     ),
              //                     Flexible(
              //                       child: Text(
              //                         'The overflowing RenderFlex has an orientation of Axis.horizontal.',
              //                         overflow: TextOverflow.ellipsis,
              //                         softWrap: true,
              //                         style: TextStyle(
              //                             fontSize: 13,
              //                             fontWeight: FontWeight.w600,
              //                             color: Theme.of(context).primaryColor),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //               SizedBox(height: 5),
              //               Text(
              //                 'The overflowing RenderFlex has an orientation of Axis.horizontal.',
              //                 maxLines: 1,
              //                 style: TextStyle(
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.w500,
              //                     color: Colors.grey),
              //               ),
              //               SizedBox(height: 5),
              //               Text(
              //                 '₹ 10,000',
              //                 style: TextStyle(
              //                     fontSize: 13,
              //                     fontWeight: FontWeight.w700,
              //                     color: Colors.black),
              //               )
              //             ],
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),


              // Container(
              //   height: 300,
              //   child: Card(
              //   semanticContainer: true,
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   child: Image.network(
              //     'https://placeimg.com/640/480/any', fit: BoxFit.fill,),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10.0),
              //   ),
              //   elevation: 5,
              //   margin: EdgeInsets.all(10),
              //   ),
              // ),
    
              ///////////// Testing End ////////////////////////
              Image.asset("assets/images/empty_orders.png"),
              SizedBox(
                height: 10,
              ),
              Text('No Items!!!!',style: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),)

              
            ],
            
          ),
        ),
      ),
      
    );
  }
}