import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  String selectedCurrency = 'IDR'; // Mata uang input default
  double amount = 0;
  double usdResult = 0;
  double myrResult = 0;
  double brlResult = 0;
  double idrResult = 0;

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(Uri.parse(
        'https://api.exchangerate-api.com/v4/latest/$baseCurrency'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      double usdRate = data['rates']['USD'];
      double myrRate = data['rates']['MYR'];
      double brlRate = data['rates']['BRL'];
      double idrRate = data['rates']['IDR'];

      setState(() {
        if (selectedCurrency == 'IDR') {
          usdResult = amount * usdRate;
          myrResult = amount * myrRate;
          brlResult = amount * brlRate;
        } else if (selectedCurrency == 'USD') {
          idrResult = amount * idrRate;
          myrResult = amount * myrRate;
          brlResult = amount * brlRate;
        } else if (selectedCurrency == 'MYR') {
          usdResult = amount * usdRate;
          idrResult = amount * idrRate;
          brlResult = amount * brlRate;
        } else if (selectedCurrency == 'BRL') {
          usdResult = amount * usdRate;
          myrResult = amount * myrRate;
          idrResult = amount * idrRate;
        }
      });
    }
  }

  void convertCurrency() {
    double inputValue = double.parse(_textEditingController.text);

    setState(() {
      amount = inputValue;
    });

    fetchExchangeRates(selectedCurrency); // Memanggil fungsi untuk mengambil data kurs saat konversi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Text('Currency Converter'),
      ),
      body: Container(
        color: Colors.black, // Mengubah latar belakang menjadi hitam
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedCurrency,
              dropdownColor: Colors.grey[700], // Mengatur latar belakang dropdown menjadi abu-abu
              items: ['IDR', 'USD', 'MYR', 'BRL'].map((currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(
                    currency,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                  convertCurrency(); // Memanggil fungsi konversi saat mata uang berubah
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount in $selectedCurrency',
                labelStyle: TextStyle(color: Colors.white), // Mengubah warna teks label menjadi putih
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Mengubah warna garis input menjadi putih
                ),
              ),
              style: TextStyle(color: Colors.white), // Mengubah warna teks input menjadi putih
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: convertCurrency,
              child: Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800], // Mengubah warna latar belakang tombol menjadi abu
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (selectedCurrency != 'USD')
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'USD',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${usdResult.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (selectedCurrency != 'MYR')
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'MYR',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${myrResult.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (selectedCurrency != 'BRL')
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'BRL',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${brlResult.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                if (selectedCurrency != 'IDR')
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'IDR',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${idrResult.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}