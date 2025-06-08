import 'package:flutter/material.dart';
import 'package:projectakhir_mobile/Models/user.dart';
import 'package:projectakhir_mobile/Views/dashboard.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:projectakhir_mobile/Views/main.dart'; // Pastikan boxName di define di sini atau tempat lain yang bisa diakses
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

  late Box<UserModel> _myBox;
  late SharedPreferences prefs;

  @override
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
        content: Text(
          message,
          style: TextStyle(color: Colors.white), // Text color for clarity
        ),
        backgroundColor: Color(0xFFFF4655), // Valorant Red for snackbar
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
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
    // Define Valorant-inspired colors
    const Color valorantRed = Color(0xFFFF4655);
    const Color valorantGrey =
        Color(0xFF1E2326); // Dark grey/black for backgrounds
    const Color valorantLightGrey =
        Color(0xFFABB3BA); // For secondary text/hints
    const Color valorantWhite = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: valorantGrey, // Set a base dark background
      body: Stack(
        children: [
          // Background Image
          // Ensure 'assets/background.png' is a suitable dark, atmospheric image
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Gradient Overlay for depth and text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  valorantGrey.withOpacity(
                      0.6), // Slightly transparent dark grey at top
                  valorantGrey
                      .withOpacity(0.9), // More opaque dark grey at bottom
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
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
                          'assets/valorant-logo.png', // Ensure this asset is available
                          height: 70, // Slightly larger logo
                          width: 70,
                        ),
                        const SizedBox(width: 20), // More space
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            fontFamily:
                                'ValorantFont', // Use a custom font that resembles Valorant's
                            fontSize: 40, // Larger title
                            fontWeight: FontWeight.bold,
                            letterSpacing:
                                3.0, // More letter spacing for impact
                            color: valorantWhite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 150), // Increased spacing
                    // TextFormField for Username
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _usernameController,
                      style: TextStyle(
                          color: valorantWhite), // White text for input
                      decoration: InputDecoration(
                        labelText: "USERNAME",
                        labelStyle: TextStyle(
                            color: valorantLightGrey), // Light grey label
                        prefixIcon: Icon(Icons.person,
                            color: valorantRed), // Valorant Red icon
                        filled: true,
                        fillColor: valorantGrey.withOpacity(
                            0.7), // Slightly lighter fill for contrast
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          borderSide: BorderSide.none, // No border by default
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: valorantLightGrey.withOpacity(0.5),
                              width: 1.0), // Subtle border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: valorantRed,
                              width: 2.0), // Red border when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Colors.redAccent, width: 2.0), // Error red
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20), // Inner padding
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25), // Increased spacing
                    // TextFormField for Password
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: passToggle,
                      style: TextStyle(
                          color: valorantWhite), // White text for input
                      decoration: InputDecoration(
                        labelText: "PASSWORD",
                        labelStyle: TextStyle(
                            color: valorantLightGrey), // Light grey label
                        prefixIcon: Icon(Icons.lock,
                            color: valorantRed), // Valorant Red icon
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
                            color: valorantLightGrey, // Eye icon color
                          ),
                        ),
                        filled: true,
                        fillColor: valorantGrey.withOpacity(0.7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: valorantLightGrey.withOpacity(0.5),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: valorantRed, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.redAccent, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 60),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: valorantRed, // Valorant Red button
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corners for button
                          ),
                          elevation: 5, // Subtle shadow for depth
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: valorantWhite,
                            fontSize: 20, // Larger font size
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5, // Spacing for button text
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Register Link
                    InkWell(
                      onTap: _goToRegister,
                      child: Text(
                        "Don't have an account? Register here.",
                        style: TextStyle(
                          color: valorantLightGrey, // Subtle color for link
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: valorantLightGrey,
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
