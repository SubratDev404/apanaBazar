import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/AddToCartModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/ItemList/ItemList.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInWishList/NoItemInWishList.dart';
import 'package:apanabazar/Screens/ProductList/ProductList.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';


class WishList extends StatelessWidget {
  static String itemId,wishid,deleteMessage;
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
      home: WishListScreen(),
    );
  }
}

class WishListScreen extends StatefulWidget {
  

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

    
  int cartWishListCount=0;
  int cartBadgeCount=0;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List showWishList = [];
  bool isLoading = true;

  fetchWishList() async {
    
   // var url = "https://randomuser.me/api/?results=50";
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
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      var res= json.decode(response.body)['status'];
      print('wishlist body');
      print(items);
      
      setState(() {
        showWishList = items;
        isLoading = false;
      });
      
      if(showWishList.length==0){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInWishList()));

      }

    }else{
      showWishList = [];
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


  Future<AddToCartModel> addToCartProcess() async {

    print( "////////////// wish list id/////////////////////////"+WishList.itemId.toString());
    const addToCart_url='https://api.apanabazar.com/api/cart';
    final http.Response response = await http.post(
      Uri.parse(addToCart_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken,
        'Accept': 'application/json'
      },

      body: json.encode({
        'inventoryId': WishList.itemId.toString(),
        'itemCount': "1"
      }),
       
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
       //fetchWishList();
      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
      // print(response.body);
       return AddToCartModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  deleteWishListItemProcess() async {
   // print("checking...");
    var deleteWishList_url= "https://api.apanabazar.com/api/delwishlist/"+WishList.wishid;
    var response = await http.delete(
      Uri.parse(deleteWishList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    // print(response.body);
    if(response.statusCode == 200){
     
      var status= json.decode(response.body)['response'];
      var message= json.decode(response.body)['message'];
      scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("WishList Updated Successfully"))); 
      WishList.deleteMessage=message.toString();
      // print('//////////////////delete message/////////////////////////////');
      // print(status);
      // print(WishList.deleteMessage);
      fetchWishList();
      
    }else{
     
    }
  }

  TextEditingController quantityController= new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
    this.fetchCartList();
    this.fetchWishList();
  }

  @override
  void dispose() {
    //BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    quantityController.dispose();
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
      backgroundColor: themColor,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('WishList',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
          },
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: NotificationListener<OverscrollIndicatorNotification>(  // disallow scrolling shadow
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
                            width: MediaQuery.of(context).size.width-100,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              color: themColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:[
                      
                                  
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
          
            ),

           

            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: isLoading

               // ? new Center(child: new CircularProgressIndicator(),) :
                ? shimmerEffect() :

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child:  ListView.builder(
                    itemCount: showWishList.length,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20,top: 5),
                                        child: Text(showWishList[index]['variantdetails']['variantdetails'][0]['variantvalue'].toString(),style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
                                    ),
                                  ),
                                ]
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Container(
                                height: MediaQuery.of(context).size.height/4,
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
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(0.0),
                                                child: Image.network("https://admin.apanabazar.com/assets/thumbnails/${showWishList[index]['itemimage']}256X256.jpg",width: 0,height: 60,)
                                                // child: Image.asset("assets/images/item_icon.png",
                                                //   height: 60,
                                                //   // fit: BoxFit.cover,
                                                //   // alignment: Alignment.centerLeft,
                                                // )
                                              ),
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[

                                                        Container(
                                                          width: MediaQuery.of(context).size.width/3,
                                                          height: 50,
                                                          child: Row(
                                                            children: [
                                                              showWishList[index]['disc'].toString() == "0" || showWishList[index]['disc'].toString() == "00" ? 

                                                              Flexible(
                                                                child: Text("",style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ) : 
                                                        
                                                              Flexible(
                                                                child: Text(showWishList[index]['mrp'].toString(),style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Flexible(
                                                                child: Text("₹"+showWishList[index]['saleprice'].toString(),style: TextStyle(color:Colors.green,fontSize: 20.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        
                                                        showWishList[index]['disc'].toString() == "0" || showWishList[index]['disc'].toString() == "00" ? 

                                                        Container():

                                                        Container(
                                                          width: 70,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/images/discount_sticker.png",), fit: BoxFit.fitHeight,
                                                            )
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(top: 7),
                                                              child: Column(
                                                                children: [

                                                                  Flexible(
                                                                    child: Text(showWishList[index]['disc'].toString()+"%",style: TextStyle(color:Colors.white,fontSize: 10.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                  ),
                                                                  
                                                                  Flexible(
                                                                    child: Text("OFF",style: TextStyle(color:Colors.white,fontSize: 6.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                  ),
                                                            
                                                                ],
                                                                
                                                              )
                                                            ),
                                                          ),
                                                        ),
                                                       
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(height: 2),

                                                  MergeSemantics(
                                                    child: Row(
                                                      children: <Widget>[
                                                       
                                                        Flexible(
                                                          child: Text("1",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                        ),

                                                        Flexible(
                                                          child: Text(" Nos",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                        ),
                                                       
                                                      ],
                                                    ),
                                                  ),
                                                 
                                                ],
                                              ),
                                            ),
                                      
                                            
                                            // Padding(
                                            //   padding: EdgeInsets.only(top: 10,left: 5),
                                            //   child:Container(
                                            //     width: MediaQuery.of(context).size.width/1.6,
                                            //     //width: 280,
                                            //     height: 70,
                                            //     color: Colors.white,
                                            //     child: Column(
                                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                            //       mainAxisAlignment: MainAxisAlignment.start,
                                            //       children: [
                                      
                                            //         Column(
                                            //           crossAxisAlignment: CrossAxisAlignment.start,
                                            //           mainAxisAlignment: MainAxisAlignment.start,
                                            //           children: [

                                            //             MergeSemantics(
                                            //               child: Row(
                                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //                 children: [
                                            //                   Text("Sale Price: ",style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                            //                   Text("₹"+showWishList[index]['saleprice'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.green,fontSize: 22.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //                 ],
                                            //               ),
                                            //             ),

                                            //             MergeSemantics(
                                            //               child: Row(
                                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //                 children: [
                                            //                   Text("Discount: ",style: TextStyle(color:Colors.red,fontSize: 16.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                            //                   Text(showWishList[index]['disc'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //                 ],
                                            //               ),
                                            //             ),
                                                       

                                            //             MergeSemantics(
                                            //               child: Row(
                                            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //                 children: [
                                            //                   Text("MRP: ",style: TextStyle(color:Colors.black38,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //                   Text("₹"+showWishList[index]['mrp'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //                 ],
                                            //               ),
                                            //             ),

                                                        
                                            //             // Text("gold milk",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                            //             // Text("Quantity : 1",style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                            //             // Icon(Icons.favorite,color: Colors.red,)
                                            //           ],
                                            //         ),
                                      
                                            //       ]
                                            //     )    
                                            //   )
                                            // ),

                                          ],
                                        ),
                  
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                child: ElevatedButton(
                                                  child: Icon(Icons.delete_forever_rounded),
                                                    // icon: Icon(Icons.delete_forever_rounded),
                                                    // label: Text('', style: TextStyle(color: Colors.white),),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: themColor,
                                                      onPrimary: Colors.white,
                                                      shadowColor: Colors.white60,
                                                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                      elevation: 10,
                                                    ),
                                                    onPressed: () {
                                                      //print("ok");
                                                      WishList.wishid=showWishList[index]['wishid'].toString();
                                                    // print(WishList.wishid);
                                                      deleteWishListItemProcess();
                                                      // print("id");
                                                      // WishList.wishid=showWishList[index]['wishid'].toString();
                                                      // // print("))))))))))))))))))))))))))))) "+WishList.wishid);
                                                      // WishList.itemId=showWishList[index]['itemid'].toString();
                                                      // print(ItemList.itemlistId);
                                                      // var response=await addToCartProcess();
                                                      // bool res=response.response;
                                                      // if(res==true){
                                                      //
                                                      //   deleteWishListItemProcess();
                                                      //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully")));
                                                      // }
                                                    }
                                                ),
                                              ),
                                              // InkWell(
                                              //   child: Row(
                                              //     children: [
                                              //       Text("Delete",style: TextStyle(color:themColor,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                              //       Image.asset('assets/images/delete_icon.png',color: themColor,height: 30,)
                                              //     ]
                                              //   ),
                                              //   onTap: () {
                                              //     print("ok");
                                              //     WishList.wishid=showWishList[index]['wishid'].toString();
                                              //     print(WishList.wishid);
                                              //     deleteWishListItemProcess();
                                              //     //fetchWishList();
                                              //   },
                                              // ),

                                              

                                              SizedBox(
                                                width: MediaQuery.of(context).size.width/2,
                                                height: 30,
                                                child: ElevatedButton.icon(
                                                  icon: Icon(Icons.shopping_cart),
                                                  label: Text('Add To Cart', style: TextStyle(color: Colors.white),),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: themColor,
                                                    onPrimary: Colors.white,
                                                    shadowColor: Colors.white60,
                                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    elevation: 10,
                                                  ),
                                                  onPressed: () async{
                                                  //  print("id");
                                                    WishList.wishid=showWishList[index]['wishid'].toString();
                                                   print("))))))))))))))))))))))))))))) "+WishList.wishid);
                                                    WishList.itemId=showWishList[index]['invid'].toString();
                                                    print("))))))))))))))))))))))))))))) "+WishList.wishid);
                                                    print("))))))))))))))))))))))))))))) "+WishList.itemId);
                                                  //  print(ItemList.itemlistId);
                                                    var response=await addToCartProcess();
                                                    bool res=response.response;
                                                    if(res==true){
                                                      fetchCartList();
                                                      deleteWishListItemProcess();
                                                      scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(" Added to Cart Successfully"))); 
                                                    }
                                                  }
                                                ),
                                              ),
                  
                                            ],
                                          ),
                                        )
                                            
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
          ],
          
        ),
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
                      color: Colors.black,
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
                                      height: 15,
                                      color: Colors.black87,
                                    ),

                                    SizedBox(
                                      height: 2,
                                    ),

                                    Container(
                                      width: 100,
                                      height: 5,
                                      color: Colors.black87,
                                    ),

                                    SizedBox(
                                      height: 2,
                                    ),


                                    Container(
                                      width: 100,
                                      height: 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    color: Colors.black87,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 200,
                                    height: 30,
                                    color: Colors.black87,
                                  ),
                                )
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