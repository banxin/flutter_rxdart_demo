import 'dart:async';

import 'package:flutter_rxdart_demo/pages/bloc_package_demo/bloc_package.dart';
import 'package:rxdart/rxdart.dart';

// /// 合并 bloc
// class MergeBlocProvider extends BlocProviderBase {
//   NameBlocProvider _nameProvider;
//   CounterBlocProvider _counterProvider;
//   StreamSubscription _streamDemoSubscription;

//   NameBlocProvider get nameProvider => _nameProvider;
//   CounterBlocProvider get counterProvider => _counterProvider;

//   final PublishSubject<String> _showSub = PublishSubject<String>();
//   PublishSubject<String> get showSub => _showSub;

//   // 构造方法
//   MergeBlocProvider(this._counterProvider, this._nameProvider) {
//     _handleSubscript();
//   }

//   // 处理订阅
//   void _handleSubscript() {
//     _streamDemoSubscription = CombineLatestStream<dynamic, dynamic>(
//         [_counterProvider.counterSub, _nameProvider.nameSub], (values) {
//       print('合并的值是啥：${values.join(' + ')}');
//       return values.join(' + ');
//     }).asBroadcastStream().listen((value) {
//       _showSub.add(value);
//     });
//   }

//   // 销毁
//   void dispose() {
//     print('merge dispose 执行了');

//     _streamDemoSubscription.cancel();
//     _showSub.close();
//     _nameProvider.dispose();
//     _counterProvider.dispose();
//   }
// }

/// name bloc
class NameBlocProvider extends BlocProviderBase {
  String _name = 'name';

  BehaviorSubject<String> _nameSub = BehaviorSubject.seeded('name');
  BehaviorSubject<String> get nameSub => _nameSub;

  // 构造方法
  NameBlocProvider() {
    _handleSubscript();
  }

  // 增加操作
  void doAdd() {
    print('执行了 name 增加操作');

    _nameSub.add(_name + '1');
  }

  // 处理订阅
  void _handleSubscript() {
    // _nameSub.add(_name);
    _nameSub.listen((value) {
      _name = value;
    });
  }

  // 销毁
  void dispose() {
    _nameSub.close();
  }
}

/// 数值 bloc
class CounterBlocProvider extends BlocProviderBase {
  int _counter = 10;

  BehaviorSubject<int> _counterSub = BehaviorSubject.seeded(10);
  BehaviorSubject<int> get counterSub => _counterSub;

  // 构造方法
  CounterBlocProvider() {
    _handleSubscript();
  }

  // 增加操作
  void doAdd() {
    print('执行了 counter 增加操作');

    _counterSub.add(++_counter);
  }

  // 处理订阅
  void _handleSubscript() {
    _counterSub.listen((value) {
      _counter = value;
    });
  }

  // 销毁
  void dispose() {
    _counterSub.close();
  }
}
