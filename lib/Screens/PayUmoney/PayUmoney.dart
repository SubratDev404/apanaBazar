import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:apanabazar/CurvedBottomNavigationBar/CurvedButtonNavigationBar.dart';
import 'package:apanabazar/Drawer.dart';
import 'package:apanabazar/Screens/Cart/Cart.dart';
import 'package:apanabazar/Screens/CheckOut/CheckOut.dart';
import 'package:apanabazar/Screens/CheckOut/CheckOutModified.dart';
import 'package:apanabazar/Screens/LoginRegistration/Login.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrders.dart';
import 'package:apanabazar/Screens/MyOrders/MyOrdersModified.dart';
import 'package:apanabazar/Screens/NoItemsPage/NoPreviousAddress/NoPreviousAddress.dart';
import 'package:apanabazar/Screens/Profile/Profile.dart';
import 'package:apanabazar/Screens/Search/Search.dart';
import 'package:apanabazar/Screens/WelComeScreen/WelcomeScreen.dart';
import 'package:apanabazar/Screens/WishList/WishList.dart';
import 'package:apanabazar/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PayUmoney extends StatelessWidget {
  
  static int listItemId;
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
      home: PayUmoneyScreen(),
    );
  }
}

class PayUmoneyScreen extends StatefulWidget {
  

  @override
  _PayUmoneyScreenState createState() => _PayUmoneyScreenState();
}

class _PayUmoneyScreenState extends State<PayUmoneyScreen> {

String returnUrl="https://apanabazar.com/Payment_Success/call_back";  // for web view go back to app


  
  InAppWebViewController webView;
  
  String strKey,strTxnid,strAmount,strProductInformation,strFirstName,strEmail,strPhone,strSurl,strFurl,strHash,strUdf1,strUdf2,strUdf3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    

    strKey=CheckOutModified.payUMoneyKey.toString();
    strTxnid=CheckOutModified.payUMoneyTxnid.toString();
    strAmount=CheckOutModified.payUMoneyAmount.toString();

    
    strProductInformation=CheckOutModified.payUMoneyProductinfo.toString();
    strFirstName=CheckOutModified.payUMoneyFirstname.toString();
    strEmail=CheckOutModified.payUMoneyEmail.toString();
    strPhone=CheckOutModified.payUMoneyPhone.toString();
    strSurl=CheckOutModified.payUMoneySurl.toString();
    strFurl=CheckOutModified.payUMoneyFurl.toString();
    strHash=CheckOutModified.payUMoneyHash.toString();
    strUdf1=CheckOutModified.payUMoneyUdf1.toString();
    strUdf2=CheckOutModified.payUMoneyUdf2.toString();
    strUdf3=CheckOutModified.payUMoneyUdf3.toString();
    //BackButtonInterceptor.add(myInterceptor);

    final flutterWebviewPlugin = new FlutterWebviewPlugin();
      flutterWebviewPlugin.onUrlChanged.listen((String url) {
       print(url);
    });

    print("payu started");
    print("strKey >>>>>>>>>>>>>"+strKey);
    print("strAmount >>>>>>>>>>>>>"+strAmount);
    print("strTxnid >>>>>>>>>>>>>"+strTxnid);
    print("strProductInformation >>>>>>>>>>>>>"+strProductInformation);
    print("strFirstName >>>>>>>>>>>>>"+strFirstName);
    print("strEmail >>>>>>>>>>>>>"+strEmail);
    print("strPhone >>>>>>>>>>>>>"+strPhone);
    print("strSurl >>>>>>>>>>>>>"+strSurl);
    print("strHash >>>>>>>>>>>>>"+strHash);
    print("strUdf1 >>>>>>>>>>>>>"+strUdf1);
    print("strUdf2 >>>>>>>>>>>>>"+strUdf2);
    print("strUdf3 >>>>>>>>>>>>>"+strUdf3);


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
      
      appBar: AppBar(
        backgroundColor: themColor,
        elevation: 0.0,
        title: Center(child: Text('Payment',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Cart()));
          },
        ),
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: MyDrawer()
      ),

      body: Container(
       // child: Expanded(
          child: InAppWebView(

            initialUrlRequest: URLRequest(
              url: Uri.parse("https://secure.payu.in/_payment"),
             // url: Uri.parse("https://gaana.com/playlist/gaana-dj-new-releases-hot-50-hindi"),
              method: 'POST',
             
             body: Uint8List.fromList(utf8.encode("key=$strKey&txnid=$strTxnid&amount=$strAmount&productinfo=$strProductInformation&firstname=$strFirstName&email=$strEmail&phone=$strPhone&surl=$strSurl&furl=$strFurl&hash=$strHash&udf1=$strUdf1&udf2=$strUdf2&udf3=$strUdf3")),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              }
            ),

          

            
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                supportZoom: false,
                //debuggingEnabled: true,
                useOnDownloadStart: true
              ),

            ),
        
            onLoadStart:(InAppWebViewController controller, Uri url){

              setState(() {
               // this. returnUrl=url as String;  
                print("uuuuuuuuuuuuuuuuuuuuuuuuu "+url.toString());

                if (url.toString() == returnUrl) {

                  print("mmmmmmmmmmmmmmmmmmmmmmmmm "+"Url matched");

                 //close the webview
                  //webView.goBack();

                 //navigate to the desired screen with arguments
                  Timer(Duration(seconds: 3),()=>Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar())));
                  //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CurvedBottomNavigationBar()));
                  // Navigator.of(context).pushReplacementNamed('/OrderSuccess',
                  //     arguments:
                  //         new RouteArgument(param: 'Credit Card (Paytabs)'));
                }

                else{
                  print("nnnnnnnnnnnnnnnnnnnnn "+"not matching");
                }
              });
              
             // print(object)
              
            },


            // onLoadStop: (InAppWebViewController controller, Uri url) async {
            //         setState(() {
            //           this.successUrl = url as String;
            //         });
            //       },
                  // onProgressChanged: (InAppWebViewController controller, int progress) {
                  //   setState(() {
                  //     this.progress = progress / 100;
                  //   });
                  // },
            
            

            

            
           
     
          ),
        ),
      //)
    );
  }
}