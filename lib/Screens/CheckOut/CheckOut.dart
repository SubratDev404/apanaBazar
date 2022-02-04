import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Model/CodModel.dart';
import 'package:apanabazar/Model/OnlinePaymentModel.dart';
import 'package:apanabazar/Model/PayUMoneyCredentials.dart';
import 'package:apanabazar/Screens/Address/AddressList/AddressList.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/PayUmoney/PayUmoney.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/SuccessPage/OrderPlaced.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CheckOut extends StatelessWidget {

  static int noOfItemsInCart,cartTotalPrice,addressListId,selectedAddressId,base64Encoded;
  static String cartItemDetails,merchantOrderNo,transcationId,amount;

  static String payUMoneyKey,payUMoneyTxnid,payUMoneyProductinfo,payUMoneyFirstname,payUMoney,payUMoneyEmail,payUMoneySurl,payUMoneyFurl,payUMoneyHash,payUMoneyUdf1,payUMoneyUdf2;
  static String payUMoneyPhone;
  static int payUMoneyAmount;

  static int radioButtonid=1;


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
      home: CheckOutHome(),
    );
  }
}

class CheckOutHome extends StatefulWidget {
  

  @override
  _CheckOutHomeState createState() => _CheckOutHomeState();
}

class PaymentModeList {
  String paymentMode,imageUrl;
  int index;
  PaymentModeList({this.paymentMode,this.index});
}

class _CheckOutHomeState extends State<CheckOutHome> {



  // Phone Pe Start
  int amountFinal;
  var base64EncodedValueFinal,sha256ConvertedValueFinal,checkSumFinal;
  // checking PhonePe is available in your real Device start
  static const platform = const MethodChannel('flutter.native/helper');
  String _responseFromNativeCode = 'Waiting for Response...';
  Future<void> responseFromNativeCode() async {
    String response = "";
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode');
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {
      _responseFromNativeCode = response;
    });

