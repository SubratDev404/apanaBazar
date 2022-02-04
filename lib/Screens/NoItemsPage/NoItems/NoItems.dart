import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoItems extends StatelessWidget {
  

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
      home: NoItemsScreen(),
    );
  }
}

class NoItemsScreen extends StatefulWidget {
  
  @override
  _NoItemsScreenState createState() => _NoItemsScreenState();
}

class _NoItemsScreenState extends State<NoItemsScreen> {

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
      
      
      body: Container(
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/no_items.png"),
              SizedBox(height: 10,),
              Text('Sorry ! No Products Found !!',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
            ],
            
          ),
        ),
      ),
      
    );
  }
}