
import 'package:apanabazar/Screens/Home/Home.dart';
import 'package:flutter/material.dart';


class MainAppBar extends StatefulWidget implements PreferredSizeWidget {

  Color themeColor;
  bool showProfilePic;

  MainAppBar({ 
    this.themeColor = Colors.red,
    this.showProfilePic = true  
  });

  @override
  MainAppBarState createState() => MainAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(80);
}

class MainAppBarState extends State<MainAppBar> {

  @override 
  Widget build(BuildContext context) {
    return AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Home()));
          },
          child: Center(
            // child: IconFont(
            // iconName: IconFontHelper.LOGO,
            //   color: widget.themeColor,
            //   size: 40
            // ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: widget.themeColor),
        // actions: [
        //   UserProfileHeader(
        //     showProfilePic: widget.showProfilePic,
        //   )
        // ],
      );
  }
}