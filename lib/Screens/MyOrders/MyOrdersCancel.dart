import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:apanabazar/Bloc/MyOrderCancelBloc.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/MyOrdersCancelModel.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


// class MyOrderCancel extends StatelessWidget {

  
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyOrderCancelScreen(),
      
//     );
//   }
// }

// class MyOrderCancelScreen extends StatefulWidget {
  

//   @override
//   _MyOrderCancelScreenState createState() => _MyOrderCancelScreenState();
// }



// class _MyOrderCancelScreenState extends State<MyOrderCancelScreen> {

//   String _chosenCause;

//   TextEditingController causeController = new TextEditingController();
//   TextEditingController descriptionController = new TextEditingController();
  

//   Future<MyOrdersCancelModel> myOrdersCancelProcess() async {
//     const myOrdersCancel_url='https://apanabazar.com/Gateway/cancel_order';
//     final http.Response response = await http.post(
//         Uri.parse(myOrdersCancel_url),
//         headers: <String, String>{
//           // 'Accept': 'application/json',
//          // 'Content-type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
//         },

//         // body: json.encode({
//         //   'pinCode': pincodeController.text.toString(),
//         //   'fullAddress': fullAddressController.text.toString(),
//         //   'additionalInfo': additionalAddressController.text.toString(),
//         //   'addressType' : CreateAddress.radioButtonid

//         // }),
//         body: {
//           'token': WelcomeScreen.userToken.toString(),
//           'orderno': MyOrdersModified.orderno.toString(),
//           'userid': WelcomeScreen.userUserid.toString(),
//           // 'cause': causeController.text.toString(),
//           'cause': _chosenCause.toString(),
//           'description': descriptionController.text.toString()
//         }
//     );
//       //var responsebody=jsonDecode(jsonDecode(response.body));
//       //if(responsebody['status']==)
//     if (response.statusCode == 200) {

//       // final responseBody=json.decode(response.body);
//       // SignIn.token=responseBody['auth_token'];
//       // return responseBody;

      
//       // print('login body');
//        print(response.body);
//        return MyOrdersCancelModel.fromJson(json.decode(response.body));
//     } else {
//       print("error enter ed");

//      // throw Exception('Failed to create album.');
//     }
//   }


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

 
//   @override
//   Widget build(BuildContext context) {
    
//      final bloc= Bloc();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: themColor,
//         elevation: 0.0,
//         title: Center(child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
//         leading: IconButton(
//           icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
//           onPressed: (){
//             //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
//             Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrdersModified()));
//           },
//         ),
//       ),
      
//       endDrawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Text("Hi ! "+WelcomeScreen.userName  ?? "user"),
//               accountEmail: Text(WelcomeScreen.userEmail ?? "user@gmail.com"),
//               // currentAccountPicture:
//               // Image.network('https://hammad-tariq.com/img/profile.png'),
              
