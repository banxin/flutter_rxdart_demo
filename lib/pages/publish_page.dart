import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PublishPage extends StatefulWidget {
  static const String routeName = "/publishPage";

  PublishPage({Key key}) : super(key: key);

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  PublishSubject<String> _textFieldSubject = PublishSubject<String>();
  PublishSubject<String> _pwdSubject = PublishSubject<String>();
  String _account = '';
  String _password = '';
  bool _isValidInput = false;

  @override
  void initState() {
    super.initState();

    _handleObserver();
    _testRx();
  }

  void _testRx() {
    // Stream.fromIterable([1, 2, 3, 4, 5, 6])
    //     .where((item) => item > 2 && item < 5)
    //     .listen((item) => print('订阅到了：$item'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Test'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Container(
              width: double.infinity,
              height: 40,
              color: Colors.black12,
              child: Center(
                child: StreamBuilder(
                  stream: _textFieldSubject.where((origin) {
                    // 丢弃
                    return origin.length >= 6 && origin.length <= 20;
                  }).debounceTime(Duration(milliseconds: 500)),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text(
                      "输入的用户名：${snapshot.data == null ? '' : snapshot.data}",
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              )),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (value) {
              _textFieldSubject.add('$value');
            },
            onSubmitted: (value) {
              _textFieldSubject.add('$value');
            },
            decoration: InputDecoration(
              labelText: '用户名',
              filled: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: true,
            onChanged: (value) {
              _pwdSubject.add('$value');
            },
            onSubmitted: (value) {
              _pwdSubject.add('$value');
            },
            decoration: InputDecoration(
              labelText: '密码',
              filled: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: 128,
              height: 48,
              child: FlatButton(
                color: Colors.blueAccent,
                disabledColor: Colors.blueAccent.withAlpha(50),
                child: Text(
                  '登录',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _isValidInput
                    ? () {
                        print('点击了登录 => 用户名：$_account, 密码：$_password');
                      }
                    : null,
              ))
        ],
      ),
    );
  }

  // 处理监听
  void _handleObserver() {
    CombineLatestStream<String, bool>([_textFieldSubject, _pwdSubject],
        (values) {
      return values.first.length >= 6 &&
          values.first.length <= 20 &&
          values.last.length >= 6 &&
          values.last.length <= 12;
    }).listen((value) {
      setState(() {
        _isValidInput = value;
      });
    });

    // MergeStream(streams)

    _textFieldSubject
        .where((origin) {
          // 丢弃
          return origin.length >= 6 && origin.length <= 20;
        })
        .debounceTime(Duration(milliseconds: 500))
        // .map((origin) {
        //   return '做了map操作：$origin';
        // })
        .listen((data) {
          print('订阅到了：$data');
          setState(() {
            _account = data;
          });
        });

    _pwdSubject
        .where((origin) {
          // 丢弃
          return origin.length >= 6 && origin.length <= 12;
        })
        .debounceTime(Duration(milliseconds: 500))
        // .map((origin) {
        //   return '做了map操作：$origin';
        // })
        .listen((data) {
          print('订阅到了：$data');
          setState(() {
            _password = data;
          });
        });
  }

  @override
  void dispose() {
    super.dispose();

    _textFieldSubject.close();
    _pwdSubject.close();
  }
}
