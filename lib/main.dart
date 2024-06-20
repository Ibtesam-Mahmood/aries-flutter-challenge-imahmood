import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/pages/home_screen.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // The seed data for the options contracts
  static const List<Map<String, dynamic>> optionsSeedData = [
    {
      "strike_price": 100,
      "type": "Call",
      "bid": 10.05,
      "ask": 12.04,
      "long_short": "Long",
      "expiration_date": "2025-12-17T00:00:00Z"
    },
    // {
    //   "strike_price": 102.50,
    //   "type": "Call",
    //   "bid": 12.10,
    //   "ask": 14,
    //   "long_short": "Long",
    //   "expiration_date": "2025-12-17T00:00:00Z"
    // },
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
  ];

  // Used by the BlocProvider to create the bloc
  ContractsBloc createBloc(BuildContext context) {
    // Parse the seed data into a list of OptionsContract objects
    final contracts =
        OptionsContractListExtension.fromJsonList(optionsSeedData);

    // Create a new bloc with the contracts
    final bloc = ContractsBloc();
    bloc.add(SetContractEvent(contracts));

    // Return the bloc
    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ibte\'s Options Profit Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: BlocProvider(create: createBloc, child: const HomePage()),
    );
  }
}
