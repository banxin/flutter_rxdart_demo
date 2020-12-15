import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'basic_provider_page.dart';
import 'counter_view_model.dart';
import 'user_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (ctx) => CounterViewModel(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => UserViewModel(UserInfo("why", 29, "abc")),
      ),
    ],
    child: MyApp(),
  ));

//  runApp(
//    // 2.在应用程序的顶层ChangeNotifierProvider
//    ChangeNotifierProvider(
//      create: (ctx) => HYCounterViewModel(),
//      child: ChangeNotifierProvider(
//        create: (ctx) => HYUserViewModel(userInfo),
//        child: MyApp(),
//      ),
//    )
//  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, splashColor: Colors.transparent),
      home: BasicProviderPage(),
    );
  }
}
