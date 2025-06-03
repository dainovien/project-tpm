import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Diri'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.0),
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/profil.jpg'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nama: Dainovien Marchmaurrel Dirangga Al Sherard',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'NIM: 123220215',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Kelas: IF-D',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Guru Favorit: Bapak Bagus',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Matkul Favorit: Pemrograman Mobile',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
