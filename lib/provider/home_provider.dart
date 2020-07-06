import 'package:flutter/cupertino.dart';
import 'package:fluttertransport/model/home_model.dart';
import 'package:fluttertransport/services/service_method.dart';

class HomeProvider with ChangeNotifier {
  HomeModel homeModel;

  getHomeModels(time) async {
    homeModel = new HomeModel();

    notifyListeners();
  }
}
