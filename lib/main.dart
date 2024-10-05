//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpSection(),
      routes: {
        LandingScreen.id: (context) => const LandingScreen(),
        LoginSection.id: (context) => LoginSection(),
        LogoutScreen.id: (context) => LogoutScreen(),
        Private.id: (context) => Private()
      },
    );
  }
}

class SignUpSection extends StatelessWidget {
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (token != null) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
    }

    checkToken();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CupertinoTextField(
                placeholder: "Email",
                onChanged: (value) {
                  email = value;
                })),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CupertinoTextField(
                placeholder: "Password",
                obscureText: true,
                onChanged: (value) {
                  password = value;
                })),
        TextButton.icon(
            onPressed: () async {
              await signup(email, password);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String? token = prefs.getString("token");
              print("token above");
              print(token);

              if (token != null) {
                Navigator.pushNamed(context, LandingScreen.id);
              }
            },
            icon: Icon(Icons.save),
            label: Text("Sign UP")),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginSection.id);
          },
          child: Text("Login"),
        ),
      ])),
    );
  }
}

signup(email, password) async {
  var url = Uri.parse("http://192.168.14.1:5000/signup");
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  await prefs.setString('token', parse["token"]);
}

class LoginSection extends StatelessWidget {
  static const String id = "LoginSection";
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
          ),
          child: SafeArea(
              child: ListView(padding: const EdgeInsets.all(16), children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                    placeholder: "Email",
                    onChanged: (value) {
                      email = value;
                    })),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoTextField(
                    placeholder: "Password",
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    })),
            TextButton.icon(
                onPressed: () async {
                  await login(email, password);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? token = prefs.getString("token");
                  print("token above");
                  print(token);

                  if (token != null) {
                    Navigator.pushNamed(context, LandingScreen.id);
                  }
                },
                icon: Icon(Icons.save),
                label: Text("Login"))
          ]))),
    );
  }
}

login(email, password) async {
  var url = Uri.parse("http://192.168.14.1:5000/login"); // iOS
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  print(response.body);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  await prefs.setString('token', parse["token"]);
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  static const String id = "LandingScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Welcome to the Landing Screen",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                // await prefs.setString('token', null);
                await prefs.remove('token');
                Navigator.pushNamed(context, LoginSection.id);
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class BottomNav extends StatefulWidget {
  BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, LandingScreen.id);
      }
      if (index == 1) {
        Navigator.pushNamed(context, Private.id);
      }
      if (index == 2) {
        Navigator.pushNamed(context, LogoutScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Logout',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}

class LogoutScreen extends StatelessWidget {
  static const String id = "LogoutScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("Logout")),
          TextButton.icon(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              Navigator.pushNamed(context, LoginSection.id);
            },
            icon: Icon(Icons.send),
            label: Text("Logout"),
          )
        ],
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

Future<Album> fetchAlbum() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  print(token);
  var url = Uri.parse("http://192.168.14.1:5000/signup");

  final response = await http.get(url, headers: {
    if (token != null) "token": token,
  });
  print(response.statusCode);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String msg;

  Album({required this.msg});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      msg: json['msg'],
    );
  }
}

class Private extends StatefulWidget {
  static const String id = "Private";
  Private({Key? key}) : super(key: key);

  @override
  _PrivateState createState() => _PrivateState();
}

class _PrivateState extends State<Private> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.msg);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
