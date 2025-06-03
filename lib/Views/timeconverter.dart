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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        DateTime now = DateTime.now();
        wibTime = DateFormat('HH:mm:ss').format(now);
        witTime = DateFormat('HH:mm:ss').format(now.add(Duration(hours: 1)));
        witaTime = DateFormat('HH:mm:ss').format(now.add(Duration(hours: 2)));
        londonTime =
            DateFormat('HH:mm:ss').format(now.add(Duration(hours: 7)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Converter'),
        backgroundColor: Color(0xFF000000),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'WIB: $wibTime',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'WIT: $witTime',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'WITA: $witaTime',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF232323),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'London: $londonTime',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}