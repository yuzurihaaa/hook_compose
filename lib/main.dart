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

  ValueNotifier<List<String>> data1 = ValueNotifier(null);
  ValueNotifier<List<String>> data2 = ValueNotifier(null);

  ValueNotifier<String> selected1 = ValueNotifier(null);
  ValueNotifier<String> selected2 = ValueNotifier(null);

  @override
  void initState() {
    getMockData()
        .then((data) => withSort(data))
        .then((data) => data1.value = data);
    getMockData()
        .then((data) => withSortDescending(data))
        .then((data) => data2.value = data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                child: ValueListenableBuilder(
                  valueListenable: data1,
                  builder: (_, value, child) => AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: value != null
                        ? FormDropDown(
                            options: value,
                            attribute: 'selector1',
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder(
                  valueListenable: data2,
                  builder: (_, value, child) => AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: value != null
                        ? FormDropDown(
                            options: value,
                            attribute: 'selector2',
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: selected1,
                builder: (_, value, child) => ValueListenableBuilder(
                  valueListenable: selected2,
                  builder: (_, value2, child) {
                    if (value != null && value2 != null) {
                      return Text('Selected is $value and $value2');
                    }
                    return Container();
                  },
                ),
              ),
              MaterialButton(
                key: Key('my button'),
                child: Text('selected'),
                onPressed: () {
                  if (_formKey.currentState.saveAndValidate()) {
                    selected1.value = _formKey.currentState.value['selector1'];
                    selected2.value = _formKey.currentState.value['selector2'];
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
