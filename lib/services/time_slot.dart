import 'package:flutter/material.dart';
import 'package:spaca/services/select_app.dart';

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({super.key});

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('My Blocked Apps', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () async {

              // do something

              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SelectAppScreen()));


            },
          )
        ],
      ),

      body: Container(),
    );
  }


}
