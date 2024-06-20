import 'package:flutter/material.dart';
import 'package:flutter_challenge/components/risk_reward_graph.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Options Profit Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(optionsData: [
        {
          "strike_price": 100,
          "type": "Call",
          "bid": 10.05,
          "ask": 12.04,
          "long_short": "Long",
          "expiration_date": "2025-12-17T00:00:00Z"
        },
        {
          "strike_price": 102.50,
          "type": "Call",
          "bid": 12.10,
          "ask": 14,
          "long_short": "Long",
          "expiration_date": "2025-12-17T00:00:00Z"
        },
        {
          "strike_price": 103,
          "type": "Put",
          "bid": 14,
          "ask": 15.50,
          "long_short": "Short",
          "expiration_date": "2025-12-17T00:00:00Z"
        },
        {
          "strike_price": 105,
          "type": "Put",
          "bid": 16,
          "ask": 18,
          "long_short": "Long",
          "expiration_date": "2025-12-17T00:00:00Z"
        }
      ]),
    );
  }
}

// TODO: Wipe
// class OptionsCalculator extends StatefulWidget {
//   const OptionsCalculator({super.key, required this.optionsData});

//   final List<Map<String, dynamic>> optionsData;

//   @override
//   State<OptionsCalculator> createState() => _OptionsCalculatorState();
// }

// class _OptionsCalculatorState extends State<OptionsCalculator> {
//   late List<OptionsContract> contracts;

//   @override
//   void initState() {
//     super.initState();
//     contracts = [
//       OptionsContractListExtension.fromJsonList(widget.optionsData)[0],
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text("Options Profit Calculator"),
//       ),
//       body: RiskRewardGraph(data: contracts),
//     );
//   }
// }
