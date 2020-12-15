import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_view_model.dart';

class BasicProviderSecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第二个页面"),
      ),
      floatingActionButton: Consumer<CounterViewModel>(
        builder: (ctx, counterPro, child) {
          return FloatingActionButton(
            child: child,
            onPressed: () {
              counterPro.counter += 1;
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
