import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ninan/components/app_repo/app_state.dart';
import 'package:ninan/components/no_data/no_data.dart';
import 'package:ninan/locale/localization.dart';
import 'package:ninan/models/order.dart';
import 'package:ninan/screens/orders/components/waiting_order.dart';
import 'package:ninan/services/access_api.dart';
import 'package:ninan/utils/app_colors.dart';

class WaitingOrders extends StatefulWidget {
  @override
  _WaitingOrdersState createState() => _WaitingOrdersState();
}

class _WaitingOrdersState extends State<WaitingOrders> {
  bool _initialRun = true;
  AppState _appState;
  Services _services = Services();
  Future<List<Order>> _orderList;

  Future<List<Order>> _getOrderList() async {
    Map<String, dynamic> results = await _services.get(
        'https://ninanapp.com/app/api/dis_buy?lang=${_appState.currentLang}&user_id=${_appState.currentUser.userId}&page=1&done=0');
    List orderList = List<Order>();
    if (results['response'] == '1') {
      Iterable iterable = results['result'];
      orderList = iterable.map((model) => Order.fromJson(model)).toList();
    } else {
      print('error');
    }
    return orderList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _appState = Provider.of<AppState>(context);
      _orderList = _getOrderList();
      _initialRun = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Order>>(
      future: _orderList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 110,
                      ),
                      Container(
                         height: height - 180 ,
                        width: width,
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 220,
                                child: WaitingOrder(
                                  order: snapshot.data[index],
                                ),
                              );
                            }),
                      )
                    ],
                  );
               
          } else {
            return NoData(
              message: AppLocalizations.of(context).noResults,
            );
          }
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        return Center(
            child: SpinKitThreeBounce(
          color: cPrimaryColor,
          size: 40,
        ));
      },
    );
  }
}
