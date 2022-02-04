import 'dart:convert';
import 'dart:io';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Model/CodModel.dart';
import 'package:apanabazar/Model/OnlinePaymentModel.dart';
import 'package:apanabazar/Model/PayUMoneyCredentials.dart';
import 'package:apanabazar/Screens/Address/AddressList/AddressList.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/PayUmoney/PayUmoney.dart';
import 'package:apanabazar/Screens/SuccessPage/OrderPlaced.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/constants/constants.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CheckOutModified extends StatelessWidget {

  static int noOfItemsInCart,cartTotalPrice,addressListId,selectedAddressId,base64Encoded;
  static String cartItemDetails,merchantOrderNo,transcationId,amount;

  static String payUMoneyKey,payUMoneyTxnid,payUMoneyProductinfo,payUMoneyFirstname,payUMoney,payUMoneyEmail,payUMoneySurl,payUMoneyFurl,payUMoneyHash,payUMoneyUdf1,payUMoneyUdf2,payUMoneyUdf3;
  static String payUMoneyPhone;
  static int payUMoneyAmount;

  static int radioButtonid=1;

  static String fullAddress,additionalAddress,pincode;


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

//Payment mode Model Class started
class PaymentModeList {
  String paymentMode,imageUrl;
  int index;
  PaymentModeList({this.paymentMode,this.index});
}
//Payment mode Model Class ended

//Delivery mode Model Class started
class DeliveryModeList {
  String deliveryMode;
  int index;
  DeliveryModeList({this.deliveryMode,this.index});
}
//Delivery mode Model Class ended

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
     // PhonePeNotification();
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
      var resFullAddress=selectedAddress[0]['fulladdress'];
      var resAdditionalAddress=selectedAddress[0]['additionalinfo'];
      var resPinCode=selectedAddress[0]['pincode'];
    
      
      // var res= json.decode(response.body)['response'];
      // print('selected Address body /////////////////////////////');
      // print(selectedAddress);
      // print(full.toString());
      
      
      setState(() {
        
        CheckOutModified.fullAddress=resFullAddress.toString();
        CheckOutModified.additionalAddress=resAdditionalAddress.toString();
        CheckOutModified.pincode=resPinCode.toString();

        isLoading = false;
      });

      
    }else{
      
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
      CheckOutModified.noOfItemsInCart=nos_of_items_in_Cart as int;
      CheckOutModified.cartTotalPrice=cartTotalPrice as int;
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
          'token': token.toString(),
          'userid': userId.toString(),
          'deliveryid': deliveryId.toString(),
          'shipping_type': deliveryRadioId.toString()
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

    print("+++++++++++++++++++++++++++++++++++++"+AddressList.addressListItemId.toString());
 
    const payUmoney_credentials_url='https://apanabazar.com/Gateway/pay_with_payu';
    final http.Response response = await http.post(
        Uri.parse(payUmoney_credentials_url),
       
      
       
        body: {
          'key': token.toString(),
          'userid': userId.toString(),
          'deliveryid': AddressList.addressListItemId.toString(),
          'shipping_type': deliveryRadioId.toString(),
        },
       
    );
      
    if (response.statusCode == 200) {

      final responseBody=json.decode(response.body);

       print('//////////////////////PayUcREDENTIALS body first////////////////////');
      print(response.body);

      setState(() {
        CheckOutModified.payUMoneyKey=json.decode(response.body)['paymoney']['key'].toString();
        CheckOutModified.payUMoneyTxnid=json.decode(response.body)['paymoney']['txnid'].toString();
        CheckOutModified.payUMoneyAmount=json.decode(response.body)['paymoney']['amount'] as int;

        
        CheckOutModified.payUMoneyProductinfo=json.decode(response.body)['paymoney']['productinfo'].toString();
        CheckOutModified.payUMoneyFirstname=json.decode(response.body)['paymoney']['firstname'].toString();
        CheckOutModified.payUMoneyEmail=json.decode(response.body)['paymoney']['email'].toString();
        CheckOutModified.payUMoneyPhone=json.decode(response.body)['paymoney']['phone'].toString();
        CheckOutModified.payUMoneySurl=json.decode(response.body)['paymoney']['surl'].toString();
        CheckOutModified.payUMoneyFurl=json.decode(response.body)['paymoney']['furl'].toString();
        CheckOutModified.payUMoneyHash=json.decode(response.body)['paymoney']['hash'].toString();
        CheckOutModified.payUMoneyUdf1=json.decode(response.body)['paymoney']['udf1'].toString();
        CheckOutModified.payUMoneyUdf2=json.decode(response.body)['paymoney']['udf2'].toString();
        CheckOutModified.payUMoneyUdf3=json.decode(response.body)['paymoney']['udf3'].toString();
      });
     
     
     
      
      print('//////////////////////PayUcREDENTIALS body////////////////////');
      print(response.body);
      print("payUMoneyKey >>>>>>>>"+CheckOutModified.payUMoneyKey.toString());
      print("payUMoneyTxnid >>>>>>>>"+CheckOutModified.payUMoneyTxnid.toString());
      print("payUMoneyAmount >>>>>>>>"+CheckOutModified.payUMoneyAmount.toString());
      print("payUMoneyProductinfo >>>>>>>>"+CheckOutModified.payUMoneyProductinfo.toString());
      print("payUMoneyFirstname >>>>>>>>"+CheckOutModified.payUMoneyFirstname.toString());
      print("payUMoneyEmail >>>>>>>>"+CheckOutModified.payUMoneyEmail.toString());
      print("payUMoneyPhone >>>>>>>>"+CheckOutModified.payUMoneyPhone.toString());
      print("payUMoneySurl >>>>>>>>"+CheckOutModified.payUMoneySurl.toString());
      print("payUMoneyFurl >>>>>>>>"+CheckOutModified.payUMoneyFurl.toString());
      print("payUMoneyHash >>>>>>>>"+CheckOutModified.payUMoneyHash.toString());
      print("payUMoneyUdf1 >>>>>>>>"+CheckOutModified.payUMoneyUdf1.toString());
      print("payUMoneyUdf2 >>>>>>>>"+CheckOutModified.payUMoneyUdf2.toString());
       

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
 


  // Payment Mode started 
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
  // Payment Mode ended

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  // Delivery Mode started 
  // Default Radio Button Item
  String deliveryRadioItem = '';
   
  // Group Value for Radio Button.
  int deliveryRadioId = 0;
  
  List<DeliveryModeList> deliveryModeList = [
    DeliveryModeList(
      index: 0,
      deliveryMode: "Delivery",
      //imageUrl: "https://logos-download.com/wp-content/uploads/2021/01/PhonePe_Logo-700x698.png"
     // imageUrl: "https://www.searchpng.com/wp-content/uploads/2019/01/Money-PNG-Image-715x715.png"
      //imageUrl: "vegitable"

    
    ),
    DeliveryModeList(
      index: 1,
      deliveryMode: "Own Pick Up",
     // imageUrl: "https://lh3.googleusercontent.com/proxy/SC-KHut4MfUKWe1Jj0ja4C9-IK9tYuHJcZCKmnwnEnz_UQsW4AN1C8YYCRIsvMXR64o4PvAkiqjILzhGzI4CmCMFWxD-GsGw2L0PnVfCWebv1PPJkmoFYo5_n9r2lLbJCTq_A50"
    ),
    
  ];
  // Payment Mode ended

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //BackButtonInterceptor.add(myInterceptor);
    CheckOutModified.radioButtonid=1;
    
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
      CheckOutModified.addressListId= addressListId;
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
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 30,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Cart()));
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
            ),

            //////// Address PADDING START
            Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.location_city,color: Colors.green,),
                            SizedBox(
                              width: 2,
                            ),

                            CheckOutModified.pincode==null ? Text("") :
                            Flexible(
                              child: Text(CheckOutModified.pincode.toString()+", ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                            ),

                            CheckOutModified.fullAddress==null ? Text("") :
                            Flexible(
                              child: Text(CheckOutModified.fullAddress.toString(),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                            ),
                         
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.black12
                          ),
                        ),

                        Container(
                          child: Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  CheckOutModified.additionalAddress==null ? Text("") :
                                  Flexible(
                                    child: Text(CheckOutModified.additionalAddress.toString()+", ",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: OutlinedButton.icon(
                                      label: Text('Change Address',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black54,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                      icon: Icon(Icons.location_city,color: themColor,),
                                      onPressed: () {
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>AddressList()));
                                      },
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.shopping_bag,color: themColor,),
                                  Flexible(
                                    child: Text("Order Details",overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(color:Colors.black45,fontSize: 14.0,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                  ),
                                  
                                 
                                ],
                              )

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            //////// Address PADDING END

            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Container(
               
                child: Stack(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(0),topRight: Radius.circular(0)),
                        color: Colors.grey[100]
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child:  Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(2)),
                          color: Colors.white
                        ),
                        child:  Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.9,
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
                                          width: MediaQuery.of(context).size.width/6,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(2),topRight: Radius.circular(2),bottomLeft: Radius.circular(2)),
                                            color: Colors.black45
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height/9.5,
                                            child: Card(
                                              shadowColor: Colors.white60,
                                              shape:RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(2)
                                              ),
                                              elevation: 8,
                                              margin:EdgeInsets.only(left: 5,right: 5),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 0,left: 5),
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
                                                            child: Image.network( showCartList[index]['image'],
                                                            
                                                              fit: BoxFit.cover,
                                                              alignment: Alignment.centerLeft,
                                                            ),
                                                        
                                                          ),
                                                        ),
                                                  
                                                        
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 0,left: 5),
                                                          child:Container(
                                                            
                                                            width: MediaQuery.of(context).size.width/1.7,
                                                            height: MediaQuery.of(context).size.height/9.5,
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
                                                                          child: Text(showCartList[index]['itemname'],style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w800,fontFamily: "Roboto")),
                                                                        )
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                
                                                               
                                                                Row(
                                                                  children: [
                                                                    Flexible(child: Text(showCartList[index]['noofitems'].toString()+" Nos",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                                    SizedBox(width: 5,),
                                                                    Flexible(child: Text("₹"+showCartList[index]['total'].toString(),style: TextStyle(color: Colors.green,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto"))),
                                                                  ],
                                                                ),

                                                                showCartList[index]['discount'].toString() == "0" || showCartList[index]['discount'].toString() == "00" ? 

                                                                Container():

                                                                Align(
                                                                  alignment: Alignment.bottomRight,
                                                                  child: Padding(
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

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.white,
                       
                        height: MediaQuery.of(context).size.height*0.2,
                        child:   Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: 40, // for reducing gap between radio button
                              child: Row(
                                children: 
                                deliveryModeList.map((data) => Flexible(
                                  fit: FlexFit.tight,
                                  child: RadioListTile(
                                    dense: true,
                                    selectedTileColor: Colors.white,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${data.deliveryMode}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                        //Image.network(data.imageUrl)
                                      ]
                                    ),
                                    groupValue: deliveryRadioId,
                                    value: data.index,
                                    onChanged: (val) {
                                      setState(() {
                                        deliveryRadioItem = data.deliveryMode;
                                        deliveryRadioId = data.index;
                                        CheckOutModified.radioButtonid=deliveryRadioId;
                                      // print("checking"+CheckOut.radioButtonid.toString());
                                      });
                                    },
                                  ),
                                )).toList(),
                                
                              ),
                            ),

                            Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: 40, // for reducing gap between radio button
                              child: Row(
                                children: 
                                paymentModeList.map((data) => Flexible(
                                  fit: FlexFit.tight,
                                  child: RadioListTile(
                                    dense: true,
                                    selectedTileColor: Colors.white,
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${data.paymentMode}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                        //Image.network(data.imageUrl)
                                      ]
                                    ),
                                    groupValue: id,
                                    value: data.index,
                                    onChanged: (val) {
                                      setState(() {
                                        radioItem = data.paymentMode;
                                        id = data.index;
                                        CheckOutModified.radioButtonid=id;
                                      // print("checking"+CheckOut.radioButtonid.toString());
                                      });
                                    },
                                  ),
                                )).toList(),
                                
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1,
                                child: Row(
                                  children:[
                                    Container(
                                        width: MediaQuery.of(context).size.width/5,
                                        height: 20,
                                        color: Colors.white,
                                      
                                        
                                          //width: MediaQuery.of(context).size.width/6,
                                          child: Text(Cart.noOfItemsInCart.toString()+" Nos",overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w900,fontFamily: "Roboto"))
                                        
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width/1.5,
                                        height: 20,
                                        child: Container(
                                          color: Colors.white,
                                        // width: MediaQuery.of(context).size.width/3,
                                          child: Text("₹"+Cart.cartTotalPrice.toString(),overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w900,fontFamily: "Roboto"))
                                        ),
                                    ),
                                  ]
                                )
                              ),
                            ), 

                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width/1,
                                  height: 30,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: themColor,
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.black45,
                                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      elevation: 10,
                                    ),
                                    icon: Icon(Icons.arrow_forward),
                                    label: Text('Pay', style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto")),
                                    onPressed: () async{

                                      if(CheckOutModified.radioButtonid==1){

                                        payUmoneyCredentialsProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),AddressList.addressListItemId.toString());
                                        
                                        ///PayUMoney Process Start/////
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>PayUmoney()));
                                        //////PayUMoney Process End/////

                                      

                                      }
                                      else{
                                        // print("CODDDDDDDDDDDDDDDDDDDDDD");
                                        // print("id "+CheckOut.selectedAddressId.toString());
                                        // print("checkout token "+WelcomeScreen.userToken.toString());
                                        // print("checkout userid "+WelcomeScreen.userUserid.toString());
                                        // print("checkout address id "+CheckOut.selectedAddressId.toString());

                                        var response=await codProcess(WelcomeScreen.userToken.toString(),WelcomeScreen.userUserid.toString(),AddressList.addressListItemId.toString());
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
                            ),     

                        

                            // Container(
                            //   height: 50,
                            //   color: Colors.blue,
                            // )
                          ]  
                        ),

                          // Container(
                          //   width: 100,
                          //   height: 200,
                          //   color: Colors.red,
                          // )

                          

                      )
                 
                      
                    )    

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