//               decoration: BoxDecoration(color: themColor),
//             ),
//             ListTile(
//               focusColor: themColor,
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {

//                 Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
               
//               },
//             ),
//             ListTile(
//               focusColor: themColor,
//               leading: Icon(Icons.person),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Profile()));
//                // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
//                // Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               focusColor: themColor,
//               leading: Icon(Icons.search),
//               title: Text('Search'),
//               onTap: () {
//                 Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Search()));
//               //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
//                // Navigator.pop(context);
//               },
//             ),
//             Divider(
//               height: 2.0,
//             ),

//             ListTile(
//               focusColor: themColor,
//               leading: Icon(Icons.shopping_bag_rounded),
//               title: Text('My Orders'),
//               onTap: () {
//                 Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrders()));
//               //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
//                // Navigator.pop(context);
//               },
//             ),
           
//             Divider(
//               height: 2.0,
//             ),

            
//             // ListTile(
//             //   focusColor: themColor,
//             //   leading: Icon(Icons.shop),
//             //   title: Text('Shop By Category'),
//             //   onTap: () {
//             //    // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
//             //    // Navigator.pop(context);
//             //   },
//             // ),
//             // Divider(
//             //   height: 2.0,
//             // ),
          
//             ExpansionTile(
//               leading: Icon(Icons.category),
//               title: Text(
//                 "Categories",
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold
//                 ),
//               ),

//               children: [

//                 // ListTile(
//                 //   focusColor: themColor,
//                 //   leading: Icon(Icons.local_grocery_store),
//                 //   title: Text('Grocery'),
//                 //   onTap: (){},
//                 // ),

//                 // ListTile(
//                 //   focusColor: themColor,
//                 //   leading: Icon(Icons.fastfood),
//                 //   title: Text('Food'),
//                 //   onTap: (){},
//                 // ),

//                 // ListTile(
//                 //   focusColor: themColor,
//                 //   leading: Icon(Icons.shopping_bag),
//                 //   title: Text('My Orders'),
//                 //   onTap: (){
//                 //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrders()));
//                 //   },
//                 // ),

//                 ListTile(
//                   focusColor: themColor,
//                   leading: Icon(Icons.favorite),
//                   title: Text('My WishList'),
//                   onTap: (){
//                     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
//                   },
//                 ),

//                 ListTile(
//                   focusColor: themColor,
//                   leading: Icon(Icons.shopping_bag),
//                   title: Text('My Cart'),
//                   onTap: (){
//                     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
//                   },
//                 ),

//                 // ListTile(
//                 //   focusColor: themColor,
//                 //    leading: Icon(Icons.login),
//                 //   title: Text('Sign In'),
//                 //   onTap: (){
//                 //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>SignupPage()));
//                 //   },
//                 // ),
                
//                 ListTile(
//                   focusColor: themColor,
//                    leading: Icon(Icons.logout),
//                   title: Text('Sign Out'),
//                   onTap: (){
//                     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
//                   },
//                 ),

//               ],
//             ),
           
//             Divider(
//               height: 2.0,
//             ),

//             ListTile(
//               focusColor: themColor,
//               leading: Icon(Icons.exit_to_app),
//               title: Text('Exit'),
//               onTap: ()=> exit(0),
//             ),
//             Divider(
//               height: 2.0,
//             ),
      
//             // ListTile(
//             //   focusColor: themColor,
//             //   title: Text('Help and Settings',style: TextStyle(color: Colors.blueGrey),),
//             // ),

//             ExpansionTile(
//               leading: Icon(Icons.help),
//               title: Text(
//                 "Help and Settings",
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold
//                 ),
//               ),

//               children: [

//                 ListTile(
//                   focusColor: themColor,
//                   leading: Icon(Icons.person),
//                   title: Text('Customer Service'),
//                   onTap: (){},
//                 ),

//                 ListTile(
//                   focusColor: themColor,
//                   leading: Icon(Icons.help),
//                   title: Text('Guide'),
//                   onTap: (){},
//                 ),

//                 ListTile(
//                   focusColor: themColor,
//                   leading: Icon(Icons.live_help),
//                   title: Text('Help'),
//                   onTap: (){},
//                 ),
//               ]
//             )    
//           ]  
//         ),
//       ),

//       body: Stack(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             color: themColor
//           ),

//           Padding(
//             padding: EdgeInsets.only(top: 30),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
//                 color: Colors.white
//               ),
//                 child: Column(
//                   //mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
    
//                     SizedBox(
//                       height: 100
//                     ),
    
//                     Expanded(
//                       child: SingleChildScrollView(
//                        // reverse: true,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [

//                             Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Text("Choose Cause: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
//                             ),

//                             Padding(
//                               padding: EdgeInsets.only(left: 10,right: 10),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//                                   color: Colors.black54
//                                 ),
//                               ),
//                             ),
    
    
                           
//                             Padding(
//                               padding: EdgeInsets.only(left: 10,right: 10,top: 10),
//                               child: ClipPath(
//                                 clipper: ShapeBorderClipper(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(Radius.circular(10))
//                                   )
//                                 ),
//                                 child: Container(
//                                   height: 70.0,
//                                   width: MediaQuery.of(context).size.width/1.5,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border(
//                                         bottom: BorderSide(
//                                             color: Colors.white,
//                                             width: 2.0
//                                         )
//                                     )
//                                   ),
                                  

//                                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
//                                   child: DropdownButton<String>(
//                                     underline: SizedBox(),
//                                     value: _chosenCause,
//                                     //elevation: 5,
//                                     style: TextStyle(color: Colors.black),

//                                     items: <String>[
//                                       'Duplicate Order',
//                                       'Order by Mistake',
//                                       'Get Better Price on OutSide',
//                                       'Receive Order Issue',
//                                       'Delay in Delivery',
                                     
//                                     ].map<DropdownMenuItem<String>>((String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800),),
//                                       );
//                                     }).toList(),
//                                     hint: Text(
//                                       "Please choose your cause",
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     onChanged: (String value) {
//                                       setState(() {
//                                         _chosenCause = value;
//                                         print(_chosenCause);
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
      

//                             // Padding(
//                             //   padding: EdgeInsets.only(left: 10),
//                             //   child: Text("Fill Cause: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
//                             // ),
                            
//                             // Padding(
//                             //   padding: EdgeInsets.only(left: 10,right: 10),
//                             //   child: Container(
//                             //     width: MediaQuery.of(context).size.width,
//                             //     height: 5,
//                             //     decoration: BoxDecoration(
//                             //       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//                             //       color: Colors.black54
//                             //     ),
//                             //   ),
//                             // ),
    
//                             // Padding(
//                             //   padding: EdgeInsets.only(left: 0,right: 0),
//                             //   child: StreamBuilder<String>(
//                             //     stream: bloc.cause,
//                             //     builder: (context, snapshot) => Container(
//                             //       height: 180,
//                             //       //color: Color(0xffeeeeee),
//                             //       color: Colors.white,
//                             //       padding: EdgeInsets.all(10.0),
//                             //       child: new ConstrainedBox(
//                             //         constraints: BoxConstraints(
//                             //           maxHeight: 180.0,
//                             //         ),
//                             //         child: new Scrollbar(
//                             //           child: new SingleChildScrollView(
//                             //             scrollDirection: Axis.vertical,
//                             //             reverse: true,
//                             //             child: SizedBox(
//                             //               height: 130.0,
//                             //               child: new TextField(
//                             //                 maxLength: 100,
//                             //                 maxLengthEnforced: true,
//                             //                 maxLines: 100,
//                             //                 onChanged: bloc.causeChanged,
//                             //                 controller: causeController,
//                             //                 decoration: new InputDecoration(
//                             //                   border: OutlineInputBorder(),
//                             //                   hintText: "Fill Your Cause",
//                             //                   labelText: "Cause",
//                             //                   errorText: snapshot.error,
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //           ),
//                             //         ),
//                             //       ),
//                             //     ),

//                             //   ),
//                             // ),

//                             SizedBox(
//                               height: 10.0,
//                             ),

//                             Padding(
//                               padding: EdgeInsets.only(left: 10),
//                               child: Text("Fill Description: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
//                             ),
                           
//                             Padding(
//                               padding: EdgeInsets.only(left: 10,right: 10),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
//                                   color: Colors.black54
//                                 ),
//                               ),
//                             ),

//                             Padding(
//                               padding: EdgeInsets.only(left: 0,right: 0),
//                               child: StreamBuilder<String>(
//                                 stream: bloc.description,
//                                 builder: (context, snapshot) =>  Container(
//                                   height: 180,
//                                   //color: Color(0xffeeeeee),
//                                   color: Colors.white,
//                                   padding: EdgeInsets.all(10.0),
//                                   child: new ConstrainedBox(
//                                     constraints: BoxConstraints(
//                                       maxHeight: 180.0,
//                                     ),
//                                     child: new Scrollbar(
//                                       child: new SingleChildScrollView(
//                                         scrollDirection: Axis.vertical,
//                                         reverse: true,
//                                         child: SizedBox(
//                                           height: 160.0,
//                                           child: new TextField(
//                                             maxLength: 500,
//                                             maxLengthEnforced: true,
//                                             maxLines: 100,
                                            
//                                             onChanged: bloc.descriptionChanged,
//                                             controller: descriptionController,
//                                             decoration: new InputDecoration(
//                                               border: OutlineInputBorder(),
//                                               hintText: "Fill Your Description",
//                                               labelText: "Description",
//                                               errorText: snapshot.error,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                               ),
//                             ),

//                             SizedBox(
//                               height: 30,
//                             ),

//                             Center(
//                               child: ButtonTheme(
//                                 minWidth: MediaQuery.of(context).size.width/2,
//                                 height: 40.0,
//                                 child: StreamBuilder<bool>(
//                                  stream: bloc.submitCheck,
//                                   builder: (context, snapshot) => RaisedButton(
                                   
                                
//                                     color: themColor,
//                               //       // onPressed: snapshot.hasData
//                               //       //     ? () => changeThePage(context)
//                               //       //     : null,
//                               //           //  onPressed: snapshot.hasData
//                               //           // ? () => bloc.submit()
//                               //           // : null,
                                      
//                                     onPressed: 
//                                     //snapshot.hasData
//                                      //? 
//                                      () async{
                                          
//                                       try{

//                                         print(WelcomeScreen.userToken.toString());
//                                         print( MyOrdersModified.orderno.toString());
//                                         print(WelcomeScreen.userUserid.toString());
//                                         print(_chosenCause.toString());
//                                         print(descriptionController.text.toString());

                                
//                                         var response= await myOrdersCancelProcess();
                                       
                                
//                                         bool res=response.status;
//                                         var message=response.message;
                                        
                                        
                                        
//                                         print("Create Address");
                                      
                                       
//                                         print(response.message);
                                       
//                                         if(res==true){
                                
//                                           Fluttertoast.showToast(
//                                             msg: message,
//                                             toastLength: Toast.LENGTH_SHORT,
//                                             gravity: ToastGravity.CENTER,
//                                             timeInSecForIosWeb: 1,
//                                             backgroundColor: Colors.green,
//                                             textColor: Colors.white,
//                                             fontSize: 16.0
//                                           );
                                
                                          
//                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> MyOrdersModified()));
//                                         }
                                
//                                         else if(res==false){
//                                           Fluttertoast.showToast(
//                                             msg: "Creation of Address Failed",
//                                             toastLength: Toast.LENGTH_SHORT,
//                                             gravity: ToastGravity.CENTER,
//                                             timeInSecForIosWeb: 1,
//                                             backgroundColor: Colors.green,
//                                             textColor: Colors.white,
//                                             fontSize: 16.0
//                                           );
//                                         }
//                                         else{
                                
//                                         }
//                                       }
//                                       catch(err){
//                                         Fluttertoast.showToast(
//                                           msg: "Check Credentials",
//                                           toastLength: Toast.LENGTH_SHORT,
//                                           gravity: ToastGravity.CENTER,
//                                           timeInSecForIosWeb: 1,
//                                           backgroundColor: Colors.red,
//                                           textColor: Colors.white,
//                                           fontSize: 16.0
//                                         );
                                
//                                       }
//                                     },
//                                    // : null,
//                                      child: Text("Cancel Order", style: TextStyle( fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
//                                    ),
//                                 ),
//                               ),
//                             ),
    
//                           ],
//                         ),
//                       )
//                     )
//                   ],
//                 )
//             ),
//           )
//         ],
//       ),
      
//     );
//   }
// }

//////////////////// 2ND

class MyOrderCancel extends StatelessWidget {

  
  
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
      home: MyOrderCancelScreen(),
      
    );
  }
}

