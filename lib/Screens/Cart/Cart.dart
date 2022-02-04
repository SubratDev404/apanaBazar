import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/AddToCartModel.dart';
import 'package:apanabazar/Screens/Address/CreateCheckOutAddress/CreateCheckOutAddress.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoItemInCart/NoItemInCart.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';





class Cart extends StatelessWidget {
  
  //static int cartPrice,cartTotalPrice;
  static int cartId,noOfItemsInCart=0,cartTotalPrice=0,inventoryId;
  //static int cartEachItemPrice,grandTotalPrice;
  static String deleteMessage;

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
     // home: CartScreen(),

    home: Scaffold(
        body: DoubleBackToCloseApp(
          child: CartScreen(),
          snackBar: const SnackBar(
            content: Text('Tap back again to close the app'),
            backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  int counter = 1;
  int nosOfItems,updateCounter;

  // void incrementCounter() {
  //   setState(() {
  //     if (counter == 99) {
  //       return null;
  //     }
  //     counter++;
  //   });
  // }

  // void decrementCounter() {
  //   setState(() {
  //     if (counter == 0) {
  //       return null;
  //     }
  //     counter--;
  //   });
  // }


  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  List showCartList = [];
  bool isLoading = true;
 // int grandTotal,finalPrice=0;

  fetchCartList() async {
   
   // var url = "https://randomuser.me/api/?results=50";
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
      
      var items = json.decode(response.body)['data'];
      var nos_of_items_in_Cart = json.decode(response.body)['itemCount'];
      var cartTotalPrice = json.decode(response.body)['carttotal'];
      Cart.noOfItemsInCart=nos_of_items_in_Cart as int;
      Cart.cartTotalPrice=cartTotalPrice as int;

     // var items2 = json.decode(response.body)['data']['variantdetails'];
      // print('cart body');
      // print(items);
      // print("items nos"+nos_of_items_in_Cart.toString());
      // print("total price "+cartTotalPrice.toString());
     // print(items2);

      
      
      setState(() {
        showCartList = items;
        isLoading = false;
        //this.grandTotal=0;
        //Cart.cartTotalPrice=grandTotal;
        // this.finalPrice=Cart.grandTotalPrice;
        // print("set state grand total /////////////////////"+finalPrice.toString());
      });

      if(showCartList.length==0){

        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInCart()));

      }
    }

    else{
      showCartList = [];
      isLoading = false;

    }
  }

  // Future<CartDeleteModel> deleteCartItemProcess() async {
  //   Cart.cartTotalPrice==0;
  //   setState(() {
  //    // total==0;
  //   });
  //   String cartDelete_url='https://api.apanabazar.com/api/cart/'+Cart.cartId.toString();
  //   final http.Response response = await http.delete(
  //       Uri.parse(cartDelete_url),
  //       headers: <String, String>{
  //         // 'Accept': 'application/json',
  //         //'Content-type': 'application/json',
  //         //'Accept': 'application/json',
  //         'Authorization': 'Bearer '+Login.token
  //       },

        
  //   );
     
  //   if (response.statusCode == 200) {
  //    // fetchCartList();
  //      print(response.body);
  //      return CartDeleteModel.fromJson(json.decode(response.body));
  //   } else {
  //     print("error enter ed");
  //   }
  // }

  deleteCartItemProcess() async {
   // print("checking...");
    var cartDelete_url='https://api.apanabazar.com/api/cart/'+Cart.cartId.toString();
    var response = await http.delete(
      Uri.parse(cartDelete_url),
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
      scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
      Cart.deleteMessage=message.toString();
      // print('//////////////////delete message/////////////////////////////');
      // print(status);
      // print(Cart.deleteMessage);
      fetchCartList();
      
    }else{
     
    }
  }

