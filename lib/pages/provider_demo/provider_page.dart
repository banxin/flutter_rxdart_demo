import 'package:flutter/material.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/counter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rxdart_demo/pages/provider_demo/provider_page2.dart';
import 'package:rxdart/rxdart.dart';

class ProviderPage extends StatefulWidget {
  static const String routeName = "/providerPage";

  const ProviderPage({Key key}) : super(key: key);

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('counter provider page'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  Navigator.pushNamed(context, ProviderPage2.routeName);
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
                  cntProvider.doAdd();
                });
          },
        ));
  }
}
