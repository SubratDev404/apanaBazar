import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/ProductListModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:apanabazar/Screens/ItemList/ItemList.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInProductList/NoItemInProductList.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInWishList/NoItemInWishList.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/SubCategory/SubCategory.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

//// not in use////////////
// class HttpService {
//   final String url = "https://api.apanabazar.com/api/productlist";

//   Future<ProductListModel> getPost() async {
//     var response = await http.post(Uri.parse(url),

//       headers:<String, String>
//       {
//         //'Accept': 'application/json',
//        // 'Authorization': 'Bearer'+''+Login.token,
//       //  'Content-type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer'+' '+WelcomeScreen.userToken,
//       },

//       body: json.encode({
//        "subcatid": SubCategory.subCategoryId.toString()
//          //"subcatid": "6"
//       })

//       // body: {
//       //   "categoryid": "7"
//       // }
//     );

//     if (response.statusCode == 200) {
//       var body = json.decode(response.body);
//       bool res = ProductListModel.fromJson(body).response;
//       print(body);
       
//        print("product res >>>>>>>>>>>>>>>>>>>>>>>>>>>"+ res.toString());
//        print(res);
//        if(res==false)
//        {
//           Fluttertoast.showToast(
//           msg: "No Items Found",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0
//         );
//        }
      
//       return ProductListModel.fromJson(body);
//     }
//   }
// }

class ProductList extends StatelessWidget {
  
   static String productId;
   

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
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

 // bool isData = true;

  
  int cartWishListCount=0;
  int cartBadgeCount=0;

  //final HttpService httpService = HttpService(); // not in use

  List showProductList; 
  bool isLoading = true;

