import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertransport/pages/login/login_page.dart';
import 'package:fluttertransport/provider/home_provider.dart';
import 'package:fluttertransport/routers/application.dart';
import 'package:fluttertransport/routers/routes.dart';
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
      localeListResolutionCallback: (List<Locale> locales, Iterable<Locale> supportedLocales) {
        return Locale('zh');
      },
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        return Locale('zh');
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US')
      ],
      title: 'title',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
