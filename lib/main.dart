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
      },
    );
  }
}

class SignUpSection extends StatelessWidget {
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                signup(email, password);

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
              label: Text("Sign UP"))
        ])));
  }
}

signup(email, password) async {
  var url = Uri.parse("http://192.168.14.1:5000/signup"); // iOS
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
    return const Text("Welcome to the Landing Screen");
  }
}
