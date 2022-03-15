



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ninan/components/app_repo/location_state.dart';
import 'package:ninan/models/cart_details.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/app_repo/navigation_state.dart';
import 'package:ninan/components/app_repo/product_state.dart';
import 'package:ninan/components/app_repo/store_state.dart';
import 'package:ninan/components/app_repo/progress_indicator_state.dart';
import 'package:ninan/components/buttons/custom_button.dart';
import 'package:ninan/components/connectivity/network_indicator.dart';
import 'package:ninan/components/no_data/no_data.dart';
import 'package:ninan/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:ninan/components/response_handling/response_handling.dart';
import 'package:ninan/locale/localization.dart';
import 'package:ninan/models/category.dart';
import 'package:ninan/models/product.dart';
import 'package:ninan/screens/store/components/store_appbar.dart';
import 'package:ninan/components/safe_area/page_container.dart';
import 'package:ninan/components/app_repo/store_state.dart';
import 'package:ninan/services/access_api.dart';
import 'package:ninan/utils/app_colors.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool _initialRun = true;
  double _height, _width;
  StoreState _storeState;
  AppState _appState;
  LocationState _locationState;
  ProductState _productState;
  Services _services = Services();
  Future<List<Category>> _categoriesList;
  Future<List<Product>> _productList;
  ProgressIndicatorState _progressIndicatorState;
  NavigationState _navigationState;
  Future<List<CartDetails>> _cartDetails;

  String cart_total;

  Future<List<Category>> _getCategories() async {
    Map<String, dynamic> results = await _services.get(
        'https://ninanapp.com/app/api/show_mtger_cats?id=${_storeState.currentStore.mtgerId}&lang=${_appState.currentLang}');
    List categoryList = List<Category>();
    if (results['response'] == '1') {
      Iterable iterable = results['cat'];
      categoryList = iterable.map((model) => Category.fromJson(model)).toList();
      if (categoryList.length > 0) {
        categoryList[0].isSelected = true;
      }
    } else {
      print('error');
    }
    return categoryList;
  }

  Future<List<Product>> _getProducts(String categoryId) async {
    Map<String, dynamic> results = await _services.get(
        'https://ninanapp.com/app/api/show_mtgerr?lang=${_appState.currentLang}&page=1&mtger_id=${_storeState.currentStore.mtgerId}&cat_id=$categoryId');
    List<Product> productList = List<Product>();
    if (results['response'] == '1') {
      Iterable iterable = results['results'];
      productList = iterable.map((model) => Product.fromJson(model)).toList();
    } else {
      print('error');
    }
    return productList;
  }



  Future<List<CartDetails>> _getCartDetails() async {
    Map<String, dynamic> results = await _services.get(
        'https://ninanapp.com/app/api/last_cart?user_id=${_appState.currentUser.userId}&user_mapx=${_locationState.locationLatitude}&user_mapy=${_locationState.locationlongitude}&lang=${_appState.currentLang}');
    List<CartDetails> cartDetails = List<CartDetails>();
    if (results['response'] == '1') {
      Iterable iterable = results['details'];
      cartDetails= iterable.map((model) => CartDetails.fromJson(model)).toList();
      setState(() {

        cart_total= cartDetails[0].total.toString();
print(cart_total);
        // print('sssssss'+xxx);
      });


    } else {
      print('error');
    }
    return cartDetails;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _storeState = Provider.of<StoreState>(context);
      _appState = Provider.of<AppState>(context);
      _productState = Provider.of<ProductState>(context);
      _locationState = Provider.of<LocationState>(context);
      _categoriesList = _getCategories();
      _cartDetails= _getCartDetails();
      _productList = _getProducts('0');
      _initialRun = false;
    }
  }

  Widget _buildCategoriesList() {
    print("swswswswsws");
    print(cart_total);
    print("swswswswsws");
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Category>>(
        future: _categoriesList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < snapshot.data.length; i++) {
                              snapshot.data[i].isSelected = false;
                            }
                            snapshot.data[index].isSelected = true;
                            _productList =
                                _getProducts(snapshot.data[index].mtgerCatId);

                          });
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                          /*decoration: BoxDecoration(
                            color: snapshot.data[index].isSelected
                                ? cLightLemon
                                : cWhite,
                            borderRadius: snapshot.data[index].isSelected
                                ? BorderRadius.circular(15.0)
                                : BorderRadius.circular(0),
                          ), */
                          child: Row(
                            children: <Widget>[
                             /* Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Image.network(
                                    snapshot.data[index].mtgerCatPhoto,
                                    height: 15,
                                    color: snapshot.data[index].isSelected
                                        ? cWhite
                                        : cLightLemon,
                                    width: 18,
                                  )), */
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5 ),
                                  child: Text(
                                    snapshot.data[index].mtgerCatName,
                                    style: TextStyle(
                                        color: snapshot.data[index].isSelected
                                            ? cText
                                            : cHintColor,
                                        fontSize: 13,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ))
                            ],
                          ),
                        ));
                  });
            } else {
              return Center(child: Text(AppLocalizations.of(context).noDepartments));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
              child: SpinKitSquareCircle(color: cPrimaryColor, size: 25));
        },
      );
    });
  }

  Widget _buildProducts() {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          _productState.setCurrentProduct(snapshot.data[index]);

                          Navigator.pushNamed(context, '/product_screen');
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                              top: 10,
                              left: 12,
                              right: 12,
                              bottom:
                                  index == snapshot.data.length - 1 ? 20 : 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: Color(0xffEBEBEB)),
                              color: Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular(
                                10.0,
                              )),
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 10, right: 10 ,left: 10),
                                    child: Text(
                                      snapshot.data[index].adsMtgerName,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        color: cText

                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: _width*.55,
                                    padding:
                                    EdgeInsets.only(bottom: 10, right: 10 ,left: 10),
                                    child: Text(
                                      snapshot.data[index].adsMtgerDetails,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 13,
                                        color: Color(0xffBEBEBE)

                                      ),
                                    ),
                                  ),



                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 2,
                                           bottom: 5,
                                            right: 10),
                                        child: Image.asset(
                                          'assets/images/wheatsm.png',
                                          color: cPrimaryColor,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                            right: 5, left: 5,
                                            top: 5
                                          ),
                                          child: Text(
                                            snapshot.data[index].adsMtgerPrice,
                                            style: TextStyle(
                                                color: cText,
                                              fontSize: 13

                                            ),
                                          )),
                                      Container(

                                        child: Text(
                                         AppLocalizations.of(context).sr,
                                          style: TextStyle(
                                              color: cPrimaryColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),




                                    ],
                                  ),

                                ],
                              ),
                              Spacer(),
                              Container(
                                 padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Color(0xffEBEBEB)),
                                    color: Color(0xffF5F2F2),
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    )),
                                child: Image.network(
                                  snapshot.data[index].adsMtgerPhoto,
                                  width:
                                      100,
                                ),
                              )
                            ],
                          ),
                        ));
                  });
            } else {
              return NoData(
                message: AppLocalizations.of(context).noResults
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
  }

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: _height * 0.22,
        ),
        Container(width: _width,
          alignment: Alignment.center,
          child:  Column(
            children: <Widget>[
              Text(
                  _storeState.currentStore.mtgerName,
                style: TextStyle(
                  color: cText,
                  fontSize: 18,

                ),
              ),
              SizedBox(
                height: _height * 0.01,
              ),
              Text(
                _storeState.currentStore.mtgerAdress,
                style: TextStyle(
                  color: cHintColor,
                  fontSize: 13,

                ),
              ),
              SizedBox(
                height: _height * 0.01,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/km.png"),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    _storeState.currentStore.distance.toString()+" كم",
                    style:
                    TextStyle(fontSize: 14, color: cText),
                  ),

                  Padding(padding: EdgeInsets.only(left: _width*.07)),

                  Image.asset("assets/images/time.png"),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    _storeState.currentStore.fromTime.toString()+"-"+_storeState.currentStore.toTime.toString(),
                    style:
                    TextStyle(fontSize: 14, color: cText),
                  ),
                  Padding(padding: EdgeInsets.only(left: _width*.07)),

                  Image.asset("assets/images/tawsil.png"),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    _storeState.currentStore.deliveryPrice.toString()+" SR",
                    style:
                    TextStyle(fontSize: 14, color: cText),
                  )

                ],
              ),
              SizedBox(
                height: _height * 0.01,
              ),
              Stack(
                children: <Widget>[
                  Image.asset("assets/images/rate.png"),
                  Positioned(
                    left: 15,
                      top: 7,
                      child:Column(
                        children: <Widget>[
                          Text(
                            _storeState.currentStore.mtgerRate.toString(),
                            style:
                            TextStyle(fontSize: 15, color: cText),
                          ),
                          Text(
                            _storeState.currentStore.mtgerRateNumber.toString()+" تقييم",
                            style:
                            TextStyle(fontSize: 11, color: cHintColor),
                          ),
                        ],
                      )
                  )
                ],
              ),

            ],
          ),
        ),
        SizedBox(
          height: _height * 0.01,
        ),
        Container(
            width: _width, height: _width*.12,
            child: _buildCategoriesList(),
            margin: EdgeInsets.only(right: _width*.02,left: _width*.02),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 7),
          height: _height-(_width*.85),
          child: _buildProducts(),

        ),


      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _navigationState = Provider.of<NavigationState>(context);
    return NetworkIndicator( child:PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[

          _buildBodyItem(),

          AnimatedPositioned(
              duration: Duration(seconds: 5),
              top: 0, left: 0, right: 0, child: StoreAppBar()
          ),
          AnimatedPositioned(
             duration: Duration(microseconds: 500),
              top: 37,
              left: MediaQuery.of(context).size.width * 0.36,
              child:
                  Consumer<StoreState>(builder: (context, storeState, child) {
    
              return
                Container(

                  padding: EdgeInsets.all(15),

                    decoration: new BoxDecoration(
                      color: Colors.white,
                        border:
                        Border.all(color: Color(0xff1F61301A), width: 1.0),
                   ),

                  child:  Container(
                      width: 80,
                      height: 80,
                    alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          border:
                          Border.all(color: Color(0xff1F61301A), width: 1.0),
                          shape: BoxShape.circle,
                          image:  DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(
                                storeState.currentStore.mtgerPhoto,
                              )))),
                );
     
              })),

          cart_total!=null && cart_total!="0"?Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/cart_screen');
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 3),

                    padding: EdgeInsets.all(15),
                    width: _width,
                    color: cPrimaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("سلة المشريات",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                       Spacer(),
                        Text(cart_total!=null?cart_total.toString():"0",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.all(3)),
                        Text("ريال",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold))
                      ],
                    )
                ),
              )
          ):Text(""),

          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