    Fluttertoast.showToast(
        msg: _responseFromNativeCode.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  // checking PhonePe is available in your real Device end

  Future<OnlinePaymentModel> onLinePaymentProcess(String token,String userId,String deliveryId) async {
    // print('PhonePe/////////////////////////////////////////');
    // print("p token "+token);
    // print("p userId "+userId);
    // print("p deliveryId "+deliveryId);
    const onLinePayment_url='https://apanabazar.com/Gateway/online_payment_api';
    final http.Response response = await http.post(
      Uri.parse(onLinePayment_url),
      // headers: <String, String>{
      //   // 'Accept': 'application/json',
      //   //'Content-type': 'application/json',
      //   'Accept': 'application/json'
      // },



      body: {
        'token': token,
        'userid': userId,
        'deliveryid': deliveryId,
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
    //var responsebody=jsonDecode(jsonDecode(response.body));
    //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;


      // print('//////////////////////PhonePe body////////////////////');
      // print(response.body);
      return OnlinePaymentModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

      Fluttertoast.showToast(
          msg: "Please Try Once",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );

      // throw Exception('Failed to create album.');
    }
  }


  void startPaymentTransaction() async {

    // print("checking online payment value...........");
    // print(base64EncodedValueFinal);
    // print(checkSumFinal);
    var data = < String,
        dynamic > {
      //  "base64Body": base64EncodedValueFinal,
      // //"base64Body": "ewogICAgIm1lcmNoYW50SWQiOiAiVUFUTUVSQ0hBTlQiLAogICAgInRyYW5zYWN0aW9uSWQiOiAiVFgxMjM0NTY3ODkwIiwKICAgICJhbW91bnQiOiAxLAogICAgIm1lcmNoYW50T3JkZXJJZCI6ICJPRDEyMzQiLAp9",
      // //"base64Body": "ewogICAgIm1lcmNoYW50SWQiOiAiVUFUTUVSQ0hBTlQiLAogICAgInRyYW5zYWN0aW9uSWQiOiAiVFgxMjM0NTY3ODcwIiwKICAgICJhbW91bnQiOiAxLAogICAgIm1lcmNoYW50T3JkZXJJZCI6ICJPRDEyNjQiLAp9",
      // "checksum": "7fd77b77c1f60ff0131ade1e9a7c1ac4e612fc4f2707101d046d4e67b14effed###1",
      // "apiEndPoint": "/v4/debit",
      // "x-callback-url": ""

    "base64Body":base64EncodedValueFinal.toString(),
    "checksum": checkSumFinal.toString(),
    "apiEndPoint": "/v4/debit",
    "x-callback-url": "https://apanabazar.com/Gateway/call_back"

    };
    String uiCallbackValue;
    try {
      uiCallbackValue = await platform.invokeMethod("startPaymentTransaction", data);
     // deleteCartItemProcess();
    //  PhonePeNotification();
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
    } catch (e) {
     // print(e);
    }
    //print("Phone Pe Success >>>>>>>>>>>>>>>>>"+uiCallbackValue);

  }

  // Phone Pe End

  // deleteCartItemProcess() async {
  //   print("checking...");
  //   var cartDelete_url='https://api.apanabazar.com/api/cart/'+Cart.cartId.toString();
  //   var response = await http.delete(
  //     Uri.parse(cartDelete_url),
  //     headers: <String, String>{
  //         // 'Accept': 'application/json',
  //         //'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer '+WelcomeScreen.userToken
  //     },
  //   );
  //   // print(response.body);
  //   if(response.statusCode == 200){
     
  //     // var status= json.decode(response.body)['response'];
  //      var message= json.decode(response.body)['message'];
  //     // scaffoldKey.currentState.showSnackBar(SnackBar(content:Text(message.toString()))); 
  //     // WishList.deleteMessage=message.toString();
  //      print('//////////////////delete message/////////////////////////////');
  //      print(message.toString());
  //     // print(WishList.deleteMessage);
  //     fetchCartList();
      
  //   }else{
     
  //   }
  // }
  



 

  bool isLoading = false;

  //String loadAddresssUrl = "https://api.apanabazar.com/api/deliveryaddress";
   // for dropdown
 // List addressList = List();
 //String selectedListAddressId;

  // ////////// start api set up for status calling
  // Future getAddressList() async {
  //   await http.get(Uri.parse(loadAddresssUrl),
  //   headers: <String, String>{
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer '+Login.token
  //   },).then((response) {
  //     var jsonBody = response.body;
    
  //     var jsonData = json.decode(jsonBody);
  //     setState(() {
  //       addressList = jsonData['data'];
  //     });
  //   });
  // }
  // ////////// end api set up for status calling
  
  int addressid; // fpor address getting
  List selectedAddressList = [];
  fetchSelectedAddress() async {
    setState(() {
      isLoading = true;
    });
   // var url = "https://randomuser.me/api/?results=50";
    var selectedAddressList_url= "https://api.apanabazar.com/api/daddress/"+AddressList.addressListItemId.toString();
    var response = await http.get(
      Uri.parse(selectedAddressList_url),
      headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+WelcomeScreen.userToken
      },
    );
    // print(response.body);
    if(response.statusCode == 200){
      var selectedAddress = json.decode(response.body);
    
      
      //var res= json.decode(response.body)['response'];
      // print('selected Address body /////////////////////////////');
      // print(selectedAddress);
      
      setState(() {
        selectedAddressList=selectedAddress;
        isLoading = false;
      });

      
      // if(selectedAddressList.length==0){

      //   Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>AddressList()));

      // }

    }else{
      selectedAddressList = [];
      isLoading = false;
    }
  }

  
  List showCartList = [];
  fetchCartList() async {
    setState(() {
      isLoading = true;
     // total==0;
    });
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
      CheckOut.noOfItemsInCart=nos_of_items_in_Cart as int;
      CheckOut.cartTotalPrice=cartTotalPrice as int;
      //CheckOut.cartItemDetails=items;

     // var items2 = json.decode(response.body)['data']['variantdetails'];
      // print('body');
      // print(items);
      // print("items nos"+nos_of_items_in_Cart.toString());
      // print("total price "+cartTotalPrice.toString());
     // print(items2);
      
      setState(() {
        showCartList = items;
        isLoading = false;
 
      });


    }else{
      showCartList = [];
      isLoading = false;
    }
  }

  //////////  COD Start //////////////////

