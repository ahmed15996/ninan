import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ninan/components/app_repo/location_state.dart';
import 'package:ninan/screens/home/components/slider_images.dart';
import 'package:ninan/screens/home/components/filter_stores.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_data/shared_preferences_helper.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/connectivity/network_indicator.dart';
import 'package:ninan/components/custom_text_form_field/custom_text_form_field.dart';
import 'package:ninan/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:ninan/components/no_data/no_data.dart';
import 'package:ninan/components/safe_area/page_container.dart';
import 'package:ninan/locale/localization.dart';
import 'package:ninan/services/access_api.dart';
import 'package:ninan/utils/app_colors.dart';
import 'package:ninan/models/category.dart';
import 'package:ninan/models/store.dart';
import 'package:ninan/utils/utils.dart';
import 'package:ninan/components/app_repo/store_state.dart';
import 'package:ninan/components/store_card/store_card_item.dart';
import 'package:ninan/screens/home/components/slider_images.dart';

class Home1Screen extends StatefulWidget {
  Home1Screen({Key key}) : super(key: key);

  @override
  _Home1ScreenState createState() => _Home1ScreenState();
}

class _Home1ScreenState extends State<Home1Screen> {
  double _height;
  double _width;
  Future<List<Category>> _categoriesList;
  Future<List<Store>> _storeList;
  Services _services = Services();
  bool _enableSearch = false;
  String _categoryId = '1';
  StoreState _storeState;
  LocationState _locationState;
  AppState _appState;
  bool _initialRun = true;










  Future<List<Category>> _getCategories() async {
    String language =  await SharedPreferencesHelper.getUserLang();
    Map<String, dynamic> results = await _services.get(Utils.SUBCATEGORIES_URL+ language+"&cat_id=${_appState.selectedCat.mtgerCatId}");
    List categoryList = List<Category>();
    if (results['response'] == '1') {
      Iterable iterable = results['cats'];
      categoryList = iterable.map((model) => Category.fromJson(model)).toList();
      categoryList[0].isSelected = true;
    } else {
      print('error');
    }
    return categoryList;
  }

  Future<List<Store>> _getStores(String query) async {
    Map<String, dynamic> results =
        await _services.get(Utils.BASE_URL + query);
    List<Store> storeList = List<Store>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      storeList = iterable.map((model) => Store.fromJson(model)).toList();
      if (_appState.currentUser != null) {
// app favourite list on consume on it
        for (int i = 0; i < storeList.length; i++) {
          print('id: ${storeList[i].mtgerId} : favourite ${storeList[i].isAddToFav}');
          _storeState.setIsFavourite(
              storeList[i].mtgerId, storeList[i].isAddToFav);
        }
      }
    } else {
      print('error');
    }
    return storeList;
  }

  Widget _buildCategoriesList() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Category>>(
        future: _categoriesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Consumer<AppState>(builder: (context, appState, child) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _appState.setSelectedSub(snapshot.data[index]);
                          print(_appState.selectedCat.mtgerCatId);
                          print(_appState.selectedSub.mtgerCatId);
                          setState(() {
                            for (int i = 0; i < snapshot.data.length; i++) {
                              snapshot.data[i].isSelected = false;
                            }
                            snapshot.data[index].isSelected = true;
                            if (index == 0) {

                              if (_appState.currentUser != null) {
                                _storeList = _getStores(
                                    'show_mtager_cat_filter?page=1&cat=${_appState.selectedCat.mtgerCatId}&sub=0&filter=${_appState.filter}&lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
                              } else {
                                _storeList =
                                    _getStores('show_mtager_cat_filter?page=1&cat=${_appState.selectedCat.mtgerCatId}&sub=0&filter=${_appState.filter}&lang=${_appState.currentLang}&user_id=0&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
                              }
                            } else {
                              if (_appState.currentUser != null) {
                                _storeList = _getStores(
                                    'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&sub=${snapshot.data[index].mtgerCatId}&user_id=${_appState.currentUser.userId}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
                              } else {
                                _storeList = _getStores(
                                    'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&sub=${snapshot.data[index].mtgerCatId}&user_id=0&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
                              }
                            }


                          });
                        },
                        child: Container(
                          margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                          decoration: BoxDecoration(

                            borderRadius: snapshot.data[index].isSelected
                                ? BorderRadius.circular(15.0)
                                : BorderRadius.circular(0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.network(
                                    snapshot.data[index].mtgerCatPhoto,
                                    height: 24,
                                    width: 32,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5,right: 5),
                                  child: Text(
                                    snapshot.data[index].mtgerCatName,
                                    style: TextStyle(
                                        color: snapshot.data[index].isSelected
                                            ? cText
                                            : cHintColor,
                                        fontSize: 12),
                                  ))
                            ],
                          ),
                        ));
                  });
            });

          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              child: SpinKitSquareCircle(color: cPrimaryColor, size: 25));
        },
      );
    });
  }

  Widget _buildStoresOfCategory() {
    return LayoutBuilder(builder: (context, constraints) {

      return Consumer<AppState>(builder: (context, appState, child) {
        return FutureBuilder<List<Store>>(
          future: _storeList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            _storeState.setCurrentStore(snapshot.data[index]);
                            Navigator.pushNamed(context, '/store_screen');
                          },
                          child:  Container(
                            height: constraints.maxHeight * 0.18,
                            margin:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                            decoration: BoxDecoration(
                                color: cWhite,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: StoreCardItem(
                              store: snapshot.data[index],
                            ),
                          )
                      );
                    });
              } else {
                return NoData(
                  message: AppLocalizations.of(context).noResults,
                );
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(
                child: SpinKitThreeBounce(
                  color: cPrimaryColor,
                  size: 40,
                ));
          },
        );
      });

    });
  }


  Widget _buildBodyItem() {

    return ListView(
      children: <Widget>[
        SizedBox(
          height: _width*.12,
        ),
        Container(

          margin: EdgeInsets.only(right: _width*.01,left:  _width*.01),
          child: SliderImages(),
        ),

        Container(
            color: cWhite,
            width: _width,
            height:_width*.12,
            child: _buildCategoriesList()),
        Container(
            height: _height -_width*.6,
            child: _buildStoresOfCategory())
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _initialRun = false;
      _appState = Provider.of<AppState>(context);
      _locationState = Provider.of<LocationState>(context);

      if (_appState.currentUser != null) {

        _storeList = _getStores(
            'show_mtager_cat_filter?page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
      } else {
        _storeList = _getStores('show_mtager_cat_filter?page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&lang=${_appState.currentLang}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
     _categoriesList = _getCategories();

  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _storeState = Provider.of<StoreState>(context);
    _locationState = Provider.of<LocationState>(context);

    return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),
              _enableSearch
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      decoration: BoxDecoration(

                        color: Color(0xffF9F9F9),
                          boxShadow: [

                          ]),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xffF9F9F9),
                            borderRadius: BorderRadius.circular(23.0)),
                        child: TextFormField(
                            cursorColor: Color(0xffC5C5C5),
                            maxLines: 1,
                            onChanged: (text) {
                              print(text);
                              setState(() {


                                if (_appState.currentUser != null) {
                                  _storeList = _getStores(
                                      'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&sub=${_appState.selectedSub.mtgerCatId}&user_id=${_appState.currentUser.userId}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}&text=$text');
                                } else {
                                  _storeList = _getStores(
                                      'show_mtager_cat_filter?lang=${_appState.currentLang}&page=1&filter=${_appState.filter}&cat=${_appState.selectedCat.mtgerCatId}&sub=${_appState.selectedSub.mtgerCatId}&user_id=0&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}&text=$text');
                                }



                              });
                            },
                            style: TextStyle(
                                color: cBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23.0),
                                borderSide:
                                    BorderSide(color:Color(0xffF9F9F9)),
                              ),
                              focusColor: Color(0xffC5C5C5),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffC5C5C5)),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: cPrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _enableSearch = false;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 24,
                                color: cPrimaryColor,
                              ),
                              hintText: AppLocalizations.of(context).search,
                              errorStyle: TextStyle(fontSize: 12.0),
                              hintStyle: TextStyle(
                                  color: Color(0xffC5C5C5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )),
                      ))
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: GradientAppBar(
                        appBarTitle: _appState.selectedCatName,
                        leading: IconButton(
                          icon: Image.asset("assets/images/back.png"),
                          onPressed: () {
                            _appState.setCurrentFilter(1);

                            Navigator.pushNamed(context, '/navigation');
                          },
                        ),
                        trailing:  Row(
                          children: <Widget>[

                            IconButton(
                              icon: Image.asset("assets/images/filter.png"),
                              onPressed: () {


                                showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    context: context,
                                    builder: (builder) {
                                      return Container(
                                        height: _height*.50,
                                        child: FilterStores(),
                                      );
                                    });
                              },
                            ),


                            IconButton(
                              icon: Image.asset("assets/images/search.png"),
                              onPressed: () {
                                setState(() {
                                  _enableSearch = true;
                                });
                              },
                            ),




                          ],
                        )
                      ) ,
                    ),
            ],
          )),
    ));
  }
}
