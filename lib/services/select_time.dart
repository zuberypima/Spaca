// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

// ignore: camel_case_types
class Select_TimeScreen extends StatefulWidget {
  String? packageName;

  Select_TimeScreen(

      this.packageName, {super.key}
      );
  @override
  State<Select_TimeScreen> createState() => _Select_TimeScreenState();
}

// ignore: camel_case_types
class _Select_TimeScreenState extends State<Select_TimeScreen> {
  bool _dailyMode = true;
  String? chooseEndTimeValue;
  bool _weekMode = true;
  String? chooseDayValue;

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('Select Time', style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: [
          _timeSpinnnerView(),
          const SizedBox(
            height: 16,
          ),

          SwitchListTile(
            value: _dailyMode,
            title: const Text(
              'Everyday',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Silence 1 hr On time setted',
            ),
            secondary: const Padding(
              padding: EdgeInsets.all(9.0),
              child: Icon(Icons.wifi),
            ),
            onChanged: (newValue) {
              setState(() {
                _dailyMode = newValue;
              });
            },
            activeColor: Colors.indigo,
          ),
         const Divider(),

          SwitchListTile(
            value: _weekMode,
            title: const Text(
              'EveryWeek',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: const Text(
              'Silence 1 hr On time setted',
            ),
            secondary: const Padding(
              padding: EdgeInsets.all(9.0),
              child: Icon(Icons.wifi),
            ),
            onChanged: (newValue) {
              setState(() {
                _weekMode = newValue;
              });
            },

            activeColor: Colors.indigo,
          ),
          const Divider(),
          Container(
            padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 0, bottom: 0),
            child: DropdownButton<String>(
              value: chooseEndTimeValue,
              hint: const Text('Select End Time Interval'),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.black, fontSize: 15),

              items: <String>[
                '15 Min',
                '30 Min',
                '1 Hour',
                '3 Hour',
                '6 Hour',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

              onChanged: (String? value) {
                print(value);
                setState(() {
                  chooseEndTimeValue = value;
                });
              },
            ),
          ),
          const Divider(),
          Container(
            // padding: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 0, bottom: 0),
                      child: DropdownButton<String>(
              value: chooseDayValue,
                        hint: const Text('Select Day'),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.black, fontSize: 15),

              items: <String>[
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),

              onChanged: (String? value) {
                print(value);
                setState(() {
                  chooseDayValue = value;
                  // _visible_tag = v;
                });
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        // margin: EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              spreadRadius: -4,
              blurRadius: 25,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child:   Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),

              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  _timeSpinnnerView() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          hourMinute15Interval(),
             Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: Text(
              '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}:${_dateTime.second.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// SAMPLE
  Widget hourMinute12H() {
    return TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinuteSecond() {
    return TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute15Interval() {
    return TimePickerSpinner(
      spacing: 40,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  Widget hourMinute12HCustomStyle() {
    return TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: const TextStyle(fontSize: 24, color: Colors.deepOrange),
      highlightedTextStyle: const TextStyle(fontSize: 24, color: Colors.yellow),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
