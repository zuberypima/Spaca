import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spaca/services/home.dart';
// ignore: must_be_immutable
class BlockAppOnScreen extends StatefulWidget {
  String? packageName;

  BlockAppOnScreen(this.packageName, {Key? key}) : super(key: key);

  @override
  State<BlockAppOnScreen> createState() => _BlockAppOnScreenState();
}

class _BlockAppOnScreenState extends State<BlockAppOnScreen> {
  List<AppInfo> appList = [];
  List<String?> blockedApps = [];
  List<AppInfo>? appListData;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    fetchInstalledApps();
    initializeNotifications();
    super.initState();
  }

  fetchInstalledApps() async {
    List<AppInfo> appListItems =
        await InstalledApps.getInstalledApps(true, true);
    setState(() {
      appListData = appListItems;
    });
  }

  void toggleAppBlock(String? packageName) {
    setState(() {
      if (blockedApps.contains(packageName)) {
        blockedApps.remove(packageName);
        showNotification('App unblocked successfully: $packageName');
      } else {
        blockedApps.add(packageName);
        showNotification('App blocked successfully: $packageName');
      }
    });
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.storage].request();
      return permissionStatus[Permission.storage] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  void initializeNotifications() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'App Blocker',
      message,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void blockApp(String? packageName) async {
    final PermissionStatus permission = await _getPermission();
    if (permission == PermissionStatus.granted) {
      setState(() {
        if (!blockedApps.contains(packageName)) {
          blockedApps.add(packageName);
          showNotification('App blocked successfully: $packageName');
        } else {
          blockedApps.remove(packageName);
          showNotification('App unblocked successfully: $packageName');
        }
      });
    } else {
      // Handle the case when permission is denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text('Apps Usage Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen()));

          },
        ),
      ),
      body: ListView.builder(
        itemCount: appListData?.length,
        itemBuilder: (context, index) {
          AppInfo app = appListData![index];
          bool isBlocked = blockedApps.contains(app.packageName);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.memory(app.icon!),
            ),
            title: Text(app.name!),
            trailing: GestureDetector(
              onTap: () => toggleAppBlock(app.packageName),
              child: Icon(
                isBlocked ? Icons.lock : Icons.lock_open,
                color: isBlocked ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
