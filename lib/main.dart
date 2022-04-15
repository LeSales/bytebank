import 'package:flutter/material.dart';

void main() {
  runApp(const ByteBankApp());
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: TransactionForm(),
      ),
    );
  }
}

class TransactionForm extends StatelessWidget {
  TransactionForm({Key? key}) : super(key: key);

  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _valueNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ByteBank'),
      ),
      body: Column(
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
              final int? accountNumber =
                  int.tryParse(_accountNumberController.text);
              final double? value =
                  double.tryParse(_valueNumberController.text);
              if (![accountNumber, value].contains(null)) {
                final createdTransaction =
                    Transaction(value: value!, accountNumber: accountNumber!);
              }
            },
          )
        ],
      ),
    );
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? icon;

  const Editor({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          icon: icon != null ? Icon(icon) : null,
          labelText: labelText,
          hintText: hintText,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListTransaction extends StatelessWidget {
  const ListTransaction({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: Column(
        children: [
          TransactionItem(Transaction(value: 500, accountNumber: 12546)),
          TransactionItem(Transaction(value: 248, accountNumber: 12946)),
          TransactionItem(Transaction(value: 6987, accountNumber: 12366)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;
  const TransactionItem(this._transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text(_transaction.value.toString()),
        subtitle: Text(_transaction.accountNumber.toString()),
      ),
    );
  }
}

class Transaction {
  final double value;
  final int accountNumber;

  Transaction({
    required this.value,
    required this.accountNumber,
  });
}
