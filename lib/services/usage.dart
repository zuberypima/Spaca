import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:spaca/services/functions/generalfunctions.dart';
import 'package:spaca/services/home.dart';

class AppUsageInfo {
  String packageName;
  double usagePercent;

  AppUsageInfo(this.packageName, this.usagePercent);
}

class AppUsagePage extends StatefulWidget {
  const AppUsagePage({Key? key}) : super(key: key);

  @override
  State<AppUsagePage> createState() => _AppUsagePageState();
}

class _AppUsagePageState extends State<AppUsagePage> {
  List<AppInfo> appList = [];
  List<AppUsageInfo> appUsageList = [];
  List<AppInfo>? appListData;

  @override
  void initState() {
    fetchInstalledApps();
    super.initState();
  }

  fetchInstalledApps() async {
    List<AppInfo> appListItems =
        await InstalledApps.getInstalledApps(true, true);
    setState(() {
      appListData = appListItems;
      print('fetched');
    });

    // calculateAppUsage();
  }

  void calculateAppUsage() {
    appUsageList.clear();
    if (appListData != null) {
      for (var app in appListData!) {
        double usagePercent = calculateUsagePercent(app);
        AppUsageInfo appUsageInfo =
            AppUsageInfo(app.packageName!, usagePercent);
        appUsageList.add(appUsageInfo);
      }

      appUsageList.sort((a, b) => b.usagePercent.compareTo(a.usagePercent));
    }
  }

  double calculateUsagePercent(AppInfo app) {
    // Perform your app usage calculation logic here
    // You can use any method or library to calculate the usage percentage
    // and return the value as a double.
    // For example, you can use a package like `usage_stats` to calculate the usage.

    // Placeholder logic: Returning random usage percentage between 0 and 100.
    return (0 +
        (100 - 0) * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
  }

  @override
  Widget build(BuildContext context) {
    appUsageList.sort((a, b) => b.usagePercent.compareTo(a.usagePercent));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('App Usage'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const HomeScreen())
        //         );
          
        //   },
        // ),
      ),
      body: ListView.builder(
        itemCount: appListData?.length,
        itemBuilder: (context, index) {
          // AppInfo app = appListData![index];

          // double appUsagePercent = appUsageList
          //     .firstWhere((appUsage) => appUsage.packageName == app.packageName)
          //     .usagePercent;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              // child: Image.memory(app.icon!),
              child: Text('data'),
            ),
            // title: Text(app.name!),
             title: Text('ggg'),
            // subtitle: Text('Usage: ${appUsagePercent.toStringAsFixed(1)}%'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        ContorFunctions().fetchInstalledApps();
      }),
    );
  }
}
