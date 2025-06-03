import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Models/user.dart';
import 'package:projectakhir_mobile/Views/dashboard.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:projectakhir_mobile/Views/main.dart';
import 'package:projectakhir_mobile/Views/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  bool passToggle = true;
  bool _isObscure = true;

  late Box<UserModel> _myBox;
  late SharedPreferences prefs;

  void initState() {
    super.initState();
    checkIsLogin();
    _myBox = Hive.box(boxName);
  }

  void checkIsLogin() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getString('username'));

    bool? isLogin = (prefs.getString('username') != null) ? true : false;

    if (isLogin && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DashboardPage(),
          ),
          (route) => false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _login() async {
    if (_formfield.currentState!.validate()) {
      bool found = false;
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      found = checkLogin(username, hashedPassword);

      if (!found) {
        _showSnackbar('Username or Password is Wrong');
        _isObscure = false;
      } else {
        await prefs.setString('username', username);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => DashboardPage(),
            ),
            (route) => false,
          );
        }
        _showSnackbar('Login Success');
        _isObscure = true;
      }
    }
  }

  // Navigate to RegisterScreen
  void _goToRegister() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Form(
                key: _formfield,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Valorant Logo
                        Image.asset(
                          'assets/valorant-logo.png',
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Valorant App",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _usernameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: passToggle,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[800],
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passToggle = !passToggle;
                            });
                          },
                          child: Icon(
                            passToggle
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _login,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        elevation: MaterialStateProperty.all<double>(8),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Container(
                        height: 50,
                        child: const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _goToRegister, // Navigate to RegisterScreen
                      child: const Text(
                        "Don't have an account? Register here.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int getLength() {
    return _myBox.length;
  }

  bool checkLogin(String username, String password) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _myBox.getAt(i)!.username &&
          password == _myBox.getAt(i)!.password) {
        ("Login Success");
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }

  bool checkUsers(String username) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _myBox.getAt(i)!.username) {
        found = true;
        break;
      } else {
        found = false;
      }
    }
    return found;
  }
}
