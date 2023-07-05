import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

class UsageAppStatus extends StatefulWidget {
  const UsageAppStatus({super.key});

  @override
  State<UsageAppStatus> createState() => _UsageAppStatusState();
}

class _UsageAppStatusState extends State<UsageAppStatus> {
  List<AppUsageInfo> _infos = [];
  @override
  void initState() {
    super.initState();
    getUsageStats();
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);

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
        title: Text('Show Apps Usage'),
      ),
      body: ListView.builder(
          itemCount: _infos.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                  title: Text(_infos[index].appName), 
                  trailing: Text(_infos[index].usage.inSeconds.toString())),
            );
          }),
    );
  }

  checkUsagePercentage (double timeusage){

      // timeusage =
  }
}
