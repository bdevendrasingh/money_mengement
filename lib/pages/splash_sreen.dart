import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/pages/add_name.dart';
import 'package:expense_tracker/pages/homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  DbHelper dbHelper = DbHelper();
//
  Future getSettingd() async {
    String name = await dbHelper.getName();
    if (name != '') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AddName(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getSettingd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xffe2e7ef),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            'assets/icon.png',
            width: 64,
            height: 64,
          ),
        ),
      ),
    );
  }
}
