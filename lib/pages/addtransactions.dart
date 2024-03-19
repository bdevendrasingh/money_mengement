import 'dart:core';

import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:expense_tracker/static.dart' as Static;
import 'package:flutter/services.dart';

class AddTransactions extends StatefulWidget {
  const AddTransactions({super.key});

  @override
  State<AddTransactions> createState() => _HomePageState();
}

class _HomePageState extends State<AddTransactions> {
  int? amount;
  String note = "Some expense";
  String type = 'Expense';
  DateTime selectedDate = DateTime.now();
  List<String> month = [
    "Jan",
    "Feb",
    "Mar",
    "April",
    "May",
    "June",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 12),
        lastDate: DateTime(2030, 12));
    // initialDate: selectedDate);
    if (picked != null && picked != selectedDate) {
      setState(() {
        // selectedDate=DateTime.now();
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xffe2e7ef),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Add Transactions',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Static.primaryColor),
                child: const Icon(Icons.attach_money_outlined,
                    color: Colors.white),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Amount",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.black.withOpacity(0.1)),
                      border: InputBorder.none),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                  onChanged: (value) {
                    //try catch used for exception handling example if request fails we throw an exception
                    try {
                      amount = int.parse(
                          value); //try allows us to define block of code to be tested for errors ehile being executed
                    } catch (value) {
                      //do something
                    }
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Static.primaryColor),
                child: const Icon(Icons.description, color: Colors.white),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Note on  transaction",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.black.withOpacity(0.1)),
                      border: InputBorder.none),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                  onChanged: (value) {
                    note = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Static.primaryColor),
                child: const Icon(Icons.moving_sharp, color: Colors.white),
              ),
              const SizedBox(
                width: 15,
              ),
              ChoiceChip(
                label: Text(
                  'Expense',
                  style: TextStyle(
                      color: type == 'Expense' ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                selectedColor: Static.primaryColor,
                selected: type == 'Expense' ? true : false,
                onSelected: (value) {
                  setState(() {
                    type = 'Expense';
                  });
                },
              ),
              const SizedBox(
                width: 15,
              ),
              // const ChoiceChip(
              //     label: Text(
              //       'Expense',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //     selected: false)
              ChoiceChip(
                label: Text(
                  'Income',
                  style: TextStyle(
                      color: type == 'Income' ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                selectedColor: Static.primaryColor,
                selected: type == 'Income' ? true : false,
                onSelected: (value) {
                  setState(() {
                    type = 'Income';
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 48,
            child: TextButton(
              onPressed: () {
                _selectedDate(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Static.primaryColor),
                    child: const Icon(Icons.date_range, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${selectedDate.day} ${month[selectedDate.month - 1]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                if (amount != null && note.isNotEmpty) {
                  DbHelper dbHelper = DbHelper();
                  await dbHelper.addData(amount!, note, type, selectedDate);
                  Navigator.of(context).pop();
                } else {
                  if (kDebugMode) {
                    print('Not all values added!');
                  }
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
