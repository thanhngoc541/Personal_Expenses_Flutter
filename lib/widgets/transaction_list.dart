import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList({Key? key, required this.transactions, required this.deleteTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: ((context, constraints) => Column(children: <Widget>[
                  const Text('No transactions added yet!'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ])),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: transactions[index],
                deleteTransaction: deleteTransaction,
              );
            },
            itemCount: transactions.length,
          );
  }
}
