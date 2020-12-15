import 'package:flutter/material.dart';
import 'package:flutter_rxdart_demo/pages/bloc_package_demo/bloc_package.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// 登录 bloc
class LoginBlocProvider extends BlocProviderBase {
  String _account = '';
  String _password = '';

  final PublishSubject<String> _accountSub = PublishSubject<String>();
  PublishSubject<String> get accountSub => _accountSub;

  final PublishSubject<String> _passwordSub = PublishSubject<String>();
  PublishSubject<String> get passwordSub => _passwordSub;

  final PublishSubject<bool> _validSub = PublishSubject<bool>();
  PublishSubject<bool> get validSub => _validSub;

  final PublishSubject<String> _loginSub = PublishSubject<String>();
  PublishSubject<String> get loginSub => _loginSub;

  // 构造方法
  LoginBlocProvider() {
    _handleSubscript();
  }

  // 登录操作
  void doLogin() async {
    await Future.delayed(Duration(seconds: 3));

    print('登录成功 => 用户名：$_account, 密码：$_password');

    _loginSub.sink.add('登录成功~');
  }

  // 处理订阅
  void _handleSubscript() {
    CombineLatestStream<String, bool>([_accountSub, _passwordSub], (values) {
      return values.first.length >= 6 &&
          values.first.length <= 20 &&
          values.last.length >= 6 &&
          values.last.length <= 12;
    }).listen((value) {
      _validSub.add(value);
    });

    _accountSub.listen((value) {
      _account = value;
    });

    _passwordSub.listen((value) {
      _password = value;
    });
  }

  // 销毁
  void dispose() {
    _accountSub.close();
    _passwordSub.close();
    _validSub.close();
    _loginSub.close();
  }
}

class ProviderSharePage extends StatelessWidget {
  static const String routeName = "/providerSharePage";

  const ProviderSharePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('provider share Test'),
      ),
      body: ProviderSharePageHome(),
    );
  }
}

class ProviderSharePageHome extends StatefulWidget {
  ProviderSharePageHome({Key key}) : super(key: key);

  @override
  _ProviderSharePageHomeState createState() => _ProviderSharePageHomeState();
}

class _ProviderSharePageHomeState extends State<ProviderSharePageHome> {
  LoginBlocProvider _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = LoginBlocProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (ctx) => _bloc,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          LoginAccountWidget(),
          SizedBox(
            height: 10,
          ),
          AccountWidget(),
          SizedBox(
            height: 10,
          ),
          PasswordWidget(),
          SizedBox(
            height: 10,
          ),
          LoginButtonWidget(),
          SizedBox(
            height: 10,
          ),
          LoginStateWidget(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }
}

class LoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 128,
        height: 48,
        child: Consumer<LoginBlocProvider>(
          builder: (context, _bloc, child) {
            return StreamBuilder(
              stream: _bloc.validSub,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return FlatButton(
                  color: Colors.blueAccent,
                  disabledColor: Colors.blueAccent.withAlpha(50),
                  child: child,
                  onPressed: snapshot.data
                      ? () {
                          print('点击了登录');
                          _bloc.doLogin();
                        }
                      : null,
                );
              },
            );
          },
          child: Text(
            '登录',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}

class PasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginBlocProvider>(builder: (ctx, _bloc, chile) {
      return TextField(
        obscureText: true,
        onChanged: (value) {
          _bloc.passwordSub.add('$value');
        },
        decoration: InputDecoration(
          labelText: '密码',
          filled: true,
        ),
      );
    });
  }
}

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginBlocProvider>(builder: (ctx, _bloc, child) {
      return TextField(
        onChanged: (value) {
          _bloc.accountSub.add('$value');
        },
        decoration: InputDecoration(
          labelText: '用户名',
          filled: true,
        ),
      );
    });
  }
}

class LoginAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 40,
        color: Colors.black12,
        child: Center(
          child: Consumer<LoginBlocProvider>(builder: (ctx, _bloc, child) {
            return StreamBuilder(
              stream: _bloc.accountSub.where((origin) {
                // 丢弃
                return origin.length >= 6 && origin.length <= 20;
              }).debounceTime(Duration(milliseconds: 500)),
              initialData: '',
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Text(
                  "输入的用户名：${snapshot.data.isEmpty ? '' : snapshot.data}",
                  style: TextStyle(color: Colors.red),
                );
              },
            );
          }),
        ));
  }
}

class LoginStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<LoginBlocProvider>(context);

    return Container(
        width: double.infinity,
        height: 40,
        color: Colors.black12,
        child: Center(
          child: StreamBuilder(
            stream: _bloc.loginSub,
            initialData: '未登录',
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Text(
                snapshot.data,
                style: TextStyle(color: Colors.red),
              );
            },
          ),
        ));
  }
}
