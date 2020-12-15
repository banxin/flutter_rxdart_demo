import 'package:flutter_rxdart_demo/pages/bloc_demo/bloc_page.dart';
import 'package:flutter_rxdart_demo/pages/bloc_package_demo/bloc_package_page.dart';
import 'package:flutter_rxdart_demo/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page2.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_share_page.dart';
import 'package:flutter_rxdart_demo/pages/publish_page.dart';

class Router {
  static final String initialRoute = HomePage.routeName;

  static final Map<String, WidgetBuilder> routes = {
    HomePage.routeName: (ctx) => HomePage(),
    PublishPage.routeName: (ctx) => PublishPage(),
    BlockPage.routeName: (ctx) => BlockPage(),
    BlockPackagePage.routeName: (ctx) => BlockPackagePage(),
    ProviderPage.routeName: (ctx) => ProviderPage(),
    ProviderPage2.routeName: (ctx) => ProviderPage2(),
    ProviderSharePage.routeName: (ctx) => ProviderSharePage(),
  };

  static final RouteFactory unknownRoute = (settings) {
    return null;
  };
}
