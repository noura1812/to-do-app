import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/services/notification_services.dart';
import 'package:to_do_list/services/theme_services.dart';
import 'package:to_do_list/ui/size_config.dart';
import 'package:to_do_list/ui/theme.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/task_tile.dart';

import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();

    notifyHelper.initializeNotification();
    _taskController.getTasks();
    notifyHelper.requestIOSPermissions();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selecteddate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          leading: IconButton(
              onPressed: () {
                ThemeServices().switchtheme();
              },
              icon: Get.isDarkMode
                  ? const Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.nightlight_round_outlined,
                      color: Colors.black,
                    )),
          actions: [
            IconButton(
                onPressed: () async {
                  _taskController.deletall();
                  notifyHelper.cancelAll();
                },
                icon: Icon(
                  Icons.cleaning_services_outlined,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                )),
            const CircleAvatar(
              backgroundImage: AssetImage('images/person.jpeg'),
              radius: 20,
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        body: Column(
          children: [
            _addtaskBar(),
            _addDataBar(),
            const SizedBox(
              height: 6,
            ),
            _showTasks()
          ],
        ));
  }

  _addtaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(_selecteddate),
                style: subheadingstyle,
              ),
              Text(
                'Today',
                style: headingstyle,
              )
            ],
          ),
          MyButton(
              label: '+ Add Task',
              ontp: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: RefreshIndicator(
        color: primaryClr,
        onRefresh: () {
          return _taskController.getTasks();
        },
        child: Obx((() {
          if (_taskController.tasklist.isEmpty) {
            return ListView(
              children: [_notasksmsg()],
            );
          } else {
            return ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.tasklist[index];
                var date = DateFormat.jm().parse(task.startTime!);
                var mytime = DateFormat('HH:mm').format(date);

                if (task.repeat == 'Daily' ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selecteddate.day) ||
                    (task.repeat == 'Weekly' &&
                        _selecteddate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    task.date == DateFormat.yMd().format(_selecteddate)) {
                  notifyHelper.scheduledNotification(
                      int.parse(mytime.toString().split(':')[0]),
                      int.parse(mytime.toString().split(':')[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                            onTap: () {
                              ontap(task, context);
                            },
                            child: TaskTile(task: task)),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.tasklist.length,
            );
          }
        })),
      ),
    );
  }

  _addDataBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: _selecteddate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (selectedDate) {
          setState(() {
            _selecteddate = selectedDate;
          });
        },
      ),
    );
  }

  _notasksmsg() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 6,
                      )
                    : const SizedBox(
                        height: 220,
                      ),
                SvgPicture.asset(
                  'images/task.svg',
                  height: 100,
                  color: primaryClr.withOpacity(.5),
                  semanticsLabel: 'Task',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Text(
                    'You do noy have any tasks yet !\nAdd new tasks to make your day poductive',
                    style: subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(
                        height: 120,
                      )
                    : const SizedBox(
                        height: 134,
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }

  ontap(Task task, BuildContext context) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
            color: Get.isDarkMode ? darkHeaderClr : Colors.white,
            borderRadius: BorderRadius.circular(20)),
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 0
                ? SizeConfig.screenHeight * .50
                : SizeConfig.screenHeight * .35)
            : (task.isCompleted == 0
                ? SizeConfig.screenHeight * .25
                : SizeConfig.screenHeight * .20),
        child: Column(
          children: [
            Flexible(
                child: Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            )),
            SizedBox(
              height: task.isCompleted == 0
                  ? 30
                  : SizeConfig.orientation == Orientation.landscape
                      ? 10
                      : 20,
            ),
            task.isCompleted == 0
                ? SizedBox(
                    width: SizeConfig.screenWidth * .8,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        _taskController.markascompleted(task.id!);
                        await notifyHelper.flutterLocalNotificationsPlugin
                            .cancel(task.id);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: primaryClr,
                      ),
                      child: Text(
                        'Task completed',
                        style: titlestyle.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: SizeConfig.screenWidth * .8,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  _taskController.delettask(task);
                  await notifyHelper.cancelNotifications(task.id);

                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  backgroundColor: Colors.red[300],
                ),
                child: Text(
                  'Delet task',
                  style: titlestyle.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
