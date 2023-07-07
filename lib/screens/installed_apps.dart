import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';

class AllInstalledApps extends StatefulWidget {
  const AllInstalledApps({super.key});

  @override
  State<AllInstalledApps> createState() => _AllInstalledAppsState();
}

class _AllInstalledAppsState extends State<AllInstalledApps> {
  // List<AppUsageInfo> _infos = [];
  List<AppInfo> _inforun = [];
  List<String?> blockedApps = [];
  @override
  void initState() {
    super.initState();
    // getUsageStats();
    fetchInstalledApps();
  }


  void fetchInstalledApps() async {
    List<AppInfo> appListItems =
        await InstalledApps.getInstalledApps(true, true);

    setState(() {
      _inforun = appListItems;
    });

    for (var info in appListItems) {
      print(info.toString());
    }
    print(appListItems);
  }
void toggleAppBlock(String? packageName) {
    setState(() {
      if (blockedApps.contains(packageName)) {
        blockedApps.remove(packageName);
        // showNotification('App unblocked successfully: $packageName');
      } else {
        blockedApps.add(packageName);
        // showNotification('App blocked successfully: $packageName');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('All installaed Apps'),
      ),
      body: ListView.builder(
          itemCount: _inforun.length,
          itemBuilder: (context, index) {
               bool isBlocked = blockedApps.contains(_inforun[index].name);
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.memory(_inforun[index].icon!),
                ),
                title: Text(_inforun[index].name.toString()),
                 trailing: GestureDetector(
              onTap: () => toggleAppBlock(_inforun[index].name),
              child: Icon(
                isBlocked ? Icons.lock : Icons.lock_open,
                color: isBlocked ? Colors.red : Colors.green,
              ),
            ),
              ),
            );
          }),
    );
  }

  checkUsagePercentage(double timeusage) {
    // timeusage =
  }
}
