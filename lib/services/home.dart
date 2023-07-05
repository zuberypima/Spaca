import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spaca/screens/usage_app.dart';
import 'package:spaca/screens/viewapps.dart';
import 'package:spaca/services/block.dart';
import 'package:spaca/services/blocksite.dart';
import 'package:spaca/services/functions/generalfunctions.dart';
import 'package:spaca/services/timeSelect.dart';
import 'package:spaca/services/time_slot.dart';
import 'package:spaca/services/usage.dart';
import 'package:spaca/services/white_list.dart';
import 'package:flutter_background/flutter_background.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool on = false;

  TextEditingController selectDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();


// for baxkkground

  // ignore: non_constant_identifier_names
  List<AppInfo>? app_list_data;

  @override
  void initState() {   
    
  FlutterBackground.initialize();
   FlutterLocalNotificationsPlugin().initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

    // WidgetsFlutterBinding.ensureInitialized();
ContorFunctions().requestPermissions();
    // initializeNotifications();
ContorFunctions().startBackgroundExecution();
    selectDateController.text = ""; //set the initial value of text field
    endDateController.text = ""; //set the initial value of text field

    fetchSocialMediaOnlysData();
    super.initState();
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  // ignore: non_constant_identifier_names
  final List<String> _app_packageNames = [
    'com.instagram.android', // instagram
    'com.facebook.orca', // facebook
    'com.facebook.katana',
    'com.facebook.lite', // facebook
    'com.example.facebook', // facebook
    'com.facebook.android', // facebook
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

  final TextEditingController textEditingController = TextEditingController();

  showChangeSMSDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change SMS Content'),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Perform actions with enteredText
                textEditingController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // ignore: non_constant_identifier_names

  listenApp() async {
    print('______inside Listen to App _____');
    DeviceApps.listenToAppsChanges().where((ApplicationEvent event) =>
        event.packageName == 'com.instagram.android');
    Application? app = await DeviceApps.getApp('com.instagram.android');

    print(app);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 39, 39),
        foregroundColor: Colors.black,
        title: const Text(
          'Ant-Smartphone Addiction',
          // style: TextStyle(color: Colors.black),
        ),
        leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer())),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Perform action for icon2
              showChangeSMSDialog();
            },
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              child: Image(
            image: AssetImage("images/time.PNG"),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          )),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
            ),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WhiteBoardScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.av_timer,
            ),
            title: const Text('Time Slot'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TimeSlotScreen()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assessment_outlined,
            ),
            title: const Text('App Usage'),
            onTap: () async {
              Navigator.pop(context);
              final PermissionStatus permissionStatus = await _getPermission();
              if (permissionStatus == PermissionStatus.granted) {
              } else {
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: const Text('Permissions error'),
                          content: const Text('Please enable contacts access '
                              'permission in system settings'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ));
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share_outlined,
            ),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.help,
            ),
            title: const Text('`Dark Mode'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.rate_review_outlined,
            ),
            title: const Text('Feedback'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Quick Action',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              // Number of columns in the grid
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BlockedWebViewWidget()));
                    // Your onTap function logic goes here
                    // This function will be called when the card is tapped
                    const Text('Card tapped!');
                  },
                  child:Card(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.web,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            'Block Site',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //     builder: (context) => const AppUsagePage()));
                             MaterialPageRoute(
                            builder: (context) => const UsageAppStatus()));
                    // Your onTap function logic goes here
                    // This function will be called when the card is tapped
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 50,
                          ), // Replace 'icon_name_3' with the desired icon
                          SizedBox(
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            'Usage Status',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlockAppOnScreen('packageName')));
                    // Your onTap function logic goes here
                    // This function will be called when the card is tapped
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.app_blocking,
                            size: 50,
                          ), // Replace 'icon_name_3' with the desired icon
                          SizedBox(
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            'Block App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'My Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: social_mediaComponent()),
          ],
        ),
      ),
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
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1.5, // Adjust the aspect ratio as needed
        ),
        itemCount: app_list_data!.length,
        itemBuilder: (context, index) {
          AppInfo app = app_list_data![index];
          return InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TimeSelect()));
              //print(index);
              // _show_Action_Dialog(index);
              // getUsageStats();
              // _getCurrentOpened();
              listenApp();
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.memory(app.icon!),
                    ),
                  ),
                  Text(app.name!),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
