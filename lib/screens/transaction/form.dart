import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _accountNumberController =
      TextEditingController();

  final TextEditingController _valueNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteBank'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controller: _accountNumberController,
              hintText: '0000',
              labelText: 'Número da Conta',
            ),
            Editor(
              controller: _valueNumberController,
              hintText: '0,00',
              labelText: 'Valor',
              icon: Icons.monetization_on,
            ),
            ElevatedButton(
              child: const Text('Confirmar'),
              onPressed: () {
                createTransaction(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void createTransaction(BuildContext context) {
    final int? accountNumber = int.tryParse(_accountNumberController.text);
    final double? value = double.tryParse(_valueNumberController.text);
    if (accountNumber != null && value != null) {
      final createdTransaction =
          Transaction(value: value, accountNumber: accountNumber);
      Navigator.pop(context, createdTransaction);
    }
  }
}
