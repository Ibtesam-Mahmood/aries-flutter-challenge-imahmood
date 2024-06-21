import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challenge/models/enums/enums.dart';
import 'package:flutter_challenge/models/options_contract.dart';
import 'package:flutter_challenge/util/state/contracts_bloc.dart';
import 'package:flutter_challenge/util/state/contracts_event.dart';
import 'package:intl/intl.dart';

class AddOptionModal extends StatefulWidget {
  /// The bloc to add the add event to
  final ContractsBloc bloc;

  const AddOptionModal({super.key, required this.bloc});

  static Future<void> show(BuildContext context) async {
    final bloc = context.read<ContractsBloc>();

    await showDialog(
      context: context,
      builder: (context) => AddOptionModal(
        bloc: bloc,
      ),
    );
  }

  @override
  State<AddOptionModal> createState() => _AddOptionModalState();
}

class _AddOptionModalState extends State<AddOptionModal> {
  /// Key for the form
  final _formKey = GlobalKey<FormState>();

  /// Option contract parameters
  OptionType type = OptionType.call;
  OptionPosition position = OptionPosition.long;
  double strikePrice = 0.0;
  double bid = 0.0;
  double ask = 0.0;
  DateTime expiry = DateTime.now().add(const Duration(days: 365));

  /// Select the date and time for the expiry
  void selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: expiry,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30 * 365)),
    );

    if (pickedDate != null) {
      // If the date picker is comleted, show the time picker
      final pickedTime = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: TimeOfDay.now());

      // If the time picker is completed, set the expiry
      if (pickedTime != null) {
        setState(() => expiry = pickedDate.copyWith(
              hour: pickedTime.hour,
              minute: pickedTime.minute,
            ));
      }
    }
  }

  /// Submit the form, creating a new options contract
  void submit() {
    // Ensure the form is valid
    if (_formKey.currentState?.validate() ?? false) {
      widget.bloc.add(
        AddContractEvent(OptionsContract(
          type: type,
          position: position,
          strikePrice: strikePrice,
          bid: bid,
          ask: ask,
          expiration: expiry,
        )),
      );

      // Close the modal
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Option Contract'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: [
              /// Option Type: Call or Put
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option Type'),
                  ToggleButtons(
                    isSelected:
                        OptionType.values.map((e) => e == type).toList(),
                    onPressed: (index) =>
                        setState(() => type = OptionType.values[index]),
                    children:
                        OptionType.values.map((e) => Text(e.name)).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              /// Option Position: Long or Short
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Option Position'),
                  ToggleButtons(
                    isSelected: OptionPosition.values
                        .map((e) => e == position)
                        .toList(),
                    onPressed: (index) =>
                        setState(() => position = OptionPosition.values[index]),
                    children:
                        OptionPosition.values.map((e) => Text(e.name)).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              /// Strike Price
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Strike Price',
                  prefix: Icon(
                    Icons.attach_money_rounded,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Strike Price is required';
                  }
                  final double? price = double.tryParse(value);

                  if (price == null) {
                    return 'Strike Price must be a number';
                  } else if (price <= 0) {
                    return 'Strike Price must be positive';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => strikePrice = double.tryParse(value) ?? 0.0),
              ),
              const SizedBox(height: 16.0),

              /// Ask Price
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bid Price',
                  prefix: Icon(
                    Icons.attach_money_rounded,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bid Price is required';
                  }
                  final double? price = double.tryParse(value);

                  if (price == null) {
                    return 'Bid Price must be a number';
                  } else if (price <= 0) {
                    return 'Bid Price must be positive';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => bid = double.tryParse(value) ?? 0.0),
              ),
              const SizedBox(height: 16.0),

              /// Ask Price
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ask Price',
                  prefix: Icon(
                    Icons.attach_money_rounded,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ask Price is required';
                  }
                  final double? price = double.tryParse(value);

                  if (price == null) {
                    return 'Ask Price must be a number';
                  } else if (price <= 0) {
                    return 'Ask Price must be positive';
                  }
                  return null;
                },
                onChanged: (value) =>
                    setState(() => ask = double.tryParse(value) ?? 0.0),
              ),
              const SizedBox(height: 16.0),

              /// Experation Date
              MaterialButton(
                color: Theme.of(context).colorScheme.primaryContainer,
                onPressed: selectDate,
                child: Text(
                    'Expires: ${DateFormat('MMM d, yyy h:mm a').format(expiry)}'),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Close the modal
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        TextButton(
          onPressed: submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
