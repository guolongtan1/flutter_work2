import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertransport/pages/index_page.dart';
import 'package:fluttertransport/pages/login/login_page.dart';
import 'package:fluttertransport/provider/home_provider.dart';
import 'package:fluttertransport/routers/application.dart';
import 'package:fluttertransport/routers/routes.dart';
import 'package:fluttertransport/services/service_method.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(ChangeNotifierProvider(
    create: (context) => HomeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Router router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return MaterialApp(
      title: 'title',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
