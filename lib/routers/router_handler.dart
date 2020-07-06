import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertransport/pages/empty_page.dart';
import 'package:fluttertransport/pages/index_page.dart';

Handler emptyHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EmptyPage();
});
Handler indexHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return IndexPage();
});
