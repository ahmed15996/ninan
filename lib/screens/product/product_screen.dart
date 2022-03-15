import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/app_repo/navigation_state.dart';
import 'package:ninan/components/app_repo/product_state.dart';
import 'package:ninan/components/app_repo/store_state.dart';
import 'package:ninan/components/app_repo/progress_indicator_state.dart';
import 'package:ninan/components/connectivity/network_indicator.dart';
import 'package:ninan/components/gradient_app_bar/gradient_app_bar.dart';
import 'package:ninan/components/horizontal_divider/horizontal_divider.dart';
import 'package:ninan/components/progress_indicator_component/progress_indicator_component.dart';
import 'package:ninan/components/response_handling/response_handling.dart';
import 'package:ninan/components/safe_area/page_container.dart';
import 'package:ninan/locale/localization.dart';
import 'package:ninan/models/product_details.dart';
import 'package:ninan/services/access_api.dart';
import 'package:ninan/utils/app_colors.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  double _height, _width;
  ProgressIndicatorState _progressIndicatorState;
  ProductState _productState;
  bool _initialRun = true;
  Services _services = Services();
  Future<ProductDetails> _productDetails;
  AppState _appState;
  StoreState _storeState;
  NavigationState _navigationState;
  int amountt=1;

  Future<ProductDetails> _getProductDetails() async {
    Map<String, dynamic> results = await _services.get(
        'https://ninanapp.com/app/api/show_mtger_ads?lang=${_appState.currentLang}&id=${_productState.currentProduct.adsMtgerId}');
    ProductDetails productDetails = ProductDetails();
    if (results['response'] == '1') {
      productDetails = ProductDetails.fromJson(results['details']);
    } else {
      print('error');
    }
    return productDetails;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _productState = Provider.of<ProductState>(context);
      _appState = Provider.of<AppState>(context);
      _storeState = Provider.of<StoreState>(context);
      _productDetails = _getProductDetails();
      _initialRun = false;
    }
  }

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Container(
          height: _height,
          child: FutureBuilder<ProductDetails>(
              future: _productDetails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Color(0xffF8F8F8),
                        height: _height * 0.35,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: _height * 0.02),
                          child: Image.network(
                            _productState.currentProduct.adsMtgerPhoto,
                            height: _height * 0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          snapshot.data.adsMtgerName,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10, bottom: 5 ,left: 10),
                            child: Image.asset(
                              'assets/images/wheatsm.png',
                              color: cPrimaryColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 5,
                              left: 5,
                                top: 4,
                                bottom: 5

                            ),
                            child: Text(
                              snapshot.data.adsMtgerCat,
                              style: TextStyle(
                                  color: cText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Text(
                          AppLocalizations.of(context).productDetails,
                          style: TextStyle(
                              fontSize: 16,
                              color: cPrimaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 10,top: 5),
                        child: Text(
                         AppLocalizations.of(context).allProductDetails,
                          style:
                              TextStyle(color: Color(0xffC5C5C5), fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                        child: Text(
                          snapshot.data.adsMtgerContent,
                          style: TextStyle(color: Color(0xffBEBEBE), fontSize: 15),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 50,


                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(

                              child: Row(
                                children: <Widget>[


                                  FloatingActionButton(
                                    elevation: 0,
                                    backgroundColor: cWhite,
                                    heroTag: 'btn ',
                                    child: Image.asset("assets/images/plus.png"),
                                    onPressed: () async {
                                      print('amount');
                                      setState(() {
                                     amountt++;
                                      });


                                    },
                                  ),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    child: Center(
                                      child: Text(
                                        amountt.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: cText),
                                      ),
                                    ),

                                  ),
                                  FloatingActionButton(
                                    elevation: 0,
                                    backgroundColor: cWhite,
                                    heroTag: 'btn1 ',
                                    child: Image.asset("assets/images/minus.png"),
                                    onPressed: () async {
                                      setState(() {
                                        amountt--;
                                      });


                                    },
                                  ),


                                ],
                              ),

                              width: _width*.35,
                            ),

                           Container(
                             padding: EdgeInsets.all(15),
                             width: _width*.55,

                             decoration: BoxDecoration(
                                 color: cPrimaryColor,
                                 borderRadius: BorderRadius.all( Radius.circular(6.00)),
                              ),
                             child:  GestureDetector(
                               onTap: () async {
                                 if (_appState.currentUser != null) {
                                   _progressIndicatorState.setIsLoading(true);
                                   var results = await _services.get(
                                     'https://ninanapp.com/app/api/add_cart?user_id=${_appState.currentUser.userId}&ads_id=${_productState.currentProduct.adsMtgerId}&amountt=$amountt&lang=${_appState.currentLang}',
                                   );
                                   _progressIndicatorState.setIsLoading(false);
                                   if (results['response'] == '1') {

                                     _storeState.setCurrentIsAddToCart(1);
                                     Navigator.pushNamed(context, '/store_screen');
                                     showToast(results['message'], context);
                                   } else {
                                     showErrorDialog(
                                         results['message'], context);
                                   }
                                 } else {
                                   Navigator.pushNamed(context, '/login_screen');
                                 }
                               },
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[

                                   Container(
                                     margin: EdgeInsets.symmetric(horizontal: 2),
                                     child: Text(
                                       AppLocalizations.of(context).addToCart,
                                       style: TextStyle(
                                           color: cWhite,
                                           fontSize: 14,
                                           fontWeight: FontWeight.w400),
                                     ),
                                   ),

                                   Container(
                                       margin: EdgeInsets.only(
                                         right: 5,
                                       ),
                                       child: Row(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Container(

                                               margin: EdgeInsets.only(
                                                   left: 5
                                               ),
                                               child: Text(
                                                 snapshot.data.adsMtgerPrice,
                                                 style: TextStyle(
                                                     fontSize: 14,
                                                     color: cWhite,
                                                     fontWeight: FontWeight.w700),
                                               )),
                                           Container(
                                             child: Text(
                                               AppLocalizations.of(context).sr,
                                               style: TextStyle(
                                                   color: cWhite,
                                                   fontSize: 13,
                                                   fontWeight: FontWeight.w400),
                                             ),
                                           )
                                         ],
                                       )),


                                 ],
                               ),
                             ),
                           )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _height*.01,
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(
                    child: SpinKitThreeBounce(
                  color: cPrimaryColor,
                  size: 40,
                ));
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _progressIndicatorState = Provider.of<ProgressIndicatorState>(context);
    _navigationState = Provider.of<NavigationState>(context);
    return  NetworkIndicator( child:PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientAppBar(
                appBarTitle: "",
                  leading: _appState.currentLang == 'ar' ? IconButton(
                icon: IconButton(
                  icon: Image.asset("assets/images/back2.png"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) :Container(),
              trailing: _appState.currentLang == 'en' ? IconButton(
                icon: Image.asset("assets/images/back2.png"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ) :Container()),
          ),
          Center(
            child: ProgressIndicatorComponent(),
          )
        ],
      )),
    ));
  }
}