class MyOrderCancelScreen extends StatefulWidget {
  

  @override
  _MyOrderCancelScreenState createState() => _MyOrderCancelScreenState();
}



class _MyOrderCancelScreenState extends State<MyOrderCancelScreen> {

  final _formKey = GlobalKey<FormState>();
  
  bool _autovalidate = false;
  String selectedChosenCause;
  String _chosenCause;

  TextEditingController causeController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  

  Future<MyOrdersCancelModel> myOrdersCancelProcess() async {
    const myOrdersCancel_url='https://apanabazar.com/Gateway/cancel_order';
    //const myOrdersCancel_url="http://61.12.81.38/apanabazar.com/Gateway/cancel_order";
    final http.Response response = await http.post(
        Uri.parse(myOrdersCancel_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
        },

        // body: json.encode({
        //   'pinCode': pincodeController.text.toString(),
        //   'fullAddress': fullAddressController.text.toString(),
        //   'additionalInfo': additionalAddressController.text.toString(),
        //   'addressType' : CreateAddress.radioButtonid

        // }),
        body: {
          'token': WelcomeScreen.userToken.toString(),
          'orderno': MyOrdersModified.orderno.toString(),
          'userid': WelcomeScreen.userUserid.toString(),
          // 'cause': causeController.text.toString(),
          'cause': selectedChosenCause.toString(),
          'description': descriptionController.text.toString()

          
        }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
     //  print(response.body);
       return MyOrdersCancelModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

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
  //   //BackButtonInterceptor.remove(myInterceptor);
  //   super.dispose();
  //   causeController.dispose();
  //   descriptionController.dispose();
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
    
    final bloc= Bloc();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Cancel Order',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>MyOrdersModified()));
          },
        ),
      ),
      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor
            ),

            //  Positioned(
            //           top: 10,
            //           child: Container(
            //             height: 60,
            //             width: 200,
            //             color: Colors.blue,
            //           )
            //         ),
           

            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                     
  
                      SizedBox(
                        height: 40
                      ),
  
                      //Expanded(
                        SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Choose Cause: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                              ),
                              SizedBox(height: 2),

                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                    color: Colors.black54
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(2))
                                    )
                                  ),
                                  child: Container(
                                    height: 80.0,
                                    width: MediaQuery.of(context).size.width-10,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // border: Border(
                                      //     bottom: BorderSide(
                                      //         color: Colors.black54,
                                      //         width: 1.0
                                      //     )
                                      // )
                                    ),
                                    child: DropdownButtonFormField<String>(
                                     
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                      decoration: InputDecoration(
                                        // enabledBorder: UnderlineInputBorder(
                                        //   borderSide: BorderSide(color: Colors.black54)
                                        // )
                                      ),
                                      
                                      value: selectedChosenCause,
                                      hint: Text('Please Choose your Cause',style: TextStyle(fontFamily: 'RaleWay',fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black38)),
                                      onChanged: (cause) =>
                                          setState(() => selectedChosenCause = cause),
                                      validator: (value) => value == null ? 'field required' : null,
                                      items:
                                          ['Duplicate Order', 'Order by Mistake','Get Better Price on OutSide','Receive Order Issue','Delay in Delivery' ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                        
                                          value: value,
                                          child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
  
  
                              //  Drop Down Start
                              // Padding(
                              //   padding: EdgeInsets.only(left: 10,right: 10,top: 10),
                              //   child: ClipPath(
                              //     clipper: ShapeBorderClipper(
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(Radius.circular(10))
                              //       )
                              //     ),
                              //     child: Container(
                              //       height: 70.0,
                              //       width: MediaQuery.of(context).size.width/1.5,
                              //       decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         border: Border(
                              //             bottom: BorderSide(
                              //                 color: themColor,
                              //                 width: 7.0
                              //             )
                              //         )
                              //       ),
                                    
                           
                              //         padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                    
                              //         child: DropdownButton<String>(
                              //           underline: SizedBox(),  // for removing under line below drop down
                              //           value: _chosenCause,
                              //           //elevation: 5,
                              //           style: TextStyle(color: Colors.black),

                              //           items: <String>[
                              //             'Duplicate Order',
                              //             'Order by Mistake',
                              //             'Get Better Price on OutSide',
                              //             'Receive Order Issue',
                              //             'Delay in Delivery',
                                          
                              //           ].map<DropdownMenuItem<String>>((String value) {
                              //             return DropdownMenuItem<String>(
                              //               value: value,
                              //               child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800),),
                              //             );
                              //           }).toList(),
                              //           hint: Text(
                              //             "Please choose your cause",
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 18,
                              //                 fontWeight: FontWeight.w600),
                              //           ),
                              //           onChanged: (String value) {
                              //             setState(() {
                              //               _chosenCause = value;
                              //               print(_chosenCause);
                              //             });
                              //           },
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              //  Drop Down End

                              // TextField start
                              // Padding(
                              //   padding: EdgeInsets.only(left: 10),
                              //   child: Text("Fill Cause: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                              // ),
                              
                              // Padding(
                              //   padding: EdgeInsets.only(left: 10,right: 10),
                              //   child: Container(
                              //     width: MediaQuery.of(context).size.width,
                              //     height: 5,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                              //       color: Colors.black54
                              //     ),
                              //   ),
                              // ),
  
                              // Padding(
                              //   padding: EdgeInsets.only(left: 0,right: 0),
                              //   child: StreamBuilder<String>(
                              //     stream: bloc.cause,
                              //     builder: (context, snapshot) => Container(
                              //       height: 180,
                              //       //color: Color(0xffeeeeee),
                              //       color: Colors.white,
                              //       padding: EdgeInsets.all(10.0),
                              //       child: new ConstrainedBox(
                              //         constraints: BoxConstraints(
                              //           maxHeight: 180.0,
                              //         ),
                              //         child: new Scrollbar(
                              //           child: new SingleChildScrollView(
                              //             scrollDirection: Axis.vertical,
                              //             reverse: true,
                              //             child: SizedBox(
                              //               height: 130.0,
                              //               child: new TextField(
                              //                 maxLength: 100,
                              //                 maxLengthEnforced: true,
                              //                 maxLines: 100,
                              //                 onChanged: bloc.causeChanged,
                              //                 controller: causeController,
                              //                 decoration: new InputDecoration(
                              //                   border: OutlineInputBorder(),
                              //                   hintText: "Fill Your Cause",
                              //                   labelText: "Cause",
                              //                   errorText: snapshot.error,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),

                              //   ),
                              // ),
                              // TextField end

                              SizedBox(
                                height: 0.0,
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Fill Description: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                              ),
                              
                              SizedBox(
                                height: 5.0,
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                    color: Colors.black54
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 0,right: 0),
                                child: StreamBuilder<String>(
                                  stream: bloc.description,
                                  builder: (context, snapshot) =>  Container(
                                    height: 180,
                                    //color: Color(0xffeeeeee),
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10.0),
                                    child: new ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 180.0,
                                      ),
                                      child: new Scrollbar(
                                        child: new SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          reverse: true,
                                          child: SizedBox(
                                            height: 160.0,
                                            child: new TextField(
                                              maxLength: 500,
                                              maxLengthEnforced: true,
                                              maxLines: 100,
                                              
                                              onChanged: bloc.descriptionChanged,
                                              controller: descriptionController,
                                              decoration: new InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Fill Your Description",hintStyle: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.w300),
                                                labelText: "Description",
                                                errorText: snapshot.error,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ),
                              ),

                              SizedBox(
                                height: 30,
                              ),

                              Center(
                                child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width/1.05,
                                  height: 40.0,
                                  child: StreamBuilder<bool>(
                                    stream: bloc.submitCheck,
                                    builder: (context, snapshot) => RaisedButton(
                                      
                                  
                                      color: themColor,
                                //       // onPressed: snapshot.hasData
                                //       //     ? () => changeThePage(context)
                                //       //     : null,
                                //           //  onPressed: snapshot.hasData
                                //           // ? () => bloc.submit()
                                //           // : null,
                                        
                                      onPressed: 
                                      //snapshot.hasData
                                        //? 

                                       
                                        () async{

                                        if (_formKey.currentState.validate()) {
                                          //form is valid, proceed further
                                          _formKey.currentState.save();//save once fields are valid, onSaved method invoked for every form fields
                                          try{
                                    
                                            var response= await myOrdersCancelProcess();
                                            
                                    
                                            bool res=response.status;
                                            var message=response.message;
                                            
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyOrdersModified()));
                                            
                                            //print("Create Address");
                                          
                                            
                                            //print(response.message);
                                            
                                            if(res==true){
                                    
                                              Fluttertoast.showToast(
                                                msg: message,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                    
                                              
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> MyOrdersModified()));
                                            }
                                    
                                            else if(res==false){
                                              Fluttertoast.showToast(
                                                msg: "Can not cancel the order",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                            }
                                            else{
                                    
                                            }
                                          }
                                          catch(err){
                                            Fluttertoast.showToast(
                                              msg: "Check All Fields",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                            );
                                    
                                          }

                                        } else {
                                          setState(() {
                                            _autovalidate = true; //enable realtime validation
                                          });
                                        }
                                        
                                            
                                          
                                         
                                      },
                                      // : null,
                                        child: Text("Cancel Order", style: TextStyle( fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                                      ),
                                  ),
                                ),
                              ),
  
                            ],
                          ),
                        )
                     // )
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
      
    );
  }
}