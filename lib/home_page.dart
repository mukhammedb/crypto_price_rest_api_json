import 'dart:async';
import 'dart:convert';

import 'package:crypto_price_rest_api_json/models/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utils/coin_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd6order=market_cap_desk6per_page=1086page=16sparkline=false'));
    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }

        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoin();
    Timer.periodic(const Duration(seconds: 10), (timer) => fetchCoin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text(
            'CRYPTOBASE',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              return CoinCard(
                  name: coinList[index].name,
                  symbol: coinList[index].symbol,
                  imageUrl: coinList[index].imageUrl,
                  price: coinList[index].price.toDouble(),
                  change: coinList[index].change.toDouble(),
                  changePercentage:
                      coinList[index].changePercentage.toDouble());
            }));
  }
}
