import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  // Define Valorant-inspired colors for consistency across the app
  static const Color valorantRed = Color(0xFFFF4655);
  static const Color valorantDarkBlue =
      Color(0xFF0F1923); // A very dark blue, almost black
  static const Color valorantGrey =
      Color(0xFF272D38); // Dark grey for cards/background
  static const Color valorantLightGrey =
      Color(0xFFEFEFEF); // Off-white for text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue, // Main background color
      appBar: AppBar(
        title: const Text(
          'FEEDBACK', // Judul yang lebih sesuai dalam Bahasa Indonesia
          style: TextStyle(
            fontFamily: 'ValorantFont', // Custom font for game feel
            color: valorantLightGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 20,
          ),
        ),
        backgroundColor: valorantDarkBlue, // App bar matches background
        elevation: 0, // Flat app bar
        iconTheme:
            const IconThemeData(color: valorantLightGrey), // Back icon color
      ),
      body: Stack(
        children: [
          // Optional: Subtle background image for consistency with Dashboard
          Positioned.fill(
            child: Image.asset(
              'assets/valobackground.jpg', // Pastikan aset ini tersedia
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.1), // Sangat samar
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  valorantDarkBlue.withOpacity(0.4),
                  valorantDarkBlue.withOpacity(0.9),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Saran & Kesan untuk Mata Kuliah TPM', // Judul utama dalam Bahasa Indonesia
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ValorantFont',
                    fontSize: 26.0,
                    color: valorantRed, // Highlight title in Valorant Red
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30.0), // Increased spacing

                _buildSection(
                  context,
                  title: 'Saran:', // Judul bagian Saran
                  points: [
                    '1. Lebih baik membawa payung agar tidak kehujanan.',
                    '2. Tolong tambahkan soal kuis di Spada.',
                  ],
                ),
                const SizedBox(height: 30.0),

                _buildSection(
                  context,
                  title: 'Kesan:', // Judul bagian Kesan
                  points: [
                    '1. Sangat luar biasa dan keren!',
                    '2. Tingkatkan ketakwaan.',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent sections for suggestions/impressions
  Widget _buildSection(BuildContext context,
      {required String title, required List<String> points}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: valorantGrey, // Card background color
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: valorantDarkBlue.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: valorantRed.withOpacity(0.3), // Subtle red border
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(), // Uppercase titles for impact
            style: const TextStyle(
              fontFamily: 'ValorantFont',
              fontSize: 20.0,
              color: valorantLightGrey, // Section title in light grey
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const Divider(
            color: valorantRed, // Red divider for separation
            thickness: 2,
            height: 20,
            indent: 0,
            endIndent: 0,
          ),
          const SizedBox(height: 10.0),
          ...points
              .map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: valorantLightGrey
                            .withOpacity(0.9), // Slightly lighter text
                        height: 1.5, // Line height for readability
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
