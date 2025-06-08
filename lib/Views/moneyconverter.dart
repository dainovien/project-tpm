import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  String selectedCurrency = 'IDR';
  double amount = 0;
  double usdResult = 0;
  double eurResult = 0;
  double kwdResult = 0;
  double idrResult = 0;

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> fetchExchangeRates(String baseCurrency) async {
    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$baseCurrency'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      double usdRate = data['rates']['USD'];
      double eurRate = data['rates']['EUR'];
      double kwdRate = data['rates']['KWD'];
      double idrRate = data['rates']['IDR'];

      setState(() {
        if (selectedCurrency == 'IDR') {
          usdResult = amount * usdRate;
          eurResult = amount * eurRate;
          kwdResult = amount * kwdRate;
          idrResult = amount;
        } else if (selectedCurrency == 'USD') {
          idrResult = amount * idrRate;
          eurResult = amount * eurRate;
          kwdResult = amount * kwdRate;
          usdResult = amount;
        } else if (selectedCurrency == 'EUR') {
          usdResult = amount * usdRate;
          idrResult = amount * idrRate;
          kwdResult = amount * kwdRate;
          eurResult = amount;
        } else if (selectedCurrency == 'KWD') {
          usdResult = amount * usdRate;
          eurResult = amount * eurRate;
          idrResult = amount * idrRate;
          kwdResult = amount;
        }
      });
    }
  }

  void convertCurrency() {
    double inputValue = double.tryParse(_textEditingController.text) ?? 0.0;

    setState(() {
      amount = inputValue;
    });

    if (amount > 0) {
      fetchExchangeRates(selectedCurrency);
    } else {
      setState(() {
        usdResult = 0;
        eurResult = 0;
        kwdResult = 0;
        idrResult = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = '0';
    convertCurrency();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color valorantRed = Color(0xFFFF4655);
    const Color valorantDarkBlue = Color(0xFF0F1923);
    const Color valorantGrey = Color(0xFF272D38);
    const Color valorantLightGrey = Color(0xFFEFEFEF);

    return Scaffold(
      backgroundColor: valorantDarkBlue,
      appBar: AppBar(
        backgroundColor: valorantDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: valorantLightGrey),
        title: const Text(
          'CURRENCY CONVERTER',
          style: TextStyle(
            fontFamily: 'ValorantFont',
            color: valorantLightGrey,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // INPUT FIELD + DROPDOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: valorantGrey,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AMOUNT TO CONVERT',
                    style: TextStyle(
                      fontFamily: 'ValorantFont',
                      color: valorantLightGrey.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'e.g., 100',
                            hintStyle: TextStyle(
                                color: valorantLightGrey.withOpacity(0.5)),
                            filled: true,
                            fillColor: valorantDarkBlue,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: valorantLightGrey.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: valorantRed, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                          ),
                          style: const TextStyle(
                              color: valorantLightGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          onChanged: (value) => convertCurrency(),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: valorantDarkBlue,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: valorantRed.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCurrency,
                            dropdownColor: valorantGrey,
                            style: const TextStyle(
                              fontFamily: 'ValorantFont',
                              color: valorantLightGrey,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: valorantRed),
                            items: ['IDR', 'USD', 'EUR', 'KWD']
                                .map((currency) => DropdownMenuItem<String>(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCurrency = value!;
                                convertCurrency();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25.0),

            Text(
              'CONVERTED AMOUNTS',
              style: TextStyle(
                fontFamily: 'ValorantFont',
                color: valorantLightGrey.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  String currencyCode;
                  double result;

                  switch (index) {
                    case 0:
                      currencyCode = 'IDR';
                      result = idrResult;
                      break;
                    case 1:
                      currencyCode = 'USD';
                      result = usdResult;
                      break;
                    case 2:
                      currencyCode = 'EUR';
                      result = eurResult;
                      break;
                    case 3:
                      currencyCode = 'KWD';
                      result = kwdResult;
                      break;
                    default:
                      currencyCode = '';
                      result = 0;
                  }

                  if (currencyCode == selectedCurrency) {
                    return const SizedBox.shrink();
                  }

                  return _buildResultCard(
                    currencyCode,
                    result.toStringAsFixed(2),
                    valorantGrey,
                    valorantRed,
                    valorantLightGrey,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String currency, String value, Color bgColor,
      Color accentColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currency,
            style: TextStyle(
              fontFamily: 'ValorantFont',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
