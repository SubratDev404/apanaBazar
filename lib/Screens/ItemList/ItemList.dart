import 'dart:convert';
import 'dart:io';

import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/AddToCartModel.dart';
import 'package:apanabazar/Model/AddToWishListModel.dart';
import 'package:apanabazar/Model/ItemListModel.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemsInItemList/NoItemInItemList.dart';
import 'package:apanabazar/Screens/ProductList/ProductList.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
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

class ItemList extends StatelessWidget {
  static String addToWishlistId,addToCartListId;

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
      home: ItemListScreen(),
    );
  }
}

class ItemListScreen extends StatefulWidget {
 

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {

  
  int cartWishListCount=0;
  int cartBadgeCount=0;
  bool isLoading=true;
  List showItemList; 

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<ItemListModel> getItems() async {
    String itemList_url='https://api.apanabazar.com/api/itemlist/'+ProductList.productId.toString();

    //print(userid); print(token);print(userToken);
    final http.Response response = await http.get(
      Uri.parse(itemList_url),
      headers: <String, String>{
        'Accept': 'application/json',
      },
      
    );

    if (response.statusCode == 200) {
     //  print("category body....."+response.body);
     //fList<BrandModel> list = BrandModel.parseBrands(response.body);
        print(' item body+++++++++++++++++++++++++++++++++++');
        print(response.body);
        // print(response.body.length);
        bool res=json.decode(response.body)['response'];
        var items=json.decode(response.body)['items'] ?? []; // if no json array come, default array will pass to model

        setState(() {
          showItemList=items;
          isLoading=false;
        });

        if(res==false){
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInItemList()));
        }

        json.decode(response.body);

        // final jsonList=json.decode(response.body) as List;
        // print("jsonlist >>>>"+jsonList.toString());
        
      return ItemListModel.fromJson(json.decode(response.body));
    } 
    else {
      throw Exception('Failed to load album');
    }
  }

  Future getData() async{
   // print("getting user token");
    response=await getItems();
   // print("response >>>>>"+response.toString());
    return response.data;
  }

  Future<List> _getItemsList() async{
    var data=await getData();
    print("response >>>>>"+data.toString());
    return data;
  }

  Future<AddToWishListModel> addToWishListProcess() async {
    const addToCart_url='https://api.apanabazar.com/api/wishlist';
    final http.Response response = await http.post(
        Uri.parse(addToCart_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer '+WelcomeScreen.userToken
        },

         body: json.encode({
          'itemId': ItemList.addToWishlistId.toString(),
          'isNotified': '0',
        }),
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
      fetchWishList();

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
      // print(response.body);
       return AddToWishListModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }

  Future<AddToCartModel> addToCartProcess() async {
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
        'inventoryId': ItemList.addToCartListId.toString(),
        'itemCount': "1",
      }),
       
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {
      fetchCartList();
      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('login body');
     //  print(response.body);
       return AddToCartModel.fromJson(json.decode(response.body));
    } else {
    //  print("error enter ed");

     // throw Exception('Failed to create album.');
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
    showItemList=[];
    //BackButtonInterceptor.add(myInterceptor);
    fetchWishList();
    fetchCartList();
    getData();
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



  var response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: themColor,

      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Item List',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ProductList()));
          },
        ),
      ),
      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: NotificationListener<OverscrollIndicatorNotification>(
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
                  color: themColor,
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
                                  Text("Search here..", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black38,fontFamily: 'RaleWay'),),
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
              //   alignment: Alignment.topRight,
              //   child: RaisedButton(
              //     color: Colors.white,
              //     child: Text("Go To WishList",style: TextStyle(color: themColor),),
              //     onPressed: (){
              //       Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
              //     }
              //   ),
              // ),
            ),
                

            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  color: Colors.white,
                ),

                child: isLoading

               // ? new Center(child: new CircularProgressIndicator()) :
                ? shimmerEffect() :
                    
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child:  ListView.builder(
                    itemCount: showItemList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: 
                
                        Stack(
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/9,
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
                                    child: Text(showItemList[index]['variantdetails'][0]['variantvalue'].toString(),overflow: TextOverflow.ellipsis,style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                  ),

                                  // InkWell(
                                  //   onTap: (){
                                  //     ProductList.productId=showProductList[index]['id'].toString();
                                  //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ItemList()));
                                  //   },
                                  //   child: Icon(Icons.arrow_forward,color: Colors.white,)
                                  // )
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
                                height: MediaQuery.of(context).size.height/4, // card height
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
                                                child: Image.network(showItemList[index]['image'],fit: BoxFit.cover,)
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[

                                                        Container(
                                                          width: MediaQuery.of(context).size.width/3,
                                                          height: 50,
                                                          child: Row(
                                                            children: [
                                                              showItemList[index]['discount'].toString() == "0" || showItemList[index]['discount'].toString() == "00" ? 

                                                              Flexible(
                                                                child: Text("",style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ) : 
                                                        
                                                              Flexible(
                                                                child: Text(showItemList[index]['mrp'].toString(),style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Flexible(
                                                                child: Text("₹"+showItemList[index]['saleprice'].toString(),style: TextStyle(color:Colors.green,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        
                                                        showItemList[index]['discount'].toString() == "0" || showItemList[index]['discount'].toString() == "00" ? 

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
                                                                    child: Text(showItemList[index]['discount'].toString()+"%",style: TextStyle(color:Colors.white,fontSize: 10.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
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
                                                          child: Text(showItemList[index]['quantity'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
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

                                          ],
                                        ),

                                        SizedBox(height: 10,),
                                          
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            SizedBox(
                                              height: 30,
                                              child: ElevatedButton(
                                                child: Icon(Icons.favorite,color: Colors.white),
                                                // icon: Icon(Icons.favorite,color: Colors.white,),
                                                // label: Text('', style: TextStyle(color: Colors.white),),
                                                style: ElevatedButton.styleFrom(
                                                  primary: themColor,
                                                  onPrimary: Colors.white,
                                                  shadowColor: Colors.white54,
                                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  elevation: 10,
                                                ),
                                          
                                                onPressed: () async{
                                                // print("id");
                                                  ItemList.addToWishlistId=showItemList[index]['itemvariantid'].toString();
                                                  print(ItemList.addToWishlistId);
                                                  var response=await addToWishListProcess();
                                                  bool res=response.response;
                                                  var message=response.message.toString();
                                          
                                                  if(res==true){
                                                    scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message))); 
                                                  }
                                                  if(res==false){
                                                    scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message))); 
                                                  }
                                                }
                                              ),
                                            ),

                                            

                                            SizedBox(
                                              width: MediaQuery.of(context).size.width/2,
                                              height: 30,
                                              child: ElevatedButton.icon(
                                                icon: Icon(Icons.shopping_cart),
                                                label: Text('Add To Cart', style: TextStyle(color: Colors.white),),
                                                style: ElevatedButton.styleFrom(
                                                  primary: themColor,
                                                  onPrimary: Colors.white,
                                                  shadowColor: Colors.white54,
                                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  elevation: 10,
                                                ),
                                                onPressed: () async{
                                                //  print("id");
                                                  ItemList.addToCartListId=showItemList[index]['id'].toString();
                                                //  print(ItemList.itemlistId);
                                                  var response=await addToCartProcess();
                                                  var message = response.message.toString();
                                                  bool res=response.response;
                                                  if(res==true){
                                                    scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message))); 
                                                  }
                                                }
                                              ),
                                            ),

                                          ],
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
            

          ],
        ),
      ),  
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search_rounded),
        backgroundColor: themColor,
        onPressed: () {
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Search()));
        },
      ),
      
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