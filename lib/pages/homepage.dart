import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/pages/addtransactions.dart';
import 'package:expense_tracker/widgets/confirm_dialogue.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/static.dart' as Static;
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  DateTime today = DateTime.now();
  late SharedPreferences preferences;
  late Box box;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
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
  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataSet = [];
    // entireData.forEach((key, value) {
    //   if (value['type'] == 'Expense' &&
    //       (value['date'] as DateTime).month == today.month) {
    //     dataSet.add(
    //       FlSpot(
    //         (value['date'] as DateTime).day.toDouble(),
    //         (value['amount'] as int).toDouble(),
    //       ),
    //     );
    //   }
    // });
    List tempDataSet = [];
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == 'Expense') {
        tempDataSet.add(data);
      }
    }
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(FlSpot(tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble()));
    }
    // return [
    //   const FlSpot(1, 4),
    //   const FlSpot(2, 9),
    //   const FlSpot(3, 5),
    //   const FlSpot(7, 15),
    // ];
    return dataSet;
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalExpense = 0;
    totalBalance = 0;
    totalIncome = 0;
    // entireData.forEach((key, value) {
    //   // if (kDebugMode) {
    //   //   print(key);
    //   // }
    //   if (value['type'] == 'Income') {
    //     totalBalance += (value['amount'] as int);
    //     totalIncome += (value['amount'] as int);
    //   } else {
    //     totalBalance -= (value['amount'] as int);
    //     totalExpense += (value['amount'] as int);
    //   }
    // });
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == "Income") {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense += data.amount;
        }
      }
    }
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        // if (kDebugMode) {
        //   print(element);
        // }as
        items.add(
          TransactionModel(element['amount'] as int,
              element['date'] as DateTime, element['note'], element['type']),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xffe2e7ef),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const AddTransactions();
              },
            ),
          ).whenComplete(() {
            setState(() {});
          });
        },
        backgroundColor: Static.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred!'),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No value found!'),
              );
            }
            getTotalBalance(snapshot.data!);
            getPlotPoints(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.white70),
                            child: CircleAvatar(
                              maxRadius: 30,
                              child: Image.asset(
                                'assets/face.png',
                                height: 60,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Text(
                            "Welcome ${preferences.getString('name')}",
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Static.primaryColor),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70),
                        padding: const EdgeInsets.all(12.0),
                        child: const Icon(
                          Icons.settings,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.all(12.0),
                  child: Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Static.primaryColor, Colors.blueAccent],
                        ),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 13),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Total balance",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w200),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Rs $totalBalance",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(totalIncome.toString()),
                                cardExpense(totalExpense.toString())
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    ' Expenses',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Colors.black87),
                  ),
                ),
                dataSet.length < 2
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  offset: const Offset(0, 4))
                            ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 22),
                        margin: const EdgeInsets.all(12.0),
                        // height: 300,
                        child: const Text(
                          'Not enough values to render chart',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  offset: const Offset(0, 4))
                            ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 22),
                        margin: const EdgeInsets.all(12.0),
                        height: 300,
                        child: LineChart(
                          LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                    // spots: getPlotPoints(snapshot.data!),
                                    spots: getPlotPoints(snapshot.data!),
                                    isCurved: false,
                                    barWidth: 2.5,
                                    //  colors: [
                                    //   Static.primaryColor,
                                    //  ],
                                    color: Static.primaryColor.withOpacity(0.7))
                              ]),
                        ),
                      ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Recent Transactions',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        color: Colors.black87),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // Map dataAtIndex = {};
                    TransactionModel dataAtIndex;

                    try {
                      dataAtIndex = snapshot.data![index];
                    } catch (e) {
                      return Container();
                    }

                    if (dataAtIndex.type == 'Income') {
                      return incomeTile(dataAtIndex.amount, dataAtIndex.note,
                          dataAtIndex.date, index);
                    } else {
                      return expenseTile(dataAtIndex.amount, dataAtIndex.note,
                          dataAtIndex.date, index);
                    }
                    // return const Center(
                    //   child: Text('Unexpected error'),
                    // // );
                  },
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            );
          } else {
            return const Center(
              child: Text('Unexpected error occurred!'),
            );
          }
        },
        // child: const Center(
        //   child: Text('No Data!'),
        // ),
      ),
    );
  }

  // EdgeInsets newMethod() =>
  //     const EdgeInsets.symmetric(horizontal: 8, vertical: 13);

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white70,
          ),
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: 8.0),
          child: const Icon(
            Icons.arrow_downward,
            size: 27,
            color: Color.fromARGB(255, 102, 132, 104),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Income',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70),
            )
          ],
        )
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white70,
          ),
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(right: 8.0),
          child: const Icon(
            Icons.arrow_upward,
            size: 27,
            color: Colors.red,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70),
            )
          ],
        )
      ],
    );
  }

  Widget expenseTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: const Color(0xffced4eb),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.arrow_circle_up_outlined,
                  size: 28,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '-$value',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await showConfirmDialog(
          context,
          "WARNING",
          "This will delete this record. This action is irreversible. Do you want to continue ?",
        );
        if (answer != null && answer) {
          await dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: const Color(0xffced4eb),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down_outlined,
                      size: 28,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    '${date.day}${month[date.month - 1]}',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+$value',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
                Text(
                  note,
                  style: TextStyle(color: Colors.grey[800]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