  updateCartItemProcess(int updateCounter) async {
   // print("checking...");
    var cartUpdate_url='https://api.apanabazar.com/api/cart/'+Cart.cartId.toString();
    var response = await http.put(
      Uri.parse(cartUpdate_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },

      body: json.encode({
        'inventoryId': Cart.inventoryId,
        'itemCount': updateCounter.toString(),
      }),
    );
    // print(response.body);
    if(response.statusCode == 200){
     
      var status= json.decode(response.body)['response'];
      var message= json.decode(response.body)['message'];
      scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
     // Cart.deleteMessage=message.toString();
      // print('//////////////////delete message/////////////////////////////');
      // print(status);
      // print(Cart.deleteMessage);
      fetchCartList();
      
    }else{
     
    }
  }

  Future<AddToCartModel> addToCartProcess(int updateCounter) async {
   // print("COUNTER IN =SIDE METHOD /////////////////////////////////// "+counter.toString());
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
        'inventoryId': Cart.inventoryId,
        'itemCount': updateCounter,
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
      // print(response.body);
       return AddToCartModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

     // throw Exception('Failed to create album.');
    }
  }


  TextEditingController quantityController= new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchCartList();
    //BackButtonInterceptor.add(myInterceptor);
   // grandTotal=0;
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
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Cart',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CurvedBottomNavigationBar()));
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
              color: themColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Align(
                alignment: Alignment.topCenter,

                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              width: MediaQuery.of(context).size.width/1.2,
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

                      ]  
                    ),
                  ),
                ),
          
                
              ),

            ),


            //  Padding(
            //   padding: EdgeInsets.only(top: 17),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.black54,
            //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0)),
            //     ),
            //   ),
            // ),
           
           

            Padding(
              padding: EdgeInsets.only(top: 60,bottom: 0),
              child: Container(
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(0),bottomRight: Radius.circular(0))
                ),

                child: isLoading

                //? new Center( child: new CircularProgressIndicator(),) :
                ? shimmerEffect() :

                Column(
                  children: [

                    Container(
                      height: MediaQuery.of(context).size.height*0.73,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5,bottom: 10),
                        child: ListView.builder(
                          itemCount: showCartList.length,
                          itemBuilder: (context,index){
    
                            // Cart.inventoryId=showCartList[index]['inventoryid'] as int;

                            // int noOfItems=showCartList[index]['noofitems'] as int;
                            // int salePrice=showCartList[index]['saleprice'] as int;
                            // int eachPrice= noOfItems*salePrice;
                            // Cart.cartEachItemPrice=eachPrice;
                            // grandTotal=grandTotal+Cart.cartEachItemPrice;
                            // int finalTotal=grandTotal;
                            // finalPrice=grandTotal;
                            // print("Grand Total");
                            // print(grandTotal.toString());
                            // Cart.grandTotalPrice=finalTotal;
                            
                            
                            //////////////////////////////////////////
                            //  Cart.cartPrice=showCartList[index]['mrp'] as int;
                            //  // total=total+ Cart.cartPrice*2;
                            //  print("Total Price");
                            //  print(Cart.cartPrice);
                            //  print(total.toString());
                            //  Cart.cartTotalPrice=Cart.cartPrice;
                            //  total=total+Cart.cartPrice;
                            //  print("grand total "+total.toString());
                            return ListTile(
                              title:
                              Column(
                                children: [
                                  // Container(
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(left: 2,right: 2),
                                  //     child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Text("Items: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                  //         Text("Details: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Stack(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 100,
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
                                                  child: Text(showCartList[index]['variantdetails'][0]['variantvalue'].toString(),style: TextStyle(color:Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
                                              ),
                                            ),
                                          ]
                                        ),

                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 25),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height/4,  /// Card height
                                          child: Card(
                                            shadowColor: Colors.black38,
                                            shape:RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            elevation: 8,
                                            margin:EdgeInsets.only(left: 5,right: 5),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,top: 0,right: 10),
                                              child: Column(
                                                children:[
                                                  Row(
                                                    
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/4,
                                                        height: 100,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(0.0),
                                                          child: Image.network( showCartList[index]['image'],width: 50
                                                          ,height: 100,
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment.centerLeft,
                                                          ),
                                                      
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
                                                                    width: MediaQuery.of(context).size.width/2.5,
                                                                    height: 30,
                                                                    child: Row(
                                                                      children: [
                                                                        showCartList[index]['discount'].toString() == "0" || showCartList[index]['discount'].toString() == "00" ? 
                                                                        Text("") :

                                                                        // Flexible(
                                                                        //   child: Text("",style: TextStyle(decorationColor: Colors.black54,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 25.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                        // ) : 
                                                                  
                                                                        Flexible(
                                                                          child: Text(showCartList[index]['mrp'].toString(),style: TextStyle(decorationColor: Colors.black,decorationStyle: TextDecorationStyle.solid,decoration:TextDecoration.lineThrough,color:Colors.black26,fontSize: 16.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        
                                                                        Expanded(
                                                                          child: SingleChildScrollView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            child: Text("₹"+showCartList[index]['saleprice'].toString(),style: TextStyle(color:Colors.green,fontSize: 18.0,fontWeight: FontWeight.w500,fontFamily: "Roboto"))
                                                                          ),
                                                                        ),
                                                                        

                                                                      ],
                                                                    ),
                                                                  ),
                                                                  
                                                                  showCartList[index]['discount'].toString() == "0" || showCartList[index]['discount'].toString() == "00" ? 

                                                                  Container():

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 2),
                                                                    child: Container(
                                                                      width: 40,
                                                                      height: 35,
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
                                                                                child: Text(showCartList[index]['discount'].toString() == null ? "" : showCartList[index]['discount'].toString()+"%",style: TextStyle(color:Colors.white,fontSize: 8.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                                              ),
                                                                              
                                                                              Flexible(
                                                                                child: Text("OFF",style: TextStyle(color:Colors.white,fontSize: 6.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                                                              ),
                                                                        
                                                                            ],
                                                                            
                                                                          )
                                                                        ),
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
                                                                    child: Text(showCartList[index]['noofitems'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),

                                                                  Flexible(
                                                                    child: Text(" Nos",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(height: 2),

                                                            MergeSemantics(
                                                              child: Row(
                                                                children: <Widget>[

                                                                  Flexible(
                                                                    child: Text("Made By: ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black38,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                  Flexible(
                                                                    child: Text(showCartList[index]['manufacturer'].toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(height: 2),

                                                            MergeSemantics(
                                                              child: Row(
                                                                children: <Widget>[

                                                                  Flexible(
                                                                    child: Text("Sold By: ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black38,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                  Flexible(
                                                                    child: Text(showCartList[index]['vendorname'].toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                ],
                                                              ),
                                                            ),

                                                            SizedBox(height: 2),
                                                            
                                                            showCartList[index]['noofitems'].toString()=="1" ?
                                                            
                                                            MergeSemantics() :

                                                            MergeSemantics(
                                                              
                                                              child: Row(
                                                                children: <Widget>[
                                                                
                                                                  Flexible(
                                                                    child: Text("Total Pay: ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 12.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),

                                                                  Flexible(
                                                                    child: Text(showCartList[index]['total'].toString()==null ? "": "₹"+showCartList[index]['total'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.green,fontSize: 14.0,fontWeight: FontWeight.w600,fontFamily: "Roboto")),
                                                                  ),
                                                                
                                                                ],
                                                              ),
                                                            ),
                                                          
                                                          ],
                                                        ),
                                                      ),
                                                
                                                      
                                                      // Padding(
                                                      //   padding: EdgeInsets.only(top: 0,left: 5),
                                                      //   child:Container(
                                                          
                                                      //     width: MediaQuery.of(context).size.width/2,
                                                      //     height: 100,
                                                      //     color: Colors.white,
                                                      //     child:Column(
                                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                                      //       mainAxisAlignment: MainAxisAlignment.start,
                                                      //       children: [
                                                
                                                      //         // Column(
                                                      //         //   crossAxisAlignment: CrossAxisAlignment.start,
                                                      //         //   mainAxisAlignment: MainAxisAlignment.start,
                                                      //         //   children: [

                                                      //         // Row(
                                                      //         //   mainAxisAlignment: MainAxisAlignment.start,
                                                      //         //   children: [
                                                      //         //     //Text("Product: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //         //     Expanded(
                                                      //         //       child: SingleChildScrollView(
                                                      //         //         scrollDirection: Axis.horizontal,
                                                      //         //         child: Text(showCartList[index]['itemname'],style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                      //         //       ),
                                                      //         //     ),
                                                          
                                                      //         //   ],
                                                      //         // ),

                                                      //         SizedBox(
                                                      //           height: 1,
                                                      //         ),

                                                      //         MergeSemantics(
                                                      //           child: Row(
                                                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             children: [
                                                      //               Text("Sale Price: ",style: TextStyle(color:Colors.green,fontSize: 16.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                      //               Text("₹"+showCartList[index]['saleprice'].toString().toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.green,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //             ],
                                                      //           ),
                                                      //         ),

                                                      //         MergeSemantics(
                                                      //           child: Row(
                                                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             children: [
                                                      //               Text("Discount: ",style: TextStyle(color:Colors.red,fontSize: 14.0,fontWeight: FontWeight.w500,fontFamily: "Roboto")),
                                                      //               Text("₹"+showCartList[index]['discount'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.red,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //             ],
                                                      //           ),
                                                      //         ),

                                                      //         MergeSemantics(
                                                      //           child: Row(
                                                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             children: [
                                                      //               Text("MRP: ",style: TextStyle(color:Colors.black38,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //               Text("₹"+showCartList[index]['mrp'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 16.0,fontWeight: FontWeight.w900,fontFamily: "Roboto")),
                                                      //             ],
                                                      //           ),
                                                      //         ),

                                                      //         MergeSemantics(
                                                      //           child: Row(
                                                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             children: [
                                                      //               Text("Item Nos: ",style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //               Text(showCartList[index]['noofitems'],overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //             ],
                                                      //           ),
                                                      //         ),


                                                      //         MergeSemantics(
                                                      //           child: Row(
                                                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             children: [
                                                      //               Text("Total Price: ",style: TextStyle(color:Colors.green,fontSize: 16.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                                      //               Text("₹"+showCartList[index]['total'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.green,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                      //             ],
                                                      //           ),
                                                      //         ),

                                                            
                                                            
                                                            
                                                                
                                      
                                                                  
                                      
                                                      //             // Row(
                                                      //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //             //   children: [
                                                      //             //     Text("Enter Quantity:",style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w800)),
                                                      //             //     Container(
                                                      //             //       height: 40,
                                                      //             //       width: 80,
                                                      //             //       child: Center(
                                                      //             //         child: TextField(
                                                      //             //           //textAlign: TextAlign.center,
                                                      //             //           keyboardType: TextInputType.number,
                                                      //             //           controller: quantityController,
                                                      //             //           decoration: InputDecoration(
                                                      //             //             //border: OutlineInputBorder(),
                                                      //             //             hintText: "Quantity",
                                                      //             //             // labelText: "Email or Mobile No.",
                                                                              
                                                      //             //           ),
                                                      //             //         ),
                                                      //             //       ),
                                                                        
                                                      //             //     ),
                                                      //             //     RaisedButton(
                                                      //             //       color: themColor,
                                                      //             //       child: Text('Update Quantity',style: TextStyle(color: Colors.white)),
                                                      //             //       onPressed: () async{
                                                      //             //         Cart.itemId=showCartList[index]['cartid'].toString();
                                                      //             //         // var response =await addToCartProcess();
                                                      //             //         // bool res=response.response;
                                      
                                                      //             //         // if(res==true){
                                                      //             //         //   Fluttertoast.showToast(
                                                      //             //         //     msg: response.message.toString(),
                                                      //             //         //     toastLength: Toast.LENGTH_SHORT,
                                                      //             //         //     gravity: ToastGravity.CENTER,
                                                      //             //         //     timeInSecForIosWeb: 1,
                                                      //             //         //     backgroundColor: Colors.green,
                                                      //             //         //     textColor: Colors.white,
                                                      //             //         //     fontSize: 16.0
                                                      //             //         //   );
                                                      //             //       // }
                                                      //             //       }
                                                      //             //     ),
                                                                    
                                                      //             //   ],
                                                      //             // ),
                                                      //             // Text("gold milk",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                                      //             // Text("Quantity : 1",style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                                      //             // Icon(Icons.favorite,color: Colors.red,)
                                                      //         //   ],
                                                      //         // ),
                                                              
                                                      //       ]
                                                      //     )    
                                                      //   )
                                                      // ),
                                                    ],
                                                  ),
                                      
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 0),
                                                              child: SizedBox(
                                                                height: 30,
                                                                child: ElevatedButton(
                                                                  child: Icon(Icons.delete_forever_rounded),
                                                                  // icon: Icon(Icons.delete_forever_rounded),
                                                                  // label: Text('',style: TextStyle(color: Colors.white),),
                                                                  style: ElevatedButton.styleFrom(
                                                                    primary: themColor,
                                                                    onPrimary: Colors.white,
                                                                    shadowColor: Colors.white,
                                                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                    elevation: 10,
                                                                  ),
                                                                  onPressed: () {
                                                                  // print("ok");
                                                                    Cart.cartId=int.parse(showCartList[index]['cartid']);
                                                                  //  print(WishList.wishid);
                                                                    deleteCartItemProcess();
                                                                    // Cart.cartId=showCartList[index]['cartid'];
                                                                    // print("ok");
                                                                    // var response =await deleteCartItemProcess();
                                                                    // bool res=response.response;
                                                                    // if(res==true){
                                                                    //   var message=response.message.toString();
                                                                    //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
                                                                    //   fetchCartList();
                                                                    // }
                                                                    
                                                                  }
                                                                ),
                                                              ),
                                                
                                                            ),

                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width/2,
                                                              height: 30,
                                                              child: ElevatedButton.icon(
                                                                //child: Icon(Icons.delete_forever_rounded),
                                                                icon: Icon(Icons.update),
                                                                label: Text('Update',style: TextStyle(color: Colors.white),),
                                                                style: ElevatedButton.styleFrom(
                                                                  primary: themColor,
                                                                  onPrimary: Colors.white,
                                                                  shadowColor: Colors.white,
                                                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                  elevation: 10,
                                                                ),
                                                                onPressed: () async{

                                                                  Cart.cartId=int.parse(showCartList[index]['cartid']);
                                                                  nosOfItems=int.parse(showCartList[index]['noofitems']);
                                                                  Cart.inventoryId=int.parse(showCartList[index]['inventoryid']);
                                                                  print("id "+nosOfItems.toString() );

                                                                  setState(() {
                                                                    //quantityController.clear();
                                                                    counter=nosOfItems;
                                                                  });

                                                                  showDialog(
                                                                    barrierDismissible: false,
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return StatefulBuilder(
                                                                        builder: (context, setState) {
                                                                          return Dialog(
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                                                            ),
                                                                            backgroundColor: Colors.white,
                                                                            child: Stack(
                                                                              overflow: Overflow.visible,
                                                                              alignment: Alignment.topCenter,
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.grey[200],
                                                                                    borderRadius: BorderRadius.circular(20)
                                                                                  ),
                                                                                              
                                                                                  padding: EdgeInsets.only(top: 16,left: 16,right: 16,bottom: 16),
                                                                                  margin: EdgeInsets.only(top: 40),  
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Container(
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            //Text("Last Update Quantity: ", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16), ),
                                                                                            Expanded(
                                                                                              child: SingleChildScrollView(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                child: Padding(
                                                                                                  padding: EdgeInsets.only(left: 5,top: 0),
                                                                                                  child: Text(showCartList[index]['itemname'].toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black87,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")))
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ),
                                                                                      
                                                                                      // Divider(color: Colors.white),
                                                                                      // Divider(color: Colors.white),
                                                                                      SizedBox(height: 5),
                                                                                      Container(
                                                                                        width: double.infinity,
                                                                                        height: MediaQuery.of(context).size.height *0.15,
                                                                                        decoration: new BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.circular(8),
                                                                                          boxShadow: [
                                                                                            BoxShadow(
                                                                                              color: Color(0x29000000),
                                                                                              offset: Offset(0, 3),
                                                                                              blurRadius: 6,
                                                                                              spreadRadius: 0,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        child: ListView(
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              margin: const EdgeInsets.symmetric( horizontal: 16.0),
                                                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [

                                                                                                  //////////////////// start Status /////////////////////
                                                                                                  
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(top: 5),
                                                                                                    child: Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      child: Row(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text("Last Update: ", maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'Roboto'), ),
                                                                                                          Text(nosOfItems.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle( color: Colors.black54,fontWeight:  FontWeight.bold,fontSize: 18) ),
                                                                                                        ],
                                                                                                      )
                                                                                                    ),
                                                                                                  ),

                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                                                    child: Text("Update here...",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "Roboto", fontSize: 14,color: Color(0xff454f63),fontWeight:  FontWeight.w600), ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(top: 8.0,bottom: 5),
                                                                                                    child: Container(
                                                                                                      height: 50,
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.black54,
                                                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                                                        boxShadow: [
                                                                                                          BoxShadow(
                                                                                                            color: Color(0x29000000),
                                                                                                            offset: Offset(0, 3),
                                                                                                            blurRadius: 6,
                                                                                                            spreadRadius: 0,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: <  Widget>[
                                                                                                          Padding(
                                                                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                                                            child: Icon(Icons.calculate,color: Colors.white,),
                                                                                                            //child: Icon(Icons.calculate,color: Color(0xff454f63),),
                                                                                                          ),
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets.only(right: 10),
                                                                                                            child: Container(
                                                                                                              width: MediaQuery.of(context).size.width/3,
                                                                                                              child: Row(
                                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                children:<Widget>[
                                                                                                                  Container(
                                                                                                                    height: 30,
                                                                                                                    width: 30,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      color: Colors.red,
                                                                                                                      borderRadius: BorderRadius.circular(20)
                                                                                                                    ),
                                                                                                                    child: GestureDetector(
                                                                                                                        //onTap: decrementCounter,
                                                                                                                        onTap: (){
                                                                                                                          setState(() {
                                                                                                                            if (counter == 1) {
                                                                                                                              return null;
                                                                                                                            }
                                                                                                                            counter--;
                                                                                                                            updateCounter=counter;
                                                                                                                          });
                                                                                                                        },
                                                                                                                        child: Icon(
                                                                                                                          Icons.remove_circle,
                                                                                                                          color: Colors.white,
                                                                                                                          size: 30,
                                                                                                                        )),
                                                                                                                  ),
                                                                                                                  Container(
                                                                                                                    margin: EdgeInsets.only(left: 6, right: 6),
                                                                                                                    child: Text('$counter',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white))
                                                                                                                  ),
                                                                                                                  Container(
                                                                                                                    height: 30,
                                                                                                                    width: 30,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                      color: Colors.green,
                                                                                                                      borderRadius: BorderRadius.circular(20)
                                                                                                                    ),
                                                                                                                    child: GestureDetector(
                                                                                                                      //onTap: incrementCounter,
                                                                                                                      onTap: (){
                                                                                                                        setState(() {
                                                                                                                          if (counter == 99) {
                                                                                                                            return null;
                                                                                                                          }
                                                                                                                          counter++;
                                                                                                                          updateCounter=counter;
                                                                                                                        });
                                                                                                                      },
                                                                                                                      child: Icon(
                                                                                                                        Icons.add_circle,
                                                                                                                        color: Colors.white,
                                                                                                                        size: 30,
                                                                                                                      )
                                                                                                                    ),
                                                                                                                  )
                                                                                                                ]
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),

                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                    //////////////////// end Status /////////////////////
                                                                                                ]
                                                                                              )
                                                                                            )
                                                                                          ]
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 10),

                                                                                      ButtonBar(
                                                                                        children: [

                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                            width: 50,
                                                                                            child: ElevatedButton(
                                                                                              child: Icon(Icons.cancel),
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                primary: Colors.red,
                                                                                                onPrimary: Colors.white,
                                                                                                shadowColor: Colors.black38,
                                                                                                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                                elevation: 10,
                                                                                              ),
                                                                                              // icon: Icon(Icons.cancel),
                                                                                              // label: Text('Cancel', style: TextStyle(color: themColor,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  Navigator.pop(context);
                                                                                                  //counter=1;
                                                                                                });
                                                                                                
                                                                                              }
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(
                                                                                            height: 30,
                                                                                            child: ElevatedButton.icon(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                primary: Colors.green,
                                                                                                onPrimary: Colors.white,
                                                                                                shadowColor: Colors.black38,
                                                                                                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                                elevation: 10,
                                                                                              ),
                                                                                              icon: Icon(Icons.save),
                                                                                              label: Text('Submit', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                                              onPressed: () {

                                                                                                Navigator.pop(context);
                                                                                                //addToCartProcess();
                                                                                                setState(() {
                                                                                                  
                                                                                                int updateCounter1=counter;
                                                                                                //  print("update counter >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>s "+updateCounter.toString());
                                                                                                  updateCartItemProcess(updateCounter1);
                                                                                                });

                                                                                                
                                                                                              }
                                                                                            ),
                                                                                          ),
                                                                        
                                                                                        ]
                                                                                      )
                                                                                    ]
                                                                                  )
                                                                                ),
                                                                                Positioned(
                                                                                  top: -60,
                                                                                  // child: Image.network( showCartList[index]['image'],height: 80,
                                                                                  //   fit: BoxFit.cover,
                                                                                  //   alignment: Alignment.centerLeft,
                                                                                  // ),
                                                                                  child: CircleAvatar(
                                                                                    backgroundColor: Colors.white,
                                                                                    radius: 50,
                                                                                    child: CircleAvatar(
                                                                                      backgroundColor: Colors.transparent,
                                                                                      radius: 45,
                                                                                      child: Image.network( showCartList[index]['image'],height: 60,
                                                                                        // fit: BoxFit.cover,
                                                                                        // alignment: Alignment.centerLeft,
                                                                                      ),
                                                                                      // child: Icon(Icons.update_outlined,size: 80,color: themColor,),
                                                                                      
                                                                                      // child: Image.asset(
                                                                                      //   "assets/images/update_quantity.png",color: Colors.black54,
                                                                                      //   width: 60,
                                                                                      //   height: 60,
                                                                                      // ),
                                                                                    ),
                                                                                  )
                                                                                )
                                                                              ]
                                                                            ),
                                                                          );
                                                                        } // builder
                                                                      );
                                                                    } // builder
                                                                  );
                                                              
                                                                }
                                                              ),
                                                            ),
                                                            
                                                          
                                                            
                                                          
                                                          ],
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
                                ]  
                              )

                              // children: [
                              //   ListView.builder(
                              //     shrinkWrap: true,
                              //     physics: ClampingScrollPhysics(),
                              //     itemCount: showCartList[index]['variantdetails'].length,
                              //     itemBuilder: (context,index1){
                              //       return ListTile(
                              //         title: Text(showCartList[index]['variantdetails'][index1]['variantname'].toString()),
                              //       );
                              //     })
                              // ],
                            );
                          }
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 5,right: 5),
                    //   child: Container(
                    //     height: MediaQuery.of(context).size.height*0.1,
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                    //       color: Colors.white,
                    //       boxShadow: [
                    //         BoxShadow(color: Colors.black12, spreadRadius: 2),
                    //       ]
                    //     ),
                    //     child: Row(
                    //       children: [

                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 2),
                    //           child: Container(
                    //             color: Colors.white,
                    //             height: MediaQuery.of(context).size.height/8.5,
                    //             width: MediaQuery.of(context).size.width/1.8,

                    //             child: Row(
                    //               children:[
                    //                 SizedBox(
                    //                   width: 5,
                    //                 ),
                                    
                    //                 Container(
                    //                   // width: MediaQuery.of(context).size.width/6,
                    //                   // child: Expanded(
                    //                   //   child: SingleChildScrollView(
                    //                     //  scrollDirection: Axis.horizontal,
                    //                       child: Flexible(child: Text(Cart.noOfItemsInCart.toString()+"Nos",overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w900,fontFamily: "Roboto")))
                    //                   //   ),
                    //                   // ),
                    //                 ),

                    //                 SizedBox(
                    //                   width: 5,
                    //                 ),
                                    
                    //                 Container(
                    //                 //  width: 100,
                    //                   // child: Expanded(
                    //                   //   child: SingleChildScrollView(
                    //                   //     scrollDirection: Axis.horizontal,
                    //                       child: Flexible(child: Text("₹"+Cart.cartTotalPrice.toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w900,fontFamily: "Roboto")))
                    //                   //   ),
                    //                   // ),
                    //                 ),
                                    
                    //               ]
                                  
                    //             ),
                    //           ),
                    //         ),
                           
                            
                              
                    //         SizedBox(
                    //           width: MediaQuery.of(context).size.width/3,
                    //           height: 30,
                    //           child: ElevatedButton.icon(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: themColor,
                    //               onPrimary: Colors.white,
                    //               shadowColor: Colors.black45,
                    //               shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    //               elevation: 10,
                    //             ),
                    //             icon: Icon(Icons.shopping_cart),
                    //             label: Text('Checkout', style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                    //             onPressed: () {
                    //               //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ChooseAddress()));
                    //               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CreateCheckOutAddress()));
                    //             }
                    //           ),
                    //         ),
                              
                            
                            
                    //       ],
                    //     ),
                    //   ),
                    // )


                  ]  
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, spreadRadius: 2),
                  ]
                ),
                child: Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height/8.5,
                        width: MediaQuery.of(context).size.width*0.6,

                        child: Row(
                          children:[
                            SizedBox(
                              width: 5,
                            ),
                            
                            Container(
                              width: MediaQuery.of(context).size.width/6,
                             // height: double.infinity,
                              color: Colors.white,
                              // child: Expanded(
                              //   child: SingleChildScrollView(
                                //  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text(Cart.noOfItemsInCart.toString()+"Nos",overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w900,fontFamily: "Roboto"))
                                  )
                              //   ),
                              // ),
                            ),

                            SizedBox(
                              width: 1,
                            ),
                            
                            Container(
                              color: Colors.white,
                             // height: double.infinity,
                              width: MediaQuery.of(context).size.width/2.5,
                              // child: Expanded(
                              //   child: SingleChildScrollView(
                              //     scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text("₹"+Cart.cartTotalPrice.toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w900,fontFamily: "Roboto"))
                                  )
                              //   ),
                              // ),
                            ),
                            
                          ]
                          
                        ),
                      ),
                    ),
                    
                    
                      
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2.8,
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: themColor,
                          onPrimary: Colors.white,
                          shadowColor: Colors.black45,
                          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                          elevation: 10,
                        ),
                        icon: Icon(Icons.shopping_cart),
                        label: Text('Checkout', style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                        onPressed: () {
                          //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>ChooseAddress()));
                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CreateCheckOutAddress()));
                        }
                      ),
                    ),
                      
                    
                    
                  ],
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
                                      height: 5,
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