import 'package:flutter/material.dart';

class CharBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercent;
  const CharBar(
      {Key? key, required this.label, required this.spendingAmount, required this.spendingPercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => Column(
            children: <Widget>[
              SizedBox(
                  height: constraints.maxHeight * 0.15,
                  child: FittedBox(child: Text('\$${spendingAmount.toStringAsFixed(0)}'))),
              SizedBox(height: constraints.maxHeight * 0.05),
              SizedBox(
                  height: constraints.maxHeight * 0.6,
                  width: 10,
                  child: Stack(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        color: const Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      heightFactor: spendingPercent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                  ])),
              SizedBox(height: constraints.maxHeight * 0.05),
              SizedBox(height: constraints.maxHeight * 0.15, child: FittedBox(child: Text(label))),
            ],
          )),
    );
  }
}
