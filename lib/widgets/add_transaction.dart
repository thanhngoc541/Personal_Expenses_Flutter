import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction({Key? key, required this.addTx}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitTransaction() {
    if (_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty && enteredAmount <= 0 && _selectedDate == null) return;
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.pop(context);
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: (MediaQuery.of(context).viewInsets.bottom) + 10),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                // onChanged: (val) => title = val,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // onSubmitted: (val) => _submitTransaction(),
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No date chosen!'
                      : 'Picked date: ${DateFormat.yMd().format(_selectedDate!)}'),
                ),
                TextButton(
                    child: const Text('Choose date', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _presentDatePicker),
              ]),
              ElevatedButton(child: const Text('Add Transaction'), onPressed: _submitTransaction),
            ],
          ),
        ),
      ),
    );
  }
}
