import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const Color valorantRed = Color(0xFFFF4655);
  static const Color valorantDarkBlue = Color(0xFF0F1923);
  static const Color valorantGrey = Color(0xFF272D38);
  static const Color valorantLightGrey = Color(0xFFEFEFEF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: valorantDarkBlue,
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontFamily: 'ValorantFont',
            color: valorantLightGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 20,
          ),
        ),
        backgroundColor: valorantDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: valorantLightGrey),
        foregroundColor: valorantLightGrey,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/valobackground.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.1),
            ),
          ),
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: valorantRed, width: 3.0),
                      boxShadow: [
                        BoxShadow(
                          color: valorantRed.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 70.0,
                      backgroundImage: AssetImage('assets/profil.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Profile Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: valorantGrey,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: valorantDarkBlue.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: valorantRed.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileDetail(
                          label: 'NAMA',
                          value: 'Dainovien Marchmaurrel Dirangga Al Sherard',
                        ),
                        _buildProfileDetail(label: 'NIM', value: '123220215'),
                        _buildProfileDetail(label: 'KELAS', value: 'IF-D'),
                        _buildProfileDetail(
                            label: 'DOSEN FAVORIT', value: 'Bapak Bagus'),
                        _buildProfileDetail(
                          label: 'MATA KULIAH FAVORIT',
                          value: 'Pemrograman Mobile',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail({
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'ValorantFont',
              fontSize: 14.0,
              color: valorantRed.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17.0,
              color: valorantLightGrey,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
