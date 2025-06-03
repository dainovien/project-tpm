import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'package:projectakhir_mobile/Models/user.dart';
import 'package:projectakhir_mobile/Views/login_screen.dart';
import 'package:projectakhir_mobile/Views/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formfield = GlobalKey<FormState>();
  bool passToggle = true;

  late SharedPreferences prefs;

  late Box<UserModel> _myBox;

  @override
  void initState() {
    super.initState();
    Initial();
    _myBox = Hive.box(boxName);
  }

  void Initial() async {
    prefs = await SharedPreferences.getInstance();
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

  Future<void> _register() async{
    if (_formfield.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (_myBox.containsKey(username)) {
        // Username already exists
        _showSnackbar('Username already exists');
      } else {
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();
        _myBox.add(UserModel(
          username: username,
          password: hashedPassword,
        ));
        _showSnackbar('Registration successful');
        await prefs.remove("username");
        _goToLogin();
      }
    }
  }

  // Navigate to LoginScreen
  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
          (route) => false,);
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
                          "Registration",
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
                          child: Icon(passToggle
                              ? Icons.visibility
                              : Icons.visibility_off, color: Colors.white),
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
                      onPressed: _register,
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
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}