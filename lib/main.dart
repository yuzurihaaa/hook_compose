import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'form_drop_down.dart';

void main() => runApp(MyApp(
      child: MyHomePage(title: 'Hook Compose Demo'),
    ));

class MyApp extends StatelessWidget {
  final Widget child;

  const MyApp({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hook Compose Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> data1;
  List<String> data2;
  String selected1;
  String selected2;

  @override
  void initState() {
    getMockData().then((data) => setState(() => data1 = data));
    getMockData().then((data) => setState(() => data2 = data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = selected1 != null && selected2 != null;
    print('rendered');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FormBuilder(
          key: _formKey,
          initialValue: {'state2': ''},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: data1 != null
                      ? FormDropDown(
                          options: withSort(data1),
                          attribute: 'selector1',
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: data2 != null
                      ? FormDropDown(
                          options: withSortDescending(data2),
                          attribute: 'selector2',
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              if (hasValue) Text('Selected is $selected1 and $selected2'),
              MaterialButton(
                key: Key('my button'),
                child: Text('selected'),
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    setState(() {
                      selected1 = _formKey.currentState.value['selector1'];
                      selected2 = _formKey.currentState.value['selector2'];
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef MockApi = Future<List<String>> Function();

List<String> withSort(List<String> strings) {
  if (strings == null) {
    return null;
  }
  final currentList = [...strings];
  currentList.sort((a, b) => a.codeUnitAt(0).compareTo(b.codeUnitAt(0)));
  return currentList;
}

List<String> withSortDescending(List<String> strings) {
  if (strings == null) {
    return null;
  }
  final currentList = [...strings];
  currentList.sort((a, b) => b.codeUnitAt(0).compareTo(a.codeUnitAt(0)));
  return currentList;
}

Future<List<String>> getMockData() {
  print("fetched");
  return Future.delayed(
      const Duration(seconds: 2), () => ['Malaysia', 'Indonesia', 'Singapore']);
}
