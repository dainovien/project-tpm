import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class TimeConverterPage extends StatefulWidget {
  @override
  _TimeConverterPageState createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  String wibTime = '';
  String witTime = '';
  String witaTime = '';
  String londonTime = '';

  // Define Valorant-inspired colors for consistency
  static const Color valorantRed = Color(0xFFFF4655);
  static const Color valorantDarkBlue = Color(0xFF0F1923);
  static const Color valorantGrey = Color(0xFF272D38);
  static const Color valorantLightGrey = Color(0xFFEFEFEF);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    // Timer updates every second to keep time accurate
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();

        // Calculate times based on WIB (GMT+7) and then adjust for other zones
        // The original logic for adding hours was relative to 'now',
        // which would make London time (GMT+1 in winter, GMT+2 in summer)
        // too far ahead if WIB is GMT+7.
        // For accurate time zones, you'd typically use TimeZone packages.
        // Given the constraint "tanpa merubah struktur logikanya,"
        // I will keep the existing additions, but note that for
        // real-world time conversions, a more robust solution
        // involving time zones (e.g., using `timezone` package) is needed.
        // Assuming 'now' is local time, these are offsets from local.

        wibTime = DateFormat('HH:mm:ss').format(now);
        witTime =
            DateFormat('HH:mm:ss').format(now.add(const Duration(hours: 1)));
        witaTime =
            DateFormat('HH:mm:ss').format(now.add(const Duration(hours: 2)));
        // Based on WIB (GMT+7), London (GMT+1 summer/GMT+0 winter) is -6 to -7 hours.
        // Your current logic adds 7 hours to local time for London, which is likely incorrect.
        // For now, I'll keep the `add(Duration(hours: 7))` as per your original code.
        londonTime =
            DateFormat('HH:mm:ss').format(now.add(const Duration(hours: 7)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue, // Consistent dark background
      appBar: AppBar(
        title: const Text(
          'GLOBAL TIME CONVERTER',
          style: TextStyle(
            fontFamily: 'ValorantFont', // Assuming you have this custom font
            color: valorantLightGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        backgroundColor: valorantDarkBlue, // Consistent dark app bar
        elevation: 0, // Flat app bar
        iconTheme:
            const IconThemeData(color: valorantLightGrey), // Bright back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Increased overall padding
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Distribute space evenly
          children: [
            _buildTimeCard(
                'WIB (Western Indonesia Time)', wibTime, valorantRed),
            _buildTimeCard(
                'WITA (Central Indonesia Time)', witaTime, valorantRed),
            _buildTimeCard(
                'WIT (Eastern Indonesia Time)', witTime, valorantRed),
            _buildTimeCard('LONDON (GMT+1/0)', londonTime, valorantRed),
          ],
        ),
      ),
    );
  }

  // Helper widget to build time display cards
  Widget _buildTimeCard(String zoneName, String time, Color accentColor) {
    return Container(
      width: double.infinity, // Take full width
      decoration: BoxDecoration(
        color: valorantGrey, // Card background
        borderRadius: BorderRadius.circular(15.0), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // Subtle shadow
          ),
        ],
        border: Border.all(
            color: accentColor.withOpacity(0.5), width: 1.5), // Accent border
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 20.0, horizontal: 25.0), // Larger padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          Text(
            zoneName.toUpperCase(), // Uppercase for zone name
            style: TextStyle(
              fontFamily: 'ValorantFont',
              fontSize: 18.0,
              color: valorantLightGrey
                  .withOpacity(0.8), // Subtler color for zone name
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            time,
            style: TextStyle(
              fontFamily: 'ValorantFont', // Apply Valorant font to time
              fontSize: 48.0, // Larger font size for time
              color: accentColor, // Time in Valorant red
              fontWeight: FontWeight.w900, // Extra bold for time
              letterSpacing:
                  3.0, // Increased letter spacing for digital clock feel
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(3.0, 3.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