  Future<CodModel> codProcess(String token,String userId,String deliveryId) async {
    //  print('cod/////////////////////////////////////////');
    //  print("c token "+token);
    //  print("c userId "+userId);
    //  print("c deliveryId "+deliveryId);
    const cod_url='https://apanabazar.com/Gateway/cod_api';
    final http.Response response = await http.post(
        Uri.parse(cod_url),
        // headers: <String, String>{
        //   // 'Accept': 'application/json',
        //   //'Content-type': 'application/json',
        //   'Accept': 'application/json'
        // },
       
        body: {
          'token': token,
          'userid': userId,
          'deliveryid': deliveryId,
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      // print('//////////////////////COD body////////////////////');
      //  print(response.body);
       return CodModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

      Fluttertoast.showToast(
        msg: "Please Try Once",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

     // throw Exception('Failed to create album.');
    }
  }
  //////////  COD End //////////////////
  
   ////////// PayUMoney Credentials start////////////////
  Future<PayUMoneyCredentialsModel> payUmoneyCredentialsProcess(String token,String userId,String deliveryId) async {

    print("+++++++++++++++++++++++++++++++++++++"+CheckOut.selectedAddressId.toString());
 
    const payUmoney_credentials_url='https://apanabazar.com/Gateway/pay_with_payu';
    final http.Response response = await http.post(
        Uri.parse(payUmoney_credentials_url),
       
      
       
        body: {
          'key': token.toString(),
          'userid': userId.toString(),
          'deliveryid': CheckOut.selectedAddressId.toString(),
        },
       
    );
      
    if (response.statusCode == 200) {

      final responseBody=json.decode(response.body);

       print('//////////////////////PayUcREDENTIALS body first////////////////////');
      print(response.body);

      setState(() {
        CheckOut.payUMoneyKey=json.decode(response.body)['paymoney']['key'].toString();
        CheckOut.payUMoneyTxnid=json.decode(response.body)['paymoney']['txnid'].toString();
        CheckOut.payUMoneyAmount=json.decode(response.body)['paymoney']['amount'] as int;

        print("CheckOut.payUMoneyAmount >>>>>>>>>>>>>"+CheckOut.payUMoneyAmount.toString());
        CheckOut.payUMoneyProductinfo=json.decode(response.body)['paymoney']['productinfo'].toString();
        CheckOut.payUMoneyFirstname=json.decode(response.body)['paymoney']['firstname'].toString();
        CheckOut.payUMoneyEmail=json.decode(response.body)['paymoney']['email'].toString();
        CheckOut.payUMoneyPhone=json.decode(response.body)['paymoney']['phone'].toString();
        CheckOut.payUMoneySurl=json.decode(response.body)['paymoney']['surl'].toString();
        CheckOut.payUMoneyFurl=json.decode(response.body)['paymoney']['furl'].toString();
        CheckOut.payUMoneyHash=json.decode(response.body)['paymoney']['hash'].toString();
        CheckOut.payUMoneyUdf1=json.decode(response.body)['paymoney']['udf1'].toString();
        CheckOut.payUMoneyUdf2=json.decode(response.body)['paymoney']['udf2'].toString();
      });
     
     
     
      
      print('//////////////////////PayUcREDENTIALS body////////////////////');
      print(response.body);
      print("payUMoneyKey >>>>>>>>"+CheckOut.payUMoneyKey.toString());
      print("payUMoneyTxnid >>>>>>>>"+CheckOut.payUMoneyTxnid.toString());
      print("payUMoneyAmount >>>>>>>>"+CheckOut.payUMoneyAmount.toString());
      print("payUMoneyProductinfo >>>>>>>>"+CheckOut.payUMoneyProductinfo.toString());
      print("payUMoneyFirstname >>>>>>>>"+CheckOut.payUMoneyFirstname.toString());
      print("payUMoneyEmail >>>>>>>>"+CheckOut.payUMoneyEmail.toString());
      print("payUMoneyPhone >>>>>>>>"+CheckOut.payUMoneyPhone.toString());
      print("payUMoneySurl >>>>>>>>"+CheckOut.payUMoneySurl.toString());
      print("payUMoneyFurl >>>>>>>>"+CheckOut.payUMoneyFurl.toString());
      print("payUMoneyHash >>>>>>>>"+CheckOut.payUMoneyHash.toString());
      print("payUMoneyUdf1 >>>>>>>>"+CheckOut.payUMoneyUdf1.toString());
      print("payUMoneyUdf2 >>>>>>>>"+json.decode(response.body)['paymoney']['udf2'].toString());
       

      return PayUMoneyCredentialsModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");

      Fluttertoast.showToast(
        msg: "Please Try Once",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

     // throw Exception('Failed to create album.');
    }
  }
  ////////// PayUMoney Credentials end////////////////
 

  
  // Default Radio Button Item
  String radioItem = '';
   
  // Group Value for Radio Button.
  int id = 1;
  
  List<PaymentModeList> paymentModeList = [
    PaymentModeList(
      index: 1,
      paymentMode: "Pay with PayUMoney",
      //imageUrl: "https://logos-download.com/wp-content/uploads/2021/01/PhonePe_Logo-700x698.png"
     // imageUrl: "https://www.searchpng.com/wp-content/uploads/2019/01/Money-PNG-Image-715x715.png"
      //imageUrl: "vegitable"

    
    ),
    PaymentModeList(
      index: 2,
      paymentMode: "Cash On Delivery",
     // imageUrl: "https://lh3.googleusercontent.com/proxy/SC-KHut4MfUKWe1Jj0ja4C9-IK9tYuHJcZCKmnwnEnz_UQsW4AN1C8YYCRIsvMXR64o4PvAkiqjILzhGzI4CmCMFWxD-GsGw2L0PnVfCWebv1PPJkmoFYo5_n9r2lLbJCTq_A50"
    ),
    
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    CheckOut.radioButtonid=1;
   // responseFromNativeCode(); // checking phone pe is existing or not
   // getAddressListSharedPreferences();
   // print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+AddressList.listItemId.toString());

    fetchSelectedAddress();
    fetchCartList();
   // payUmoneyCredentialsProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),CheckOut.selectedAddressId.toString());
    


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

    
  

  //////////////// Shared Preferences start////////////////////
  getAddressListSharedPreferences() async{
    SharedPreferences prefsAddressListItemId= await SharedPreferences.getInstance();
    int addressListId=prefsAddressListItemId.getInt("AddressId");
    setState(() {
      CheckOut.addressListId= addressListId;
      addressid=addressListId;
     // print("111111111111111111111111111 "+addressid.toString());
       fetchSelectedAddress();
    });

    if(addressid.toString()== null){
       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> AddressList()));
    }

    //print("222222222222222222 "+CheckOut.addressListId.toString());
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themColor,

      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('CheckOut',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Cart()));
          },
        ),
      ),

      endDrawer: Drawer(
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
              leading: Icon(Icons.home),
              title: Text('Home',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: () {

                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
               
              },
            ),
            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.person),
              title: Text('Profile',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Profile()));
               // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
               // Navigator.pop(context);
              },
            ),

            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.search),
              title: Text('Search',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              children: [
                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.shopping_bag_rounded),
                  title: Text('My Orders',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: () {
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> MyOrdersModified()));
                  //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Profile()));
                  // Navigator.pop(context);
                  },
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.favorite),
                  title: Text('My WishList',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>WishList()));
                  },
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.shopping_bag),
                  title: Text('My Cart',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
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
              title: Text('Sign Out',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
              onTap: ()async{
                SharedPreferences loginPrefs = await SharedPreferences.getInstance();
                loginPrefs.clear();
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Login()));
              },
            ),

            ListTile(
              focusColor: themColor,
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
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
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              children: [

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.person),
                  title: Text('Customer Service',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.help),
                  title: Text('Guide',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),

                ListTile(
                  focusColor: themColor,
                  leading: Icon(Icons.live_help),
                  title: Text('Help',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 16)),
                  onTap: (){},
                ),
              ]
            )    
          ]  
        ),
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
            ),

            //////// Address PADDING START
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                  color: Colors.white
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Container(
                  
                    //height: MediaQuery.of(context).size.height/5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Delivery Address: ",style: TextStyle(color:Colors.black,fontSize: 17.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                          Icon(Icons.location_city,color: themColor,)
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.black54
                          ),
                        ),

                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Name: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                Text(WelcomeScreen.userName,style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                //Text("Delivery Address: ",style: TextStyle(color:Colors.black,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Address: ",style: TextStyle(color:Colors.green,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                
                              ],
                            ),
                          ),
                        ),

             ////////////////////////// address    start/////////////////////////////////
                        Container(
                          height: 70,
                          //height: MediaQuery.of(context).size.height/9.5,
                          width: MediaQuery.of(context).size.width,
                          // width: 600,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: selectedAddressList.length,
                            itemBuilder: (context,index){

                              CheckOut.selectedAddressId=selectedAddressList[index]['id'];

                               print("address id/////////////////////////////////////////");
                               print(CheckOut.selectedAddressId.toString());

                              return ListTile(
                                title: 
                                Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height/8,
                                    //width: 600,
                                    child: Card(
                                      shape:RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      elevation: 0,
                                      margin:EdgeInsets.only(left: 0,right: 0) ,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0,top: 0,right: 0),
                                        child: Column(
                                          children:[
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                          
                                                // Container(
                                                //   width: MediaQuery.of(context).size.width/6,
                                                //   height: 100,
                                                //   child: ClipRRect(
                                                //     borderRadius: BorderRadius.circular(15.0),
                                                //     child: Image.asset("assets/images/location_icon.png",
                                                //       height: 100,
                                                //       // fit: BoxFit.cover,
                                                //       // alignment: Alignment.centerLeft,
                                                //     )
                                                //   ),
                                                // ),
                                          
                                                
                                                Padding(
                                                  padding: EdgeInsets.only(top: 0,left: 5,right: 5),
                                                  child:Container(
                                                    width: MediaQuery.of(context).size.width/1.4,
                                                    // width: 480,
                                                    height: MediaQuery.of(context).size.height/8,
                                                    color: Colors.white,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                      
                                                
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Full Address: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Text(selectedAddressList[index]['fulladdress'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text("Additional Address: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Container(
                                                                  height: 20,
                                                                  child: Text(selectedAddressList[index]['additionalinfo'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                                                                )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text("Pincode: ",style: TextStyle(color:Colors.black54,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                            Text(selectedAddressList[index]['pincode'].toString(),style: TextStyle(color:Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                          ],
                                                        ),
                                          
                                                      ]
                                                    )    
                                                  )
                                                ),
                                              ],
                                            ),
                                                
                                          ]  
                                        ),
                                      ) 
                                    ),
                                  ),
                                ),
                        
                              );
                            }
                          ),
                        ),
                     ////////////////////////// address    end /////////////////////////////////
                    

                    ////////////////////////// change address  start /////////////////////////////////

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/1.2,
                              height: 30,

                              child: ElevatedButton.icon(
                              
                                style: ElevatedButton.styleFrom(
                                  primary: themColor,
                                  onPrimary: Colors.white,
                                  shadowColor: themColor,
                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                  elevation: 10,
                                ),
                                icon: Icon(Icons.location_city),
                                label: Text('Change Address', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                onPressed: () {
                                  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>AddressList()));
                                }
                              ),
                            ),
                          ],
                        ),

                        ////////////////////////// change address  end/////////////////////////////////

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text("Item Details: ",style: TextStyle(color:Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //////// Address PADDING END

            Padding(
              padding: EdgeInsets.only(top: 250),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                  color: Colors.white
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                        color: Colors.white
                      ),

                      child: Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 200,
                            child: Column(
                             
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                    color: themColor
                                  ),

                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                      color: themColor
                                    ),
                                    child: Container(
                                      child: Column(
                                        children: [

                                          Padding(
                                            padding: EdgeInsets.only(left: 10,right: 10,top: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("No Of Items in Cart: ",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                Text(CheckOut.noOfItemsInCart.toString()+"Nos",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Cart Total Price: ",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                Text(CheckOut.cartTotalPrice.toString()+"/-",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                              ],
                                            ),
                                          ),

                                          

                                          Padding(
                                            padding: EdgeInsets.only(left: 10,right: 10),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("----",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                  Text(" Choose Payment Mode ",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                  Text("----",style: TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                
                                                ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                           
                                  ),
                                ),
                                Container(
                                  height: 50, // for reducing gap between radio button
                                  child: Column(
                                    children: 
                                    paymentModeList.map((data) => Flexible(
                                      fit: FlexFit.tight,
                                      child: RadioListTile(
                                        dense: true,
                                        selectedTileColor: Colors.green,
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${data.paymentMode}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                            //Image.network(data.imageUrl)
                                          ]
                                        ),
                                        groupValue: id,
                                        value: data.index,
                                        onChanged: (val) {
                                          setState(() {
                                            radioItem = data.paymentMode;
                                            id = data.index;
                                            CheckOut.radioButtonid=id;
                                           // print("checking"+CheckOut.radioButtonid.toString());
                                          });
                                        },
                                      ),
                                    )).toList(),
                                    
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width/1.05,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        shadowColor: Colors.white,
                                        primary: themColor,
                                        onPrimary: Colors.white,
                                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      ),
                                      icon: Icon(Icons.arrow_forward),
                                      label: Text("₹ "+'Pay', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: "Roboto"),),
                                      onPressed: () async{
                                        if(CheckOut.radioButtonid==1){

                                          payUmoneyCredentialsProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),CheckOut.selectedAddressId.toString());
                                          
                                          ///PayUMoney Process Start/////
                                          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>PayUmoney()));
                                          //////PayUMoney Process End/////

                                         /////////Phone Pe Process Start////////////////////
                                        //   responseFromNativeCode();
                                        //   var response=await onLinePaymentProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),CheckOut.selectedAddressId.toString());
                                        //   var ress=response.message;
                                        //  // print("res---------------"+ ress);
                                        //   bool res=response.status;
                                        //   if(res==true){
                                        //     CheckOut.merchantOrderNo = response.data.data.orderno.toString();
                                        //     int amount=response.data.data.amount;
                                        //     CheckOut.transcationId=response.data.data.transactionrefno.toString();

                                        //     setState(() {
                                        //       amountFinal=amount;
                                        //      // print("Final Amount"+amountFinal.toString());
                                        //     });

                                        //     // print('Phone Pe DATA');
                                        //     // print(CheckOut.merchantOrderNo);
                                        //     // print(amountFinal);
                                        //     // print(CheckOut.transcationId);
                                        //     Fluttertoast.showToast(
                                        //       msg: response.message.toString(),
                                        //       toastLength: Toast.LENGTH_SHORT,
                                        //       gravity: ToastGravity.CENTER,
                                        //       timeInSecForIosWeb: 1,
                                        //       backgroundColor: Colors.green,
                                        //       textColor: Colors.white,
                                        //       fontSize: 16.0
                                        //     );

                                        //     //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> OrderPlaced()));
                                        //   }

                                        //   Base64EncodedModel base64EncodedModel = Base64EncodedModel('SITANSHUUAT',CheckOut.merchantOrderNo,CheckOut.transcationId,amountFinal*100);
                                        //   String jsonbase64EncodedModelValue = jsonEncode(base64EncodedModel);
                                        //   // print("<<<<<<<<<<<<<<<<<<<Base 64 encode/////////////////////////////");
                                        //   // print(jsonbase64EncodedModelValue);

                                        //   var base64EncodedValue = base64.encode(utf8.encode(jsonbase64EncodedModelValue));
                                        //  // print('Encoded 1: $base64EncodedValue');
                                        //   setState(() {
                                        //     base64EncodedValueFinal=base64EncodedValue;
                                        //   });

                                        //   var bytes = utf8.encode(base64EncodedValue+"/v4/debit"+"5a2dde91-c893-4558-a070-1621592cff86"); // data being hashed
                                        //   var sha256ConvertedValue = sha256.convert(bytes);
                                        //  // print("Digest as hex string: $sha256ConvertedValue");

                                        //   setState(() {
                                        //     sha256ConvertedValueFinal=sha256ConvertedValue;
                                        //   });

                                        //   var checkSum=sha256ConvertedValue.toString()+"###"+"1";
                                        //   print("Check //////////////////////"+checkSum);

                                        //   setState(() {
                                        //     checkSumFinal=checkSum;
                                        //   });

                                        //   startPaymentTransaction();
                                          /////////Phone Pe Process End////////////////////

                                        }
                                        else{
                                          // print("CODDDDDDDDDDDDDDDDDDDDDD");
                                          // print("id "+CheckOut.selectedAddressId.toString());
                                          // print("checkout token "+WelcomeScreen.userToken.toString());
                                          // print("checkout userid "+WelcomeScreen.userUserid.toString());
                                          // print("checkout address id "+CheckOut.selectedAddressId.toString());

                                          var response=await codProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),CheckOut.selectedAddressId.toString());
                                          var ress=response.message;
                                         // print("res---------------"+ ress);
                                          bool res=response.status;
                                          if(res==true){
                                              
                                            Fluttertoast.showToast(
                                              msg: response.message.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                            );

                                            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> OrderPlaced()));
                                          }
                                        }
                                      }
                                    ),
                                  ),
                                ),

                                // Container(
                                //   height: 50,
                                //   color: Colors.blue,
                                // )
                              ]  
                            ),
                          )
                        ),
                      ),
                     // ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5,bottom: 200),
                      child:  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(2)),
                          color: Colors.white
                        ),
                        child:  Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: showCartList.length,
                            itemBuilder: (context,index){
                              return ListTile(
                                title:
                                Column(
                                  children: [
                                    
                                    Stack(
                                      children: [

                                        Container(
                                          width: MediaQuery.of(context).size.width/2,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(2),bottomLeft: Radius.circular(2)),
                                            color: themColor
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height/7.5,
                                            child: Card(
                                              shadowColor: Colors.white60,
                                              shape:RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(2)
                                              ),
                                              elevation: 8,
                                              margin:EdgeInsets.only(left: 5,right: 5),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 5,left: 5),
                                                child: Column(
                                                  children:[
                                                    Row(
                                                      
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                  
                                                        Container(
                                                          width: MediaQuery.of(context).size.width/7,
                                                          height: 60,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(0.0),
                                                            child: Image.network( showCartList[index]['image']
                                                            ,height: 60,
                                                              fit: BoxFit.cover,
                                                              alignment: Alignment.centerLeft,
                                                            ),
                                                        
                                                          ),
                                                        ),
                                                  
                                                        
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 0,left: 5),
                                                          child:Container(
                                                            
                                                            width: MediaQuery.of(context).size.width/1.7,
                                                            height: MediaQuery.of(context).size.height/8,
                                                            color: Colors.white,
                                                            child: Wrap(
                                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                                              // mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                  
                                                              
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    //Text("Product: ",style: TextStyle(color:Colors.black54,fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                    Expanded(
                                                                      child: SingleChildScrollView(
                                                                        scrollDirection: Axis.horizontal,
                                                                        child: Container(
                                                                          height: 20,
                                                                          child: Text(showCartList[index]['itemname'],style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                        )
                                                                      ),
                                                                    ),
                                                                    
                                                                    
                                                                  ],
                                                                ),
                
                                                                SizedBox(
                                                                  height: 0,
                                                                ),
                
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("Quantity: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                    Text(showCartList[index]['noofitems'].toString()+" Nos",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                  ],
                                                                ),
                                                                // Row(
                                                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                //   children: [
                                                                //     Text("MRP: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //     Text(showCartList[index]['mrp'].toString()+"/-",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //   ],
                                                                // ),
                
                                                                // Row(
                                                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                //   children: [
                                                                //     Text("Discount: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //     Text(showCartList[index]['discount'].toString()+"%",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //   ],
                                                                // ),
                                                                // Row(
                                                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                //   children: [
                                                                //     Text("Sale Price of item: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //     Text(showCartList[index]['saleprice'].toString()+"/-",style: TextStyle(color: Colors.deepOrange,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                //   ],
                                                                // ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("Total Price: ",style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                    Text("₹"+showCartList[index]['total'].toString(),style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                                                  ],
                                                                ),
                                                              ]
                                                            )    
                                                          )
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
                                  ]  
                                )
                              
                              );
                            }
                          ),
                          
                        ),
                      )
                    
                    ),
                  ],
                ),
              ),

            ),
            
          ],
        ),
      ),
      
    );
  }
}

// void PhonePeNotification() async{
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: 1,
//       channelKey: 'key1',
//       title: 'Apana Bazar',
//       body: "You have Successfully done Online Payment in Apana Bazar",
//       bigPicture: "https://theindiasaga.com/wp-content/uploads/2020/06/cat_social191.jpg",
//       notificationLayout: NotificationLayout.BigPicture
//     )
//   );
// }

