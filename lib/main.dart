import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ByteBankApp());
}

class ByteBankApp extends StatelessWidget {
  const ByteBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
      ),
      home: const TransactionList(),
    );
  }
}

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
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
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

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Transaction> transactions = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionItem(transaction);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const TransactionForm();
              },
            ),
          ).then((receivedTransaction) {
            if (receivedTransaction != null) {
              setState(() {
                transactions.add(receivedTransaction);
              });
            }
          });
        },
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
