import 'package:expense_tracker/controllers/db_helper.dart';
import 'package:expense_tracker/pages/homepage.dart';
import 'package:flutter/material.dart';

class AddName extends StatefulWidget {
  const AddName({super.key});

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DbHelper dbHelper = DbHelper();
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: const Color(0xffe2e7ef),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/icon.png',
                width: 64,
                height: 64,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'What shoud we call you?',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              margin: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Your name ", border: InputBorder.none),
                style: const TextStyle(fontSize: 20.0),
                onChanged: (value) => name = value,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  //check if there is name or not
                  if (name.isNotEmpty) {
                    //add to database nd move to home
                    dbHelper.addName(name);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const HomePage();
                      },
                    ));
                  } else {
                    //show snackbar error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                        backgroundColor: Colors.white,
                        content: const Text(
                          'Please enter a valid name',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Icon(Icons.navigate_next_outlined)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
