import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:usage_stats/usage_stats.dart'; // Add this import for app usage stats

class TimeSelect extends StatefulWidget {
  const TimeSelect({Key? key}) : super(key: key);

  @override
  TimeSelectState createState() => TimeSelectState();
}

class TimeData {
  int? id;
  DateTime selectedTime;

  TimeData({this.id, required this.selectedTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'selectedTime': selectedTime.toIso8601String(),
    };
  }

  factory TimeData.fromMap(Map<String, dynamic> map) {
    return TimeData(
      id: map['id'],
      selectedTime: DateTime.parse(map['selectedTime']),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'time_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE times (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            selectedTime TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTime(TimeData timeData) async {
    final db = await instance.database;
    return await db.insert('times', timeData.toMap());
  }

  Future<List<TimeData>> getTimeDataList() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('times');
    return List.generate(maps.length, (i) {
      return TimeData.fromMap(maps[i]);
    });
  }
}

class TimeSelectState extends State<TimeSelect> {
  String appName = 'com.whatsapp'; // whatsapp
  int maxUsageTime = 10;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isAppBlocked = false; // Track if the app is currently blocked

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        checkAppUsage();
      });
    });
  }

  TextEditingController timeController = TextEditingController(text: '08:00');

  @override
  void dispose() {
    timer?.cancel();
    timeController.dispose();
    stopwatch.stop();
    super.dispose();
  }

  void _saveSelectedTime() async {
    final timeData = TimeData(
        selectedTime: DateTime.now().subtract(
            Duration(hours: selectedTime.hour, minutes: selectedTime.minute)));
    await DatabaseHelper.instance.insertTime(timeData);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Selected time saved.'),
    ));
  }

  Future<void> checkAppUsage() async {
    if (!isAppBlocked) {
      final timeDataList = await DatabaseHelper.instance.getTimeDataList();
      final currentTime = DateTime.now();
      final isTimeSet = timeDataList.isNotEmpty;
      final selectedTime = isTimeSet ? timeDataList.first.selectedTime : null;

      if (isTimeSet &&
          currentTime.hour == selectedTime!.hour &&
          currentTime.minute == selectedTime.minute) {
        blockApps();
      }
    } else {
      final currentTime = DateTime.now();
      final timeDataList = await DatabaseHelper.instance.getTimeDataList();
      final selectedTime =
          timeDataList.isNotEmpty ? timeDataList.first.selectedTime : null;

      if (selectedTime != null && currentTime.isAfter(selectedTime)) {
        unlockApps();
      }
    }
  }

  void blockApps() async {
    final List<UsageInfo> usageInfoList = await UsageStats.queryUsageStats(
      DateTime.now().subtract(const Duration(
          hours:
              1)), // Specify the duration you want to retrieve app usage stats for
      DateTime.now(), // Specify the end time for the app usage stats
    );

    final blockedApps = <String>[];
    for (final usageInfo in usageInfoList) {
      // Change the condition here as per your blocking criteria
      if (usageInfo.packageName == 'com.example.app') {
        blockedApps
            .add(usageInfo.packageName!); // Add '!' to assert non-nullability
      }
    }

    for (final packageName in blockedApps) {
      SystemChannels.platform.invokeMethod('SystemChannels.blockApp', {
        "appName": packageName,
      });
    }

    SystemChannels.platform.invokeMethod('SystemChannels.notification', {
      "title": "App Blocked",
      "body": "You have reached the maximum usage time for $appName.",
    });
    isAppBlocked = true;
  }

  Future<void> unlockApps() async {
    final List<UsageInfo> usageInfoList = await UsageStats.queryUsageStats(
      DateTime.now().subtract(const Duration(
          hours:
              1)), // Specify the duration you want to retrieve app usage stats for
      DateTime.now(), // Specify the end time for the app usage stats
    );

    final blockedApps = <String>[];
    for (final usageInfo in usageInfoList) {
      // Change the condition here as per your blocking criteria
      if (usageInfo.packageName == 'com.example.app') {
        blockedApps.add(usageInfo.packageName!);
      }
    }

    for (final packageName in blockedApps) {
      SystemChannels.platform.invokeMethod('SystemChannels.unblockApp', {
        "appName": packageName,
      });
    }

    isAppBlocked = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('App Block Time'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show the set app usage time or perform any desired action
              // You can display a dialog or show a bottom sheet to display the set time
              // You can access the selectedTime variable to get the time set by the user
              // Example:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Set App Usage Time'),
                    content: Text('Time set: ${selectedTime.format(context)}'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Select Time'),
              onPressed: () async {
                final selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selected != null) {
                  setState(() {
                    selectedTime = selected;
                  });
                }
              },
            ),
            ElevatedButton(
              child: const Text('Save Time'),
              onPressed: () {
                // ignore: unnecessary_null_comparison
                if (selectedTime != null) {
                  _saveSelectedTime();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please select a time first.'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