  fetchProductList() async {
    setState(() {
      isLoading = true;
    });
   // var url = "https://randomuser.me/api/?results=50";
    var showProductList_url= "https://api.apanabazar.com/api/productlist";
    var response = await http.post(
      Uri.parse(showProductList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },

      body: json.encode({
       "subcatid": SubCategory.subCategoryId.toString()
         //"subcatid": "6"
      })

    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? []; // if no json array come, default array will pass to model
      var res= json.decode(response.body)['response'];
       print('response body ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
       print(items);
       print("res+++++++++++++++++"+ res.toString());
      
      setState(() {
        showProductList = items;
        isLoading = false;
      });
      
      if(res==false){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInProductList()));

      }

    }else{
      showProductList = [];
      isLoading = false;
    }
  }

  fetchCartList() async {
    var cartList_url= "https://api.apanabazar.com/api/cart";
    var response = await http.get(
      Uri.parse(cartList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    // print(response.body);
    if(response.statusCode == 200){
      var nos_of_items_in_Cart = json.decode(response.body)['itemCount'];

      setState(() {
        cartBadgeCount=nos_of_items_in_Cart as int;
      });
      
    }
    else{}
  }

  fetchWishList() async {
    var showWishList_url= "https://api.apanabazar.com/api/showwishlist";
    var response = await http.get(
      Uri.parse(showWishList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    if(response.statusCode == 200){
      var nos_of_items_in_WishList = json.decode(response.body)['data'].length;
      setState(() {
        cartWishListCount=nos_of_items_in_WishList as int;
      });
    }else{}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProductList=[];
    //BackButtonInterceptor.add(myInterceptor);
    fetchProductList();
    fetchWishList();
    fetchCartList();
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
        title: Center(child: Text('Products',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>SubCategory()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>SubCategory()));
          },
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: 
      NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return null;
        },
      
        child: Stack(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: themColor,

              child: Align(
                alignment: Alignment.topCenter,

                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child:Row(
                    children: [

                      //////////// Search Bar Start
                      InkWell(
                        onTap: (){
                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
                        } ,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                            
                            height: 35,
                            width: MediaQuery.of(context).size.width-120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Colors.redAccent, spreadRadius: 2),
                              ],
                            
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Row(
                                children: [
                                  Icon(Icons.search,color: Colors.black45, size: 20,),
                                  Text("Search here..", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),),
                                ],
                              ),
                            ),
                      
                          ),
                        ),
                      ),
                      ///////////// Search Bar end,
                  
                      // Container(
                      //   width: MediaQuery.of(context).size.width-100,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       IconButton(
                      //             icon: Icon(Icons.search,color: Colors.white,size: 30,),
                      //             onPressed: (){
                      //               //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
                      //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
                      //             },
                      //       ),
                      //     ]
                      //   ) 
                      // ),   
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              color: themColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:[
                                  Padding(
                                    padding: EdgeInsets.only(right:2),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> WishList()));
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 80,
                                        child: Stack(
                                          children: <Widget>[
                                            Icon(Icons.favorite,color: Colors.white,size: 40),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                                child: Center(
                                                  child: Text(cartWishListCount.toString()),
                                                ),
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> Cart()));
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 80,
                                        child: Stack(
                                          children: <Widget>[
                                            Icon(Icons.shopping_cart,color: Colors.white,size: 40),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
                                                child: Center(
                                                  child: Text(cartBadgeCount.toString()),
                                                ),
                                              )
                                            )
                                          ]
                                        )
                                      ),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ]
                        ),
                      ),
                    ]  
                  ),
                ),
          
                
              ),

                    // child: Align(
              //   alignment: Alignment.topCenter,

              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child:Row(
              //       children: [
                  
              //         Container(
              //           width: MediaQuery.of(context).size.width-100,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               IconButton(
              //                     icon: Icon(Icons.search,color: Colors.white,size: 30,),
              //                     onPressed: (){
              //                       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
              //                       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Search()));
              //                     },
              //               ),
              //             ]
              //           ) 
              //         ),   
              //         Container(
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Container(
              //                 height: 50,
              //                 color: themColor,
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   children:[
              //                     Padding(
              //                       padding: EdgeInsets.only(right:2),
              //                       child: InkWell(
              //                         onTap: (){
              //                           Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> WishList()));
              //                         },
              //                         child: Container(
              //                           width: 40,
              //                           height: 80,
              //                           child: Stack(
              //                             children: <Widget>[
              //                               Icon(Icons.favorite,color: Colors.white,size: 40),
              //                               Align(
              //                                 alignment: Alignment.topRight,
              //                                 child: Container(
              //                                   width: 25,
              //                                   height: 25,
              //                                   decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
              //                                   child: Center(
              //                                     child: Text(cartWishListCount.toString()),
              //                                   ),
              //                                 )
              //                               )
              //                             ]
              //                           )
              //                         ),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: EdgeInsets.only(right: 10),
              //                       child: InkWell(
              //                         onTap: (){
              //                           Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> Cart()));
              //                         },
              //                         child: Container(
              //                           width: 40,
              //                           height: 80,
              //                           child: Stack(
              //                             children: <Widget>[
              //                               Icon(Icons.shopping_cart,color: Colors.white,size: 40),
              //                               Align(
              //                                 alignment: Alignment.topRight,
              //                                 child: Container(
              //                                   width: 25,
              //                                   height: 25,
              //                                   decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
              //                                   child: Center(
              //                                     child: Text(cartBadgeCount.toString()),
              //                                   ),
              //                                 )
              //                               )
              //                             ]
              //                           )
              //                         ),
              //                       ),
              //                     ),
              //                   ]
              //                 ),
              //               ),
              //             ]
              //           ),
              //         ),
              //       ]  
              //     ),
              //   ),

              // child: Align(
              //   alignment: Alignment.topRight,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       InkWell(
              //         onTap: (){
              //           Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> WishList()));
              //         },
              //         child: Container(
              //           height: 50,
              //           color: themColor,
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children:[
              //               Padding(
              //                 padding: EdgeInsets.only(right:2),
              //                 child: Container(
              //                   width: 40,
              //                   height: 80,
              //                   child: Stack(
              //                     children: <Widget>[
              //                       Icon(Icons.favorite,color: Colors.white,size: 40),
              //                       Align(
              //                         alignment: Alignment.topRight,
              //                         child: Container(
              //                           width: 25,
              //                           height: 25,
              //                           decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
              //                           child: Center(
              //                             child: Text(cartWishListCount.toString()),
              //                           ),
              //                         )
              //                       )
              //                     ]
              //                   )
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(right: 10),
              //                 child: InkWell(
              //                   onTap: (){
              //                     Navigator.of(context,rootNavigator:false).push(MaterialPageRoute(builder: (context)=> Cart()));
              //                   },
              //                   child: Container(
              //                     width: 40,
              //                     height: 80,
              //                     child: Stack(
              //                       children: <Widget>[
              //                         Icon(Icons.shopping_cart,color: Colors.white,size: 40),
              //                         Align(
              //                           alignment: Alignment.topRight,
              //                           child: Container(
              //                             width: 25,
              //                             height: 25,
              //                             decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
              //                             child: Center(
              //                               child: Text(cartBadgeCount.toString()),
              //                             ),
              //                           )
              //                         )
              //                       ]
              //                     )
              //                   ),
              //                 ),
              //               ),
              //             ]
              //           ),
              //         ),
              //       ),
              //     ]
              //   ),

              // )
            ),

            // Padding(
            //   padding: EdgeInsets.only(top: 50,bottom: 20),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            //     ),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: Padding(
            //         padding: EdgeInsets.only(right: 20,bottom: 2),
            //         child: Text('Selling Good Quality Freesh Vegitables is Our Moto...',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w800,fontSize: 14,fontFamily: 'Open Sans',fontStyle: FontStyle.italic,),) ,
            //       ),
            //     ),
            //   )
            // ),



            // Padding(
            //   padding: EdgeInsets.only(top: 80,bottom: 20),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            //     ),
            //     child: Align(
            //       alignment: Alignment.bottomLeft,
            //       child: Padding(
            //         padding: EdgeInsets.only(left: 20,bottom: 2),
            //         child: Text('Customer wants Freesh, We provide fresh vegetables...',style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w800,fontSize: 14,fontFamily: 'Open Sans',fontStyle: FontStyle.italic,),) ,
            //       ),
            //     ),
            //   )
            // ),
            
            ////////// http start/////////////////////
            // Padding(
            //   padding: EdgeInsets.only(top: 50,),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
            //     ),

            //     child: Container(  
            //       decoration: BoxDecoration(),
            //       padding: new EdgeInsets.only(top: 0,),  
            //       child: Card(  
            //         shadowColor: Colors.white60,
            //         shape: RoundedRectangleBorder(  
            //           borderRadius: BorderRadius.circular(20.0),  
            //         ),  
            //         color: Colors.white,  
            //         elevation: 10,  
            //         child: FutureBuilder<ProductListModel>(
            //           future: httpService.getPost(),
            //           builder:(BuildContext context,AsyncSnapshot<ProductListModel> snapshot){

            //             if (snapshot.hasData) {
            //               ProductListModel homeModel = snapshot.data;
            //               return ListView(
            //                 //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8, mainAxisSpacing: 4),
            //                 padding: EdgeInsets.all(1),
            //                 shrinkWrap: true,
            //                 scrollDirection: Axis.vertical,
            //                 children: homeModel.data.map((data) => 
            //                   ListTile(
            //                     title: Padding(
            //                       padding: EdgeInsets.only(bottom: 1,top: 10),
            //                       child: InkWell(
            //                         splashColor: themColor,
            //                         onTap: (){
            //                           //print(data.id.toString());
            //                           ProductList.productId=data.id.toString();
            //                           Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ItemList()));
            //                         },
            //                         child: Column(
            //                           children: [
            //                             Card(
            //                               shadowColor: Colors.black54,
            //                               shape: RoundedRectangleBorder(  
            //                                 borderRadius: BorderRadius.circular(0.0),  
            //                               ),  
            //                               elevation: 2,
            //                               child: Container(
            //                                 width: MediaQuery.of(context).size.width,
            //                                 height: MediaQuery.of(context).size.height/9.5, // for cutting image
            //                                 child: Row(
            //                                   mainAxisAlignment: MainAxisAlignment.start,
            //                                   children: [
            //                                     Container(
            //                                       width: MediaQuery.of(context).size.width/6,
            //                                       height: MediaQuery.of(context).size.height/9.5,
            //                                       child: ClipRRect(
            //                                         borderRadius: BorderRadius.circular(0.0),
            //                                         child: Image.network(data.image,
            //                                         fit: BoxFit.cover,
            //                                         alignment: Alignment.centerLeft,
            //                                         ),
                                                  
            //                                       ),
            //                                     ),
            //                                   // Image.network(data.image,height: 100,),
                                                

            //                                     Padding(
            //                                       padding: EdgeInsets.only(top: 5,left: 5),
            //                                       child:Container(
            //                                         // width: MediaQuery.of(context).size.width/1.4,
                                                    
            //                                         color: Colors.white,
            //                                         child:Row(
            //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                           children: [

            //                                             Column(
            //                                               crossAxisAlignment: CrossAxisAlignment.start,
            //                                               mainAxisAlignment: MainAxisAlignment.start,
            //                                               children: [
            //                                                 Row(
            //                                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                                   children: [
            //                                                   // Icon(Icons.keyboard_arrow_right_outlined),
            //                                                     //Text("Product: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                
            //                                                       Row(
            //                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                                                         children: [
            //                                                           Container(
            //                                                             width: MediaQuery.of(context).size.width-150,
            //                                                             child: SingleChildScrollView(
            //                                                               scrollDirection: Axis.horizontal,
            //                                                               child: Text(data.name,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
            //                                                             ),
            //                                                           ),
            //                                                           Icon(Icons.keyboard_arrow_right_rounded,color: Colors.black54,size: 30,)
            //                                                         ]  
            //                                                       ),
                                                                
            //                                                     //Text(data.name,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
            //                                                     // SizedBox(
            //                                                     //   width: 20,
            //                                                     // ),
            //                                                   // Icon(Icons.keyboard_arrow_right_outlined),
            //                                                   ],
            //                                                 ),
            //                                                 Row(
            //                                                   children: [
            //                                                     //Text("Product Of: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
            //                                                     SingleChildScrollView(
            //                                                       scrollDirection: Axis.horizontal,
            //                                                       child: Text(data.subcategoryname,style: TextStyle(color:Colors.grey,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
            //                                                     ),
            //                                                   ],
            //                                                 ),
            //                                                 // Row(
            //                                                 //   children: [
            //                                                 //     Text("Description: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
            //                                                 //     SingleChildScrollView(
            //                                                 //       scrollDirection: Axis.horizontal,
            //                                                 //       child: Padding(
            //                                                 //         padding: EdgeInsets.only(left: 10,top: 0),
            //                                                 //         child: Text(data.description.toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black38,fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: "RaleWay"))
            //                                                 //       )
            //                                                 //     ),
            //                                                 //   ],
            //                                                 // )
                                                            
            //                                                 // Text("gold milk",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
            //                                                 // Text("Quantity : 1",style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
            //                                                 // Icon(Icons.favorite,color: Colors.red,)
            //                                               ],
            //                                             ),

            //                                           ]
            //                                         )    
            //                                       )
            //                                     ),
                                              
            //                                   ],
            //                                   //child: Text(data.name)
            //                                 ),
            //                               )
            //                             ),

            //                             // Divider(
            //                             //   color: Colors.black54,
            //                             // )
            //                           ]  
            //                         ),
            //                       ),
            //                     ),
            //                     // subtitle: Card(
            //                     //   elevation: 10,
            //                     //   child: Text(data.description),
            //                     // ),
            //                   ))
            //                   .toList()
            //               );
            //             }

                       
            //             return Center(
            //               child: CircularProgressIndicator()
            //               // child: Column(
            //               //   mainAxisAlignment: MainAxisAlignment.center,
            //               //   children: [
            //               //     Image.asset("assets/images/empty_orders.png"),
            //               //     SizedBox(height: 10,),
            //               //     Text('Sorry ! No Products Found !!',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 18)),
            //               //   ],
            //               // )
            //             );

      
            //           } //builder
            //         )

                  
            //       ),  

            //     ),
            //   )
            // )

            ////////// http end/////////////////////
            

            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: isLoading
                // ? new Center(child: new CircularProgressIndicator()) :
                ? shimmerEffect():
                    
                  
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child:  ListView.builder(
                    itemCount: showProductList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: 
                
                        Stack(
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/9.5,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10,top: 2),
                                    child: Text(showProductList[index]['name'].toString(),overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                  ),

                                  InkWell(
                                    onTap: (){
                                      ProductList.productId=showProductList[index]['id'].toString();

                                      print("Product id ++++++++++++++++++++++++++"+ProductList.productId.toString());
                                      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ItemList()));
                                    },
                                    child: Icon(Icons.arrow_forward,color: Colors.white,)
                                  )
                                  // Expanded(
                                  //   child: SingleChildScrollView(
                                  //     scrollDirection: Axis.horizontal,
                                  //     child: Padding(
                                  //       padding: EdgeInsets.only(left: 20,top: 5),
                                  //       child: Text(showProductList[index]['name'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
                                  //   ),
                                  // ),
                                ]
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Container(
                                height: MediaQuery.of(context).size.height/5,
                                child: Card(
                                  shadowColor: Colors.black38,
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 8,
                                  margin:EdgeInsets.only(left: 5,right: 5) ,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                    child: Column(
                                      children:[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                      
                                            Container(
                                              width: MediaQuery.of(context).size.width/6,
                                              height: 80,
                                              // child: ClipRRect(
                                              //   borderRadius: BorderRadius.circular(0.0),
                                                child: Image.network(showProductList[index]['image'],fit: BoxFit.cover,)
                                                // child: Image.asset("assets/images/item_icon.png",
                                                //   height: 60,
                                                //   // fit: BoxFit.cover,
                                                //   // alignment: Alignment.centerLeft,
                                                // )
                                              //),
                                            ),

                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  MergeSemantics(
                                                    child: Row(
                                                      children: <Widget>[
                                                        // Icon(
                                                        //   Icons.crop_square,
                                                        //   color: Colors.black45,
                                                        //   size: 18,
                                                        // ),
                                                        Flexible(
                                                          child: Text(
                                                            'Description:',
                                                            overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black54),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  
                                                  Text(showProductList[index]['description'].toString(),overflow: TextOverflow.visible,maxLines: 3,style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                ],
                                              ),
                                            ),

                                            

                                            // Container(
                                            //   child: Column(
                                            //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //     children: [
                                            //       Text("Description: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //       Flexible(child: Text(showProductList[index]['description'].toString(),overflow: TextOverflow.visible,style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                            //     ],
                                            //   ),
                                            // ),
                                      
                                            
                                    
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: ElevatedButton(
                                                child: Icon(Icons.arrow_forward,color: Colors.white,),
                                                // icon: Icon(Icons.keyboard_arrow_right_rounded,color: Colors.white,),
                                                // label: Text('', style: TextStyle(color: Colors.white),),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.black54,
                                                  onPrimary: Colors.white,
                                                  shadowColor: Colors.white60,
                                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  elevation: 10,
                                                ),
                                                onPressed: () async{
                                                  ProductList.productId=showProductList[index]['id'].toString();

                                                  print("Product id ++++++++++++++++++++++++++"+ProductList.productId.toString());
                                                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ItemList()));
                                                },
                                                      
                                              ),
                                            ),
                                          ]
                                        ),
                  
                                       
                                            
                                      ]  
                                    ),
                                  ) 
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
            )
            
          ]
        ) 
      )  
      
    );
  }

  Widget shimmerEffect(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: Shimmer.fromColors(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context,index){
            return ListTile(
              // leading: Icon(Icons.image,size: 50,),
              title: Stack(
                children: [ 

                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height/9,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20,left: 5,right: 5),

                    child: Container(
                      height: MediaQuery.of(context).size.height/4,
                      width: double.infinity,
                      color: Colors.black12,
                      // alignment: Alignment.bottomCenter,
                        
                        child: Column(
                          children: [

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,top: 20),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.black87,
                                  ),
                                ),

                                SizedBox(
                                  width: 5,
                                ),

                                Column(
                                  children: [

                                    Container(
                                      width: 100,
                                      height: 10,
                                      color: Colors.black87,
                                    ),

                                    SizedBox(
                                      height: 2,
                                    ),

                                    Container(
                                      width: 100,
                                      height: 20,
                                      color: Colors.black87,
                                    ),

                                  

                                  ]  
                                ),

                              ],

                            ),

                            SizedBox(
                              height: 10,
                            ),
                        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    color: Colors.black87,
                                  ),
                                ),

                                
                              ],
                            ),
                          ]  
                        ),
                      ),
          
                    ),
                ]  
              )
          
            );
            
          }
        ),
        baseColor: Colors.grey, 
        highlightColor: Colors.white,
      ),
      
    );
  }
}