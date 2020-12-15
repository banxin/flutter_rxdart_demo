// 所有bloc的基类
import 'package:flutter/material.dart';

// 所有Bloc的基类
abstract class BlocProviderBase {
  // 销毁stream
  void dispose();
}

// 通用的BlocProvider类
class BlocProvider<T extends BlocProviderBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({Key key, @required this.bloc, @required this.child})
      : super(key: key);

  @override
  _BlocProviderState createState() => _BlocProviderState();

  static T of<T extends BlocProviderBase>(BuildContext context) {
    // 返回最近的给定类型的父widget
    BlocProvider<T> provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    if (provider != null) {
      return provider.bloc;
    }
    return null;
  }
}

class _BlocProviderState<T> extends State<BlocProvider<BlocProviderBase>> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    // 因为多个block provider 共用一个bloc，widget销毁后由widget自己控制bloc的dispose
    // widget.bloc.dispose();
    super.dispose();
  }
}
