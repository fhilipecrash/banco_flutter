import 'package:flutter/material.dart';
import 'dart:math';

class BancoFlutter extends StatelessWidget {
  const BancoFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banco no Flutter - Prog 4 - 2023',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF0D120E),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const MyHomePage(
        title: 'BANCO FLUTTER',
      ),
    );
  }
}

class Transaction {
  final double amount;
  final bool isDeposit;
  final DateTime date;

  Transaction(this.amount, this.isDeposit, this.date);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();

  double get _balance {
    return _transactions.fold(
        0,
        (previousValue, element) => element.isDeposit
            ? previousValue + element.amount
            : previousValue - element.amount);
  }

  void _addTransaction(double amount, bool isDeposit) {
    setState(() {
      _transactions.add(Transaction(amount, isDeposit, DateTime.now()));
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Saldo: R\$ ${_balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Histórico de transações:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                controller: _scrollController,
                reverse: false,
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return Center(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            transaction.isDeposit
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: transaction.isDeposit
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${transaction.isDeposit ? "Depósito" : "Saque"} de R\$ ${transaction.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: transaction.isDeposit
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      subtitle: Center(
                        child: Text(
                            "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  double amount = Random().nextDouble() * 999.98 + 0.01;
                  _addTransaction(amount, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DA756),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  "Depósito",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  double amount = Random().nextDouble() * 999.99 + 0.01;
                  if (_balance - amount >= 0) {
                    _addTransaction(amount, false);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Saldo insuficiente!"),
                        content: Text(
                          "Seu saldo atual é de R\$${_balance.toStringAsFixed(2)} e você precisa de R\$${amount.toStringAsFixed(2)} para completar a transação. Por favor, tente novamente ou deposite mais dinheiro.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(
                                color: Color(0xFF1DA756),
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DA756),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  "Saque",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
