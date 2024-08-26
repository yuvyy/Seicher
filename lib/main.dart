import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbHelper.init();
  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Password App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: MyHomePage(),
        routes: {
          '/newPasswordPage': (context) => NewPasswordPage(),
          '/viewPasswordsPage': (context) => ViewPasswordsPage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<PasswordEntry> items = [
    PasswordEntry(
        index: 0, name: 'Instagram', password: 'Something', show: false),
    PasswordEntry(
        index: 1, name: 'Facebook', password: 'Different', show: false),
    PasswordEntry(index: 2, name: 'Twitter', password: 'Passw0rd', show: false),
    PasswordEntry(index: 3, name: 'Telegram', password: 'qwerty', show: false),
    PasswordEntry(
        index: 4, name: 'Snapchat', password: '12345678', show: false),
    PasswordEntry(index: 5, name: 'Signal', password: 'Something', show: false),
    PasswordEntry(index: 6, name: 'Test', password: 'Something', show: false),
    PasswordEntry(index: 7, name: 'Test', password: 'Something', show: false),
    PasswordEntry(index: 8, name: 'Test', password: 'Something', show: false),
    PasswordEntry(index: 9, name: 'Test', password: 'Something', show: false),
    PasswordEntry(index: 10, name: 'Test', password: 'Something', show: false),
    PasswordEntry(index: 11, name: 'Test', password: 'Something', show: false),
  ];

  // List items = [];

  // void getList() async {
  //   Future<List> futureOfList = _query();
  //   items = await futureOfList;
  //   notifyListeners();
  // }

  void toggleShowPassword(int index) {
    items[index].show = !items[index].show;
    print(index);
    print(items[index].show);
    notifyListeners();
  }
}

class PasswordEntry {
  int index;
  String name;
  String password;
  bool show = false;

  PasswordEntry(
      {required this.index,
      required this.name,
      required this.password,
      required this.show});
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "S E I C H E R",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(19, 20, 19, 20),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/viewPasswordsPage'),
                  child: Text(
                    "Open Vault",
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () => print("I am pressed"),
                  child: Text(
                    "Delete Vault",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ));
  }
}

void _insert(String name, String password) async {
  // row to insert
  Map<String, dynamic> row = {
    DatabaseHelper.columnName: name,
    DatabaseHelper.columnPassword: password
  };
  final id = await dbHelper.insert(row);
  debugPrint('inserted row id: $id');
}

Future<List> _query() async {
  final allRows = await dbHelper.queryAllRows();
  debugPrint('query all rows:');
  for (final row in allRows) {
    debugPrint(row.toString());
  }
  return allRows;
}

class ViewPasswordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "S E I C H E R",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: ListView(
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  for (var item in appState.items)
                    Column(children: [
                      Container(
                        // color: Theme.of(context).colorScheme.secondaryContainer,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(5, 8))),
                        padding: EdgeInsets.all(15),
                        child: Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              item.show
                                  ? Text(
                                      item.password,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : Text(
                                      "*******",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          IconButton(
                              onPressed: () =>
                                  appState.toggleShowPassword(item.index),
                              icon: Icon(Icons.remove_red_eye_outlined)),
                          IconButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: item.password));
                              },
                              icon: Icon(Icons.copy)),
                          IconButton(
                              onPressed: () => print("I am pressed"),
                              icon: Icon(Icons.delete_outline)),
                          // IconButton(
                          //     onPressed: () => print("I am pressed"),
                          //     icon: Icon(Icons.edit)),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ]),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/newPasswordPage'),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
          child: Icon(Icons.add),
        ));
  }
}

class NewPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "S E I C H E R",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: ListView(
          children: [
            Text(
              "Name",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
            ),
            TextField(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Password",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
            ),
            TextField(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Confirm Password",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).colorScheme.primary),
            ),
            TextField(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.resolveWith<BorderSide>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            );
                          }
                          return BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2);
                        },
                      ),
                    ),
                    onPressed: () => print("I am pressed"),
                    child: Text(
                      "Clear",
                      style: TextStyle(fontSize: 17),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary),
                    onPressed: () => print("I am pressed"),
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 17),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
