import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:spaca/services/select_time.dart';
import 'package:usage_stats/usage_stats.dart';

class SelectAppScreen extends StatefulWidget {
  const SelectAppScreen({super.key});

  @override
  State<SelectAppScreen> createState() => _SelectAppScreenState();
}

class _SelectAppScreenState extends State<SelectAppScreen> {
  // ignore: non_constant_identifier_names
  List<AppInfo>? app_list_data;

  @override
  void initState() {
    fetchSocialMediaOnlysData();
    initUsage();
    super.initState();
  }

  // ignore: non_constant_identifier_names
  final List<String> _app_packageNames = [
    'com.instagram.android', // instagram

    'com.facebook.orca', // facebook
    'com.facebook.katana', // facebook
    'com.example.facebook', // facebook
    'com.facebook.android', // facebook
    'com.facebook.lite',

    'com.twitter.android', // twitter

    'com.zhiliaoapp.musically', // ticktok

    'com.whatsapp', // whatsapp
  ];

  fetchSocialMediaOnlysData() async {
    List<AppInfo> appListItems = [];

    for (AppInfo info in await InstalledApps.getInstalledApps(true, true)) {
      if (_app_packageNames.contains(info.packageName)) {
        appListItems.add(info);
      }
    }

    setState(() {
      app_list_data = appListItems;
      // next = body['next'];
    });

    return [];
  }

  List<EventUsageInfo> events = [];

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 1));

      List<EventUsageInfo> queryEvents =
          await UsageStats.queryEvents(startDate, endDate);

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          print(
              DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
                  .toIso8601String());

          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
              .toIso8601String());

          print(i.packageName);
          print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          print('-----\n');
        }
      }

      setState(() {
        events = queryEvents.reversed.toList();
      });
    } catch (err) {
      print(err);
    }
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('Select App', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () async {
              // do something
            },
          )
        ],
      ),
      body: social_mediaComponent(),
    );
  }

  // ignore: non_constant_identifier_names
  social_mediaComponent() {
    if (app_list_data == null) {
      return const Center(child: Text('Loading...'));
    } else if (app_list_data != null && app_list_data!.isEmpty) {
      // No Data
      return Column(children: [
        Image.asset("assets/images/no_data.gif"),
      ]);
    } else {
      return ListView.builder(
        itemCount: app_list_data!.length,
        itemBuilder: (context, index) {
          AppInfo app = app_list_data![index];

          return InkWell(
            onTap: () {
              print(app.packageName);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Select_TimeScreen('')));
              // getUsageStats();
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.memory(app.icon!),
                ),
                title: Text(app.name!),
                subtitle: Text(app.getVersionInfo()),
                // onTap: () =>
                //     InstalledApps.startApp(app.packageName!),
                // onLongPress: () =>
                //     InstalledApps.openSettings(
                //         app.packageName!),
              ),
            ),
          );
        },
      );
    }
  }
}
