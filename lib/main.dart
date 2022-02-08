import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:person_expenses/widgets/transaction_list.dart';

import './models/transaction.dart';
import 'widgets/add_transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.purple,
              secondary: Colors.amber,
            ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Personal Expenses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  final List<Transaction> _transactions = [
    Transaction(id: '1', amount: 10, title: 'Laptop1', date: DateTime.now()),
    Transaction(id: '2', amount: 20, title: 'Laptop2', date: DateTime.now()),
  ];
  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      title: title,
      date: date,
    );
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return NewTransaction(addTx: _addTransaction);
        });
  }

  List<Widget> _buildLandscapeWidget(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        children: <Widget>[
          Text('Show chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(value: _showChart, onChanged: (val) => setState(() => _showChart = val)),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      _showChart == true
          ? SizedBox(
              child: Chart(recentTransactions: _recentTransactions),
              height: ((mediaQuery.size.height) -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7)
          : txListWidget
    ];
  }

  List<Widget> _buildPortalWidget(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      SizedBox(
          child: Chart(recentTransactions: _recentTransactions),
          height:
              ((mediaQuery.size.height) - appBar.preferredSize.height - mediaQuery.padding.top) *
                  0.3),
      txListWidget
    ];
  }

  Widget _buildCupertinoScaffold(Widget bodyWidget, AppBar appBar) {
    return CupertinoPageScaffold(
      child: bodyWidget,
      navigationBar: appBar as ObstructingPreferredSizeWidget,
    );
  }

  Widget _buildMaterialScaffold(Widget bodyWidget, AppBar appBar) {
    return Scaffold(
      appBar: appBar,
      body: bodyWidget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? null
          : FloatingActionButton(
              onPressed: () => startAddNewTransaction(context),
              child: const Icon(Icons.add),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );

    final txListWidget = SizedBox(
        height:
            (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
        child: TransactionList(transactions: _transactions, deleteTransaction: _deleteTransaction));

    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscapeWidget(mediaQuery, appBar, txListWidget),
            if (!isLandscape) ..._buildPortalWidget(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? _buildCupertinoScaffold(bodyWidget, appBar)
        : _buildMaterialScaffold(bodyWidget, appBar);
  }
}
