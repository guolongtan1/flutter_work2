import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart' hide Router;
import 'package:fluttertransport/routers/router_handler.dart';

class Routes {
  static String root = '/';
  static String indexPage = '/index';
  static void configureRoutes(Router router) {
    router.define(indexPage, handler: indexHandler);
    router.notFoundHandler = emptyHandler;
  }
}
