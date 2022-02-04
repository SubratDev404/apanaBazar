import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/SerachListModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/ItemDetails/ItemDetails.dart';
import 'package:apanabazar/Screens/ItemDetails/ItemDetailsModified.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/ProductList/ProductList.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatelessWidget {
  

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
      home: SearchScreen(),
      
    );
  }
}

class SearchScreen extends StatefulWidget {
  

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

final serachController=TextEditingController();
List showSearchList = [];

  Future<SearchListModel> searchListProcess() async {
    const searchList_url='https://apanabazar.com/Gateway/fetch_item_details';
    final http.Response response = await http.post(
        Uri.parse(searchList_url),
        // headers: <String, String>{
        //   // 'Accept': 'application/json',
        //   //'Content-type': 'application/json',
        //   'Accept': 'application/json',
        //   'Authorization': 'Bearer '+WelcomeScreen.userToken
        // },

        // body: json.encode({
        //   'itemId': ItemList.itemlistId,
        //   'isNotified': '0',
        // }),
        body: {
          'itemname': serachController.text.toString(),
          
        }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
      //fetchWishList();

      var searchBody=json.decode(response.body);
     // print("searchBody >>>>>>>>>>>>>>>>> "+searchBody);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;
      setState(() {
        showSearchList = searchBody;
        
      });
      
      print('Search body');
      print(response.body);
       return SearchListModel.fromJson(json.decode(response.body));
    } else {

      showSearchList= [];
     // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
     serachController.addListener(searchListProcess);
     //// BackButtonInterceptor.add(myInterceptor);
  }
  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    serachController.dispose();
    super.dispose();
  }

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
      //resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Search',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=> CurvedBottomNavigationBar()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
          },
        ),
      ),

     endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),


      body: SingleChildScrollView(
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor,

                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                     padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-20,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              color: Colors.white
                            ),
                            
                            child: TextFormField(
                              autofocus: true,
                              controller: serachController,                
                              keyboardType: TextInputType.text,
                              
                              autofillHints: [AutofillHints.name],

                              validator: (val){
                                if(val.isEmpty){
                                  return "field can't be empty";
                                }
                                // else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                                //   return "Enter a valid email address";
                                // }
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
                                hintText: "Write here...",
                                // labelText: "Email",
                              )  
                              
                            ),
                            
                          ),

                         
                        ],
                      ),
                    ),
                  ),
                ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 80),
               
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    itemCount: showSearchList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: 
                
                        Stack(
                          children: [

                            InkWell(

                              onTap: (){
                                String p=showSearchList[index]['id'].toString();
                                //print("p ////////////////// "+p);
                                Home.itemId=showSearchList[index]['id'].toString();
                               // print(" Home.itemId ////////////////// "+  Home.itemId);
                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ItemDetailsModified()));
                                
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5),bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5))
                                ),
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                            
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                           // Icon(Icons.update,color: Colors.black45,size: 30,),
                                            SizedBox(width: 2,),
                                            Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height: 150,
                                              child: Image.network(showSearchList[index]['image'],height: 200,),
                                            ),
                                          ],
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(showSearchList[index]['variant']['variantdetails'][0]['variantvalue'].toString(),overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                        )

                                        // Flexible(
                                        //   child: Text(showSearchList[index]['variant']['variantdetails'][0]['variantvalue'].toString(),overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                        // )

                                        // SingleChildScrollView(
                                        //   scrollDirection: Axis.horizontal,
                                        //   child: Padding(
                                        //     padding: EdgeInsets.only(left: 20,top: 5),
                                        //     child: Text(showSearchList[index]['variant']['variantdetails'][0]['variantvalue'].toString(),maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                        //   )
                                        // ),
                                      ],
                                     
                                    ),
                                    
                                    
                                    Icon(Icons.keyboard_arrow_right,color: Colors.black87,size: 30,)
                                  
                                  ]
                                ),
                              ),
                            ),
                    
                          ]  
                        ),

                      );
                    }
                  ),
              ),
               

      
              ),
            ),


          // Padding(
          //   padding: EdgeInsets.only(top: 80),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          //       color: Colors.white,
          //     ),

          //     child: Padding(
          //       padding: EdgeInsets.only(top: 20),
          //       child: ListView.builder(
          //         itemCount: showSearchList.length,
          //         itemBuilder: (context,index){
          //           return ListTile(
          //             title: 
              
          //             Stack(
          //               children: [

          //                 Container(
          //                   width: MediaQuery.of(context).size.width,
          //                   height: 100,
          //                   decoration: BoxDecoration(
          //                     color: Colors.black54,
          //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
          //                   ),
          //                   child: Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Expanded(
          //                         child: SingleChildScrollView(
          //                           scrollDirection: Axis.horizontal,
          //                           child: Padding(
          //                             padding: EdgeInsets.only(left: 20,top: 5),
          //                             child: Text(showSearchList[index]['itemname'].toString(),style: TextStyle(color:Colors.red,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
          //                         ),
          //                       ),
          //                     ]
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: EdgeInsets.only(top: 30),
          //                   child: Container(
          //                     height: 130,
          //                     child: Card(
          //                       shadowColor: Colors.black38,
          //                       shape:RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(10)
          //                       ),
          //                       elevation: 8,
          //                       margin:EdgeInsets.only(left: 5,right: 5) ,
          //                       child: Padding(
          //                         padding: EdgeInsets.only(left: 10,top: 10,right: 10),
          //                         child: Column(
          //                           children:[
          //                             // Row(
          //                             //   crossAxisAlignment: CrossAxisAlignment.start,
          //                             //   mainAxisAlignment: MainAxisAlignment.start,
          //                             //   children: [
                                    
          //                             //     Container(
          //                             //       width: MediaQuery.of(context).size.width/6,
          //                             //       height: 60,
          //                             //       child: ClipRRect(
          //                             //         borderRadius: BorderRadius.circular(15.0),
          //                             //         child: Image.asset("assets/images/item_icon.png",
          //                             //           height: 60,
          //                             //           // fit: BoxFit.cover,
          //                             //           // alignment: Alignment.centerLeft,
          //                             //         )
          //                             //       ),
          //                             //     ),
                                    
                                          
          //                             //     Padding(
          //                             //       padding: EdgeInsets.only(top: 10,left: 5),
          //                             //       child:Container(
          //                             //         width: MediaQuery.of(context).size.width/1.6,
          //                             //         //width: 280,
          //                             //         height: 60,
          //                             //         color: Colors.white,
          //                             //         child: Column(
          //                             //           crossAxisAlignment: CrossAxisAlignment.start,
          //                             //           mainAxisAlignment: MainAxisAlignment.start,
          //                             //           children: [
                                    
          //                             //             Column(
          //                             //               crossAxisAlignment: CrossAxisAlignment.start,
          //                             //               mainAxisAlignment: MainAxisAlignment.start,
          //                             //               children: [
          //                             //                 Row(
          //                             //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             //                   children: [
          //                             //                     //Text("Product: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
          //                             //                    // Text(showWishList[index]['itemname'].toString(),style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                         
          //                             //                   ],
          //                             //                 ),
          //                             //                 SizedBox(
          //                             //                   height: 0,
          //                             //                 ),
          //                             //                 Row(
          //                             //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             //                   children: [
          //                             //                     Text("MRP: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
          //                             //                     Text(showWishList[index]['mrp'].toString()+"/-",style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
          //                             //                   ],
          //                             //                 ),
          //                             //                 Row(
          //                             //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             //                   children: [
          //                             //                     Text("Sale Price: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
          //                             //                     Text(showWishList[index]['saleprice'].toString()+"/-",style: TextStyle(color:Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
          //                             //                   ],
          //                             //                 ),
          //                             //                 // Text("gold milk",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
          //                             //                 // Text("Quantity : 1",style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
          //                             //                 // Icon(Icons.favorite,color: Colors.red,)
          //                             //               ],
          //                             //             ),
                                    
          //                             //           ]
          //                             //         )    
          //                             //       )
          //                             //     ),
          //                             //   ],
          //                             // ),
                
          //                             // Row(
          //                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             //   children: [
          //                             //     ElevatedButton(
          //                             //       child: Icon(Icons.delete_forever_rounded),
          //                             //         // icon: Icon(Icons.delete_forever_rounded),
          //                             //         // label: Text('', style: TextStyle(color: Colors.white),),
          //                             //         style: ElevatedButton.styleFrom(
          //                             //           primary: themColor,
          //                             //           onPrimary: Colors.white,
          //                             //           shadowColor: Colors.white60,
          //                             //           shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          //                             //           elevation: 10,
          //                             //         ),
          //                             //         onPressed: () {
          //                             //           //print("ok");
          //                             //           WishList.wishid=showWishList[index]['wishid'].toString();
          //                             //          // print(WishList.wishid);
          //                             //           deleteWishListItemProcess();
          //                             //           // print("id");
          //                             //           // WishList.wishid=showWishList[index]['wishid'].toString();
          //                             //           // // print("))))))))))))))))))))))))))))) "+WishList.wishid);
          //                             //           // WishList.itemId=showWishList[index]['itemid'].toString();
          //                             //           // print(ItemList.itemlistId);
          //                             //           // var response=await addToCartProcess();
          //                             //           // bool res=response.response;
          //                             //           // if(res==true){
          //                             //           //
          //                             //           //   deleteWishListItemProcess();
          //                             //           //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully")));
          //                             //           // }
          //                             //         }
          //                             //     ),
          //                             //     // InkWell(
          //                             //     //   child: Row(
          //                             //     //     children: [
          //                             //     //       Text("Delete",style: TextStyle(color:themColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
          //                             //     //       Image.asset('assets/images/delete_icon.png',color: themColor,height: 30,)
          //                             //     //     ]
          //                             //     //   ),
          //                             //     //   onTap: () {
          //                             //     //     print("ok");
          //                             //     //     WishList.wishid=showWishList[index]['wishid'].toString();
          //                             //     //     print(WishList.wishid);
          //                             //     //     deleteWishListItemProcess();
          //                             //     //     //fetchWishList();
          //                             //     //   },
          //                             //     // ),

          //                             //     ElevatedButton.icon(
          //                             //       icon: Icon(Icons.shopping_cart),
          //                             //       label: Text('Add To Cart', style: TextStyle(color: Colors.white),),
          //                             //       style: ElevatedButton.styleFrom(
          //                             //         primary: themColor,
          //                             //         onPrimary: Colors.white,
          //                             //         shadowColor: Colors.white60,
          //                             //         shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          //                             //         elevation: 10,
          //                             //       ),
          //                             //       onPressed: () async{
          //                             //       //  print("id");
          //                             //         WishList.wishid=showWishList[index]['wishid'].toString();
          //                             //       // print("))))))))))))))))))))))))))))) "+WishList.wishid);
          //                             //         WishList.itemId=showWishList[index]['itemid'].toString();
          //                             //       //  print(ItemList.itemlistId);
          //                             //         var response=await addToCartProcess();
          //                             //         bool res=response.response;
          //                             //         if(res==true){
                                                
          //                             //           deleteWishListItemProcess();
          //                             //           scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully"))); 
          //                             //         }
          //                             //       }
          //                             //     ),
                
          //                             //   ],
          //                             // )
                                          
          //                           ]  
          //                         ),
          //                       ) 
          //                     ),
          //                   ),
          //                 ),
          //               ]  
          //             ),

          //           );
          //         }
          //       ),
          //     ),
              
          //   ),
          // )

            
          ],
        ),
      ),
      
    );
  }
}