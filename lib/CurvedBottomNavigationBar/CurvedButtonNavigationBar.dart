
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CurvedBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.red,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: CurvedBottomNavigationBarScreen(),
      
    );
  }
}

class CurvedBottomNavigationBarScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<CurvedBottomNavigationBarScreen> {

  int selectedpage = 0; //initial value 
  
  final _pageOptions = [Home(), WishList(), MyOrdersModified()]; // listing of all 3 pages index wise
  
  final bgcolor = [themColor,themColor, themColor]; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageOptions[selectedpage],
      bottomNavigationBar: CurvedNavigationBar(

        height: 50, 
        buttonBackgroundColor: Colors.amber,
        backgroundColor: bgcolor[selectedpage],
        color: Colors.white,
        animationCurve: Curves.elasticInOut,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.shopping_bag,
            size: 30,
            color: Colors.black,
          )
        ],

        onTap: (index){
           setState(() {
             selectedpage=index;
           });
        },
        // onTap: (index) {
        //   setState(() {
        //     selectedpage = index;  // changing selected page as per bar index selected by the user
        //   }
        // );

      )

      
    );
  }
}