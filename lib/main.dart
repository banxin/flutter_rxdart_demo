import 'package:flutter/material.dart';
import 'package:flutter_rxdart_demo/router/router.dart';
import 'package:provider/provider.dart';
import 'pages/provider_demo/counter_bloc.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (ctx) => CounterBlocProvider()),
      Provider(create: (ctx) => NameBlocProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rx Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: Router.routes,
      initialRoute: Router.initialRoute,
      onUnknownRoute: Router.unknownRoute,
    );
  }
}
