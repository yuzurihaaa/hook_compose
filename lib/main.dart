import 'package:compose/compose.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'form_drop_down.dart';

void main() =>
    runApp(MyApp(
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

class MyHomePage extends HookWidget {
  final String title;

  const MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    final _formKey = useFormKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: FormBuilder(
          key: _formKey,
          initialValue: {'state2': ''},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HookBuilder(
                builder: (_) {
                  final Widget firstDropDown = c() >>
                      useApi >>
                      sortAscending >>
                      dropDownWithList('state accending') <
                      getMockData;

                  return firstDropDown;
                },
              ),
              HookBuilder(
                builder: (_) {
                  final Widget secondDropDown = c() >>
                      useApi >>
                      sortDescending >>
                      dropDownWithList('state decending') <
                      getMockData;

                  return secondDropDown;
                },
              ),
              HookBuilder(
                builder: (_) {
                  final selected1 = useState('');
                  final selected2 = useState('');

                  final bool hasValue =
                      selected1.value.isNotEmpty && selected2.value.isNotEmpty;

                  return Column(
                    children: <Widget>[
                      if (hasValue)
                        Text('Selected is ${selected1.value} and ${selected2
                            .value}'),
                      MaterialButton(
                        key: Key('my button'),
                        child: Text('selected'),
                        onPressed: () {
                          if (_formKey.currentState.saveAndValidate()) {
                            selected1.value =
                            _formKey.currentState.value['state accending'];
                            selected2.value =
                            _formKey.currentState.value['state decending'];
                          }
                        },
                      )
                    ],
                  );
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

GlobalKey<FormBuilderState> useFormKey() {
  return useState(GlobalKey<FormBuilderState>()).value;
}

Widget Function(List<String>) dropDownWithList(String attribute) =>
        (List<String> datas) =>
        Padding(
          padding: EdgeInsets.all(10),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: datas == null
                ? CircularProgressIndicator()
                : FormDropDown(
              attribute: attribute,
              options: datas,
            ),
          ),
        );

List<String> sortAscending(List<String> strings) {
  if (strings == null) {
    return null;
  }
  final currentList = [...strings];
  currentList.sort((a, b) => a.codeUnitAt(0).compareTo(b.codeUnitAt(0)));
  return currentList;
}

List<String> sortDescending(List<String> strings) {
  if (strings == null) {
    return null;
  }
  final currentList = [...strings];
  currentList.sort((a, b) => b.codeUnitAt(0).compareTo(a.codeUnitAt(0)));
  return currentList;
}

List<String> useApi(MockApi api) {
  final memo = useMemoized(api);

  final data = useFuture(memo);

  return data.data;
}

Future<List<String>> getMockData() {
  print("triggered");
  return Future.delayed(
      const Duration(seconds: 2), () => ['Malaysia', 'Indonesia', 'Singapore']);
}
