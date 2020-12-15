import 'package:flutter/material.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/counter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page.dart';
import 'package:rxdart/rxdart.dart';

class ProviderPage2 extends StatefulWidget {
  static const String routeName = "/providerPage2";

  const ProviderPage2({Key key}) : super(key: key);

  @override
  _ProviderPage2State createState() => _ProviderPage2State();
}

class _ProviderPage2State extends State<ProviderPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('name provider page'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Navigator.pushNamed(context, ProviderPage.routeName);
                })
          ],
        ),
        body: Center(
          child: Consumer2<CounterBlocProvider, NameBlocProvider>(
              builder: (context, cntProvider, nameProvider, child) {
            return StreamBuilder(
                initialData: '初始化',
                stream: CombineLatestStream<dynamic, dynamic>(
                    [cntProvider.counterSub, nameProvider.nameSub], (values) {
                  print('合并的值是啥：${values.join(' + ')}');
                  return values.join(' + ');
                }),
                builder: (context, snapshot) {
                  return Chip(label: Text(snapshot.data));
                });
          }),
        ),
        floatingActionButton: Consumer2<CounterBlocProvider, NameBlocProvider>(
          builder: (context, cntProvider, nameProvider, child) {
            return FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  nameProvider.doAdd();
                });
          },
        ));
  }
}
