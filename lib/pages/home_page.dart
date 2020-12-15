import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rxdart_demo/pages/bloc_demo/bloc_page.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page.dart';
import 'package:flutter_rxdart_demo/pages/publish_page.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page2.dart';

import 'bloc_package_demo/bloc_package_page.dart';
import 'provider_demo/provider_share_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> titles = [
    "publish 测试",
    "bloc 测试",
    "bloc package 测试",
    "provider 测试",
    "provide2 测试",
    "provide share 测试",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('state manager'),
      ),
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 80,
              child: Text(
                titles[index],
                style: TextStyle(fontSize: 24),
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, Random().nextInt(256),
                      Random().nextInt(256), Random().nextInt(256)),
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 10))),
            ),
            onTap: () {
              String routeName;
              switch (index) {
                case 0:
                  routeName = PublishPage.routeName;
                  break;
                case 1:
                  routeName = BlockPage.routeName;
                  break;
                case 2:
                  routeName = BlockPackagePage.routeName;
                  break;
                case 3:
                  routeName = ProviderPage.routeName;
                  break;
                case 4:
                  routeName = ProviderPage2.routeName;
                  break;
                case 5:
                  routeName = ProviderSharePage.routeName;
                  break;
              }
              Navigator.pushNamed(context, routeName);
            },
          );
        }, childCount: titles.length)),
      ]),
    );
  }
}
