import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/connectivity/network_indicator.dart';
import 'package:ninan/components/dialogs/log_out_dialog.dart';
import 'package:ninan/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:ninan/components/safe_area/page_container.dart';
import 'package:ninan/locale/localization.dart';
import 'package:ninan/screens/account/about_screen.dart';
import 'package:ninan/screens/account/contact_with_us_screen.dart';
import 'package:ninan/screens/account/language_screen.dart';
import 'package:ninan/screens/account/terms_screen.dart';
import 'package:ninan/utils/app_colors.dart';
import 'dart:math' as math;

class MainDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return new _MainDrawer();
  }
}

class _MainDrawer extends State<MainDrawer> {
  double _height = 0 , _width = 0;




  @override
  Widget build(BuildContext context) {



      return Drawer(
          elevation: 0,

          child: ListView(
            children: <Widget>[

              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
               ""
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/topDrawer.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              ListTile(
                leading:Icon(Icons.help ,color: cPrimaryColor,),
                title: Text(AppLocalizations.of(context).about,
                  style: TextStyle(
                      color: Color(0xff404040),fontSize: 15
                  ), ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutScreen()));
                },
              ),


              Consumer<AppState>(builder: (context, appState, child) {
                return  appState.currentUser != null
                    ?  ListTile(
                  onTap: (){
                    Navigator.pushNamed(context, '/personal_information_screen');
                  },
                  leading: Icon(Icons.edit ,color: cPrimaryColor,),
                  title: Text( AppLocalizations.of(context).personalInfo,style: TextStyle(
                      color: Color(0xff404040),fontSize: 15
                  ), ),
                ): Container();
              }),

              ListTile(
                leading: Icon(Icons.warning ,color: cPrimaryColor,),
                title: Text( AppLocalizations.of(context).terms,style: TextStyle(
                    color: Color(0xff404040),fontSize: 15
                ), ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsScreen()));
                },
              ),
              ListTile(
                leading:Icon(Icons.phone_in_talk ,color: cPrimaryColor,),
                title: Text( AppLocalizations.of(context).contactUs,style: TextStyle(
                    color: Color(0xff404040),fontSize: 15
                ), ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactWithUsScreen()));
                },
              ),
              ListTile(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageScreen()));
                },
                leading: Icon(FontAwesomeIcons.language,color: cPrimaryColor,),
                title: Text( AppLocalizations.of(context).language
                  ,style: TextStyle(
                      color: Color(0xff404040),fontSize: 15
                  ), ),
              ),
              Consumer<AppState>(builder: (context, appState, child) {
                return  appState.currentUser != null
                    ? ListTile(
                  leading: Icon(
                    FontAwesomeIcons.signInAlt,
                    color: cPrimaryColor,
                    size: 22,
                  ),
                  title: Text(
                    AppLocalizations.of(context).logOut,
                    style: TextStyle(
                        color: Color(0xff404040),fontSize: 15
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return LogoutDialog(
                            alertMessage: AppLocalizations.of(context).wantToLogout,
                          );
                        });
                  },
                )
                    : ListTile(
                  leading: Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: Icon(
                      FontAwesomeIcons.signInAlt,
                      color: cPrimaryColor,
                      size: 22,
                    ),
                  ),
                  title: Text(
                      AppLocalizations.of(context).enter,
                      style: TextStyle(
                          color: cBlack,fontSize: 15
                      )
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login_screen');
                  },
                );
              })
            ],
          ));



  }
}
