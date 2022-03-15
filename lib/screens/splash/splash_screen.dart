import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_data/shared_preferences_helper.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/app_repo/location_state.dart';
import 'package:ninan/components/safe_area/page_container.dart';
import 'package:location/location.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppState _appState;
  LocationState _locationState;
  LocationData _locData;


  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());

      setState(() {
        _locationState.setLocationLatitude(_locData.latitude);
        _locationState.setLocationlongitude(_locData.longitude);
      });
    }
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Widget _buildBodyItem() {
    return Image.asset(
      'assets/images/splash.png',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    _appState.setCurrentLanguage(currentLang);
    print('language: ${_appState.currentLang}');
  }

  Future<Null> _checkIsFirstTime() async {
    var _firstTime = await SharedPreferencesHelper.getFirstTime();
    if (_firstTime) {
      SharedPreferencesHelper.saveFirstTime(false);
   Navigator.pushReplacementNamed(context, '/navigation');
    } else {
      Navigator.pushReplacementNamed(context, '/navigation');
    }
  }

  @override
  void initState() {
    super.initState();
    _getLanguage();
    _getCurrentUserLocation();
    initData().then((value) { 
       _checkIsFirstTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    _appState = Provider.of<AppState>(context);
    _locationState = Provider.of<LocationState>(context);
    return PageContainer(
        child: Scaffold(
      body: _buildBodyItem(),
    ));
  }
}
