import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// 登录 bloc
class LoginBloc {
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
  LoginBloc() {
    _handleSubscript();
  }

  // 登录操作
  void doLogin() async {
    await Future.delayed(Duration(seconds: 3));

    print('登录成功 => 用户名：$_account, 密码：$_password');

    _loginSub.sink.add('登录成功~');
  }

  // 销毁
  void dispose() {
    _accountSub.close();
    _passwordSub.close();
    _validSub.close();
    _loginSub.close();
  }

  // 处理订阅
  void _handleSubscript() {
    CombineLatestStream<String, bool>([_accountSub, _passwordSub], (values) {
      return values.first.length >= 6 &&
          values.first.length <= 20 &&
          values.last.length >= 6 &&
          values.last.length <= 12;
    }).listen((value) {
      _validSub.sink.add(value);
    });

    _accountSub.listen((value) {
      _account = value;
    });

    _passwordSub.listen((value) {
      _password = value;
    });
  }
}

class LoginProvider extends InheritedWidget {
  final Widget child;
  final LoginBloc bloc;

  LoginProvider({@required this.child, @required this.bloc})
      : super(child: child);

  static LoginProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LoginProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class BlockPage extends StatelessWidget {
  static const String routeName = "/blocPage";

  const BlockPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bloc Test'),
      ),
      body: BlockPageHome(),
    );
  }
}

class BlockPageHome extends StatefulWidget {
  BlockPageHome({Key key}) : super(key: key);

  @override
  _BlockPageHomeState createState() => _BlockPageHomeState();
}

class _BlockPageHomeState extends State<BlockPageHome> {
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = LoginBloc();
  }

  @override
  Widget build(BuildContext context) {
    return LoginProvider(
      bloc: _bloc,
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
    _bloc.dispose();

    super.dispose();
  }
}

class LoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _block = LoginProvider.of(context).bloc;

    return Container(
        width: 128,
        height: 48,
        child: StreamBuilder(
          stream: _block.validSub,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return FlatButton(
              color: Colors.blueAccent,
              disabledColor: Colors.blueAccent.withAlpha(50),
              child: Text(
                '登录',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: snapshot.data
                  ? () {
                      print('点击了登录');

                      _block.doLogin();
                    }
                  : null,
            );
          },
        ));
  }
}

class PasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _block = LoginProvider.of(context).bloc;

    return TextField(
      obscureText: true,
      onChanged: (value) {
        _block.passwordSub.add('$value');
      },
      decoration: InputDecoration(
        labelText: '密码',
        filled: true,
      ),
    );
  }
}

class AccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _block = LoginProvider.of(context).bloc;

    return TextField(
      onChanged: (value) {
        _block.accountSub.add('$value');
      },
      decoration: InputDecoration(
        labelText: '用户名',
        filled: true,
      ),
    );
  }
}

class LoginAccountWidget extends StatelessWidget {
  const LoginAccountWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _block = LoginProvider.of(context).bloc;

    return Container(
        width: double.infinity,
        height: 40,
        color: Colors.black12,
        child: Center(
          child: StreamBuilder(
            stream: _block.accountSub.where((origin) {
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
          ),
        ));
  }
}

class LoginStateWidget extends StatelessWidget {
  const LoginStateWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _block = LoginProvider.of(context).bloc;

    return Container(
        width: double.infinity,
        height: 40,
        color: Colors.black12,
        child: Center(
          child: StreamBuilder(
            stream: _block.loginSub,
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
