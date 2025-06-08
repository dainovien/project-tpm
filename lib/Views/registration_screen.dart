import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:crypto/crypto.dart';
import 'package:projectakhir_mobile/Models/user.dart';
import 'package:projectakhir_mobile/Views/login_screen.dart';
import 'package:projectakhir_mobile/Views/main.dart'; // Make sure boxName is defined and accessible here
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

  // Define Valorant-inspired colors for consistency
  static const Color valorantRed = Color(0xFFFF4655);
  static const Color valorantDarkBlue =
      Color(0xFF0F1923); // A very dark blue, almost black
  static const Color valorantGrey = Color(
      0xFF272D38); // Dark grey for cards/background, slightly lighter than darkBlue
  static const Color valorantLightGrey =
      Color(0xFFABB3BA); // For secondary text/hints
  static const Color valorantWhite = Color(0xFFFFFFFF); // For main text

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
        content: Text(
          message,
          style:
              const TextStyle(color: valorantWhite), // White text for snackbar
        ),
        backgroundColor: valorantRed, // Valorant Red for snackbar
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _register() async {
    if (_formfield.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (_myBox.containsKey(username)) {
        _showSnackbar('Username already exists');
      } else {
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();
        _myBox.add(UserModel(
          username: username,
          password: hashedPassword,
        ));
        _showSnackbar('Registration successful');
        await prefs
            .remove("username"); // Ensure user isn't logged in automatically
        _goToLogin();
      }
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue, // Base dark background
      body: Stack(
        children: [
          // Background Image (consistent with login_screen.dart)
          Image.asset(
            'assets/background.png', // Ensure this asset is available
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Gradient Overlay for depth and text readability (consistent with login_screen.dart)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  valorantDarkBlue.withOpacity(
                      0.6), // Slightly transparent dark blue at top
                  valorantDarkBlue
                      .withOpacity(0.9), // More opaque dark blue at bottom
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
                        // Valorant Logo (consistent with login_screen.dart)
                        Image.asset(
                          'assets/valorant-logo.png', // Ensure this asset is available
                          height: 70, // Slightly larger logo
                          width: 70,
                        ),
                        const SizedBox(width: 20), // More space
                        const Text(
                          "REGISTER", // Changed title to REGISTER
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

                    // TextFormField for Username (consistent styling with login_screen.dart)
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _usernameController,
                      style: const TextStyle(
                          color: valorantWhite), // White text for input
                      decoration: InputDecoration(
                        labelText: "USERNAME",
                        labelStyle: const TextStyle(
                            color: valorantLightGrey), // Light grey label
                        prefixIcon: const Icon(Icons.person,
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
                          borderSide: const BorderSide(
                              color: valorantRed,
                              width: 2.0), // Red border when focused
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0), // Error red
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20), // Inner padding
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25), // Increased spacing

                    // TextFormField for Password (consistent styling with login_screen.dart)
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: passToggle,
                      style: const TextStyle(
                          color: valorantWhite), // White text for input
                      decoration: InputDecoration(
                        labelText: "PASSWORD",
                        labelStyle: const TextStyle(
                            color: valorantLightGrey), // Light grey label
                        prefixIcon: const Icon(Icons.lock,
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
                              const BorderSide(color: valorantRed, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.redAccent, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 60),

                    // Register Button (consistent styling with login_screen.dart)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: valorantRed, // Valorant Red button
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Rounded corners for button
                          ),
                          elevation: 5, // Subtle shadow for depth
                        ),
                        child: const Text(
                          "REGISTER", // Button text changed to REGISTER
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

                    // Login Link (consistent styling with login_screen.dart)
                    InkWell(
                      onTap: _goToLogin,
                      child: const Text(
                        "Already have an account? Login here.",
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
}
