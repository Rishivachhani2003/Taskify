// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, unnecessary_string_interpolations, unused_import, unused_local_variable

// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:to_do_riverpod/Module/taskcontroller.dart';
import 'package:to_do_riverpod/Module/todo.dart';
import 'package:to_do_riverpod/consts/constants.dart';
import 'package:to_do_riverpod/services/auth_services.dart';
import 'package:to_do_riverpod/services/task_services.dart';
import 'package:intl/intl.dart';
import 'package:to_do_riverpod/screens/new_task_screen.dart';
import 'package:to_do_riverpod/services/theme_services.dart';
import 'package:to_do_riverpod/widget/dialogs/delete_note_dialog.dart';
import 'package:to_do_riverpod/widget/drawer/navigation.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBannerLoaded = false;
  BannerAd? _bannerAd;

  DateTime today = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      //4 not deployed
      // adUnitId: 'ca-app-pub-6091503707312070/7924460505',
      /// 3
      adUnitId: 'ca-app-pub-6091503707312070/2374758537',

      ///2
      // adUnitId: 'ca-app-pub-6091503707312070/2143658399',

      /// 1
      // adUnitId: 'ca-app-pub-6091503707312070/1559466355',

      /// test unit id
      // adUnitId: 'ca-app-pub-3940256099942544/9214589741',

      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isBannerLoaded = false;
          print(error.toString());
          // toast(error.toString(), Get.isDarkMode);
        },
      ),
      request: AdRequest(),
    );
    _bannerAd!.load();
    super.initState();
    // initializeBannerAd();
    // _taskController.getTasks();
    // _foundTasks = _taskController.taskList;
    // notifyHelper = NotifyHelper();
    // notifyHelper?.requestIOSPermissions();
    // notifyHelper?.initializeNotification();
  }

  // List<TodoModule> _foundTasks = [];

  // Future<void> _onRefresh() async {
  //   _taskController.getTasks();
  // }

  // initializeBannerAd() async {
  // bannerAd = BannerAd(
  //   size: AdSize.banner,
  //   adUnitId: 'ca-app-pub-6091503707312070/7924460505', //4 not deployed
  //   // adUnitId: 'ca-app-pub-6091503707312070/2374758537',

  //   /// 3
  //   // adUnitId: 'ca-app-pub-6091503707312070/2143658399', ///2
  //   // adUnitId: 'ca-app-pub-6091503707312070/1559466355',

  //   /// 1
  //   // adUnitId: 'ca-app-pub-3940256099942544/9214589741',

  //   /// test unit id
  //   listener: BannerAdListener(
  //     onAdLoaded: (ad) {
  //       setState(() {
  //         isBannerLoaded = true;
  //       });
  //     },
  //     onAdFailedToLoad: (ad, error) {
  //       ad.dispose();
  //       isBannerLoaded = false;
  //       toast(error.toString(), Get.isDarkMode);
  //     },
  //   ),
  //   request: AdRequest(),
  // );
  // bannerAd!.load();
  // }

  String convertTimeTo24HourFormat(String time) {
    final inputFormat = DateFormat('h:mm a');
    final outputFormat = DateFormat('HH:mm');

    final dateTime = inputFormat.parse(time);
    return outputFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
      drawer: NavigationHomeScreen(),
      appBar: AppBar(
        backgroundColor: Get.isDarkMode
            ? Color.fromARGB(255, 50, 50, 50)
            : Color.fromARGB(255, 244, 240, 240),
        foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
        toolbarHeight: 80,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TaskTrek",
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${DateFormat("EEEE, dd MMMM").format(DateTime.now())}",
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.grey : Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    ThemeServices().switchTheme();
                  },
                  icon: Icon(
                    Get.isDarkMode
                        ? Icons.wb_sunny_outlined
                        : Icons.nightlight_round_outlined,
                    size: 24,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => NewTaskScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF4e5ae8),
                    ),
                    child: Text(
                      '+  Add',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(userCollection)
            .doc(AuthServices().getUid())
            .collection(todoCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.hasError.toString(),
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.data!.docs.length == 0) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/task.svg",
                    color: Colors.purple.withOpacity(0.5),
                    height: 90,
                    semanticsLabel: 'Task',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive.',
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];
                      Color categoryColor = Colors.white;
                      // var task = _taskController.taskList[index];
                      // var task = _foundTasks[index];
                      // final getCategory = task.category.toString();

                      final getCategory = data['category'];
                      switch (getCategory) {
                        case 'Learning':
                          categoryColor = Colors.green;
                          break;
                        case 'Working':
                          categoryColor = Colors.blue.shade700;
                          break;
                        case 'General':
                          categoryColor = Colors.amber.shade700;
                          break;
                      }

                      // DateFormat format = DateFormat("dd/MM/yyyy");
                      // String _selectedDate =
                      //     format.format(today).toString();

                      // if (task.repeat == 'Daily' ||
                      //     task.date == _selectedDate ||
                      //     (task.repeat == 'Weekly' &&
                      //         format
                      //                     .parse(_selectedDate)
                      //                     .difference(format.parse(
                      //                         task.date.toString()))
                      //                     .inDays %
                      //                 7 ==
                      //             0) ||
                      //     (task.repeat == 'Monthly' &&
                      //         format.parse(task.date.toString()).day ==
                      //             format.parse(_selectedDate).day)) {
                      //   try {
                      //     String time12HourFormat =
                      //         task.startTime.toString();
                      //     String time24HourFormat =
                      //         convertTimeTo24HourFormat(
                      //             time12HourFormat);
                      //     print(
                      //         'Time in 24-hour format: $time24HourFormat');

                      //     notifyHelper?.scheduledNotification(
                      //       int.parse(time24HourFormat.split(':')[0]),
                      //       int.parse(time24HourFormat.split(':')[1]),
                      //       task.titleTask.toString(),
                      //       task.description.toString(),
                      //       task.remind!,
                      //       task.repeat.toString(),
                      //       task.date.toString(),
                      //     );
                      //   } catch (e) {
                      //     print('Error parsing time: $e');
                      //   }
                      // }
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 1375),
                        child: SlideAnimation(
                          horizontalOffset: 300,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 13, right: 13, top: 8, bottom: 8),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        final shouldDelete =
                                            await showDeleteNoteDialog(context);
                                        if (shouldDelete) {
                                          setState(() {
                                            TaskServices().deleteTask(
                                                todoid: data['uid']);
                                          });
                                        }
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? Color.fromARGB(255, 56, 54, 54)
                                        : Color.fromARGB(255, 242, 239, 239),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: categoryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                        ),
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  data['titleTask'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 18,
                                                    decoration: data['isDone']
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  data['description'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 15,
                                                    decoration: data['isDone']
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                                trailing: Transform.scale(
                                                  scale: 1.5,
                                                  child: Checkbox(
                                                      activeColor:
                                                          Colors.blue.shade800,
                                                      value: data['isDone'],
                                                      shape: CircleBorder(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          TaskServices()
                                                              .updateTask(
                                                            todoid: data['uid'],
                                                            valueUpdate: value,
                                                          );
                                                        });
                                                      }),
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, -12),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Divider(
                                                        thickness: 1.5,
                                                        color: Colors.grey,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data['date']
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          Text(
                                                            data['startTime'],
                                                            style: TextStyle(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          Text(
                                                            data['endTime'],
                                                            style: TextStyle(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                isBannerLoaded == true
                    ? Container(
                        height: _bannerAd!.size.height.toDouble() * 2,
                        width: _bannerAd!.size.width.toDouble(),
                        child: AdWidget(
                          ad: _bannerAd!,
                        ),
                      )
                    : Container(),
              ],
            );
          }
        },
      ),
      // bottomNavigationBar: isBannerLoaded == true
      //     ? SizedBox(
      //         height: 80,
      //         child: AdWidget(
      //           ad: _bannerAd!,
      //         ),
      //       )
      // ? Container(
      // height: _bannerAd!.size.height.toDouble(),
      // width: _bannerAd!.size.width.toDouble(),
      // child: AdWidget(
      // ad: _bannerAd!,
      // ),
      // )
      // : Container(),
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (c) => NewTaskScreen()));
      //   },
      //   child: Container(
      //     alignment: Alignment.center,
      //     width: 100,
      //     height: 50,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(10),
      //       color: Color(0xFF4e5ae8),
      //     ),
      //     child: Text(
      //       '+  Add Task',
      //       style: const TextStyle(
      //         color: Colors.white,
      //         fontSize: 15,
      //       ),
      //       textAlign: TextAlign.center,
      //     ),
      //   ),
      // ),
    );
  }
}
