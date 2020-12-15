import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'basic_provider_sec_page.dart';
import 'counter_view_model.dart';
import 'user_view_model.dart';

class BasicProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("测试"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BasicProviderSecondPage()),
                );
                // Navigetor
              })
        ]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ShowData01(),
              ShowData02(),
              ShowData03(),
            ],
          ),
        ),
        floatingActionButton: Selector<CounterViewModel, CounterViewModel>(
          selector: (ctx, counterVM) => counterVM,
          shouldRebuild: (prev, next) => false,
          builder: (ctx, counterVM, child) {
            print("floatingActionButton build方法被执行");
            return FloatingActionButton(
              child: child,
              onPressed: () {
                counterVM.counter += 1;
              },
            );
          },
          child: Icon(Icons.add),
        ));
  }
}

class ShowData01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 3.在其它位置使用共享的数据
    int counter = Provider.of<CounterViewModel>(context).counter;

    print("data01的build方法");

    return Container(
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          Text(
            "当前计数: $counter",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class ShowData02 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("data02的build方法");

    return Container(
      color: Colors.red,
      child: Consumer<CounterViewModel>(
        builder: (ctx, counterVM, child) {
          print("data02 Consumer build方法被执行");
          return Text(
            "当前计数: ${counterVM.counter}",
            style: TextStyle(fontSize: 30),
          );
        },
      ),
    );
  }
}

class ShowData03 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider.of Consumer Selector Consumer2
    return Consumer2<UserViewModel, CounterViewModel>(
      builder: (ctx, userVM, counterVM, child) {
        return Text(
          "nickname:${userVM.user.nickname} counter:${counterVM.counter}",
          style: TextStyle(fontSize: 30),
        );
      },
    );
  }
}
