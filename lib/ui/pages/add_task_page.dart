import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/size_config.dart';
import 'package:to_do_list/ui/theme.dart';
import 'package:to_do_list/ui/widgets/button.dart';
import 'package:to_do_list/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titlecontroler = TextEditingController();
  final TextEditingController _notecontroler = TextEditingController();

  DateTime _selecteddate = DateTime.now();
  String _starttime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endtime = DateFormat("hh:mm a")
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();

  int _selectedreminder = 5;
  List<int> remindlist = [5, 10, 15, 20];
  String _selectedrepeat = 'Non';
  List<String> repeatlist = ['Non', 'Daily', 'Weekly', 'Monthly'];

  int _selectedcolor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appbar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Add Task',
              style: headingstyle,
            ),
            InputField(
              title: 'Title',
              hint: "enter title here",
              controller: _titlecontroler,
            ),
            InputField(
              title: 'Note',
              hint: "enter note here",
              controller: _notecontroler,
            ),
            InputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_selecteddate),
              widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => _getDatefromuser()),
            ),
            Row(
              children: [
                Expanded(
                    child: InputField(
                  title: 'Start Time',
                  hint: _starttime,
                  widget: IconButton(
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () => _getTimefromuser(isStarttime: true)),
                )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputField(
                    title: 'End Time',
                    hint: _endtime,
                    widget: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getTimefromuser(isStarttime: false)),
                  ),
                ),
              ],
            ),
            dropdowbutton('Remind', _selectedreminder, remindlist),
            dropdowbutton('Repeat', _selectedrepeat, repeatlist),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                colorpalet(),
                MyButton(
                  label: 'Create task',
                  ontp: () {
                    _validatedate();
                  },
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Column colorpalet() {
    return Column(
      children: [
        Text(
          "Color",
          style: titlestyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(
                3,
                (int index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedcolor = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          backgroundColor: index == 0
                              ? primaryClr
                              : index == 1
                                  ? pinkClr
                                  : orangeClr,
                          radius: 14,
                          child: _selectedcolor == index
                              ? Icon(
                                  Icons.done,
                                  size: 16,
                                  color: Get.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                )
                              : null,
                        ),
                      ),
                    )))
      ],
    );
  }

  InputField dropdowbutton(String title, item, list) {
    return InputField(
        title: title,
        hint: title == 'Remind' ? '$item minutes early' : item,
        widget: Row(
          children: [
            DropdownButton(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: Colors.blueGrey,
                items: list.map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                      value: e.toString(),
                      child: Text(
                        '$e',
                        style: TextStyle(color: Colors.white),
                      ));
                }).toList(),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                elevation: 4,
                style: subtitle,
                underline: Container(
                  height: 0,
                ),
                onChanged: (val) {
                  setState(() {
                    if (item == _selectedreminder) {
                      val == null
                          ? null
                          : _selectedreminder = int.parse(val.toString());
                      //   item = _selectedreminder;
                    } else {
                      val == null ? null : _selectedrepeat = val.toString();
                      //item = _selectedrepeat;
                    }
                  });
                }),
            const SizedBox(
              width: 10,
            )
          ],
        ));
  }

  _validatedate() {
    if (_titlecontroler.text.isNotEmpty && _notecontroler.text.isNotEmpty) {
      _addtasktoDb();
      Get.back();
    } else if (_titlecontroler.text.isEmpty || _notecontroler.text.isEmpty) {
      Get.snackbar('Required ', 'All fields are required!!',
          duration: const Duration(seconds: 2),
          borderColor: Get.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          borderWidth: 2,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode
              ? darkGreyClr
              : const Color.fromARGB(255, 240, 240, 240),
          colorText: Colors.red,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addtasktoDb() async {
    try {
      int value = await _taskController.addTask(
          task: Task(
              title: _titlecontroler.text,
              note: _notecontroler.text,
              isCompleted: 0,
              date: DateFormat.yMd().format(_selecteddate).toString(),
              startTime: _starttime,
              endTime: _endtime,
              color: _selectedcolor,
              remind: _selectedreminder,
              repeat: _selectedrepeat));
    } catch (e) {}
  }

  _appbar() {
    return AppBar(
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 20,
        ),
        SizedBox(
          width: 20,
        )
      ],
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: primaryClr,
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  _getDatefromuser() async {
    DateTime? _pickeddate = await showDatePicker(
        context: context,
        initialDate: _selecteddate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    setState(() {
      _selecteddate = _pickeddate ?? DateTime.now();
    });
  }

  _getTimefromuser({required bool isStarttime}) async {
    TimeOfDay? _pickeddate = await showTimePicker(
        context: context,
        initialTime: isStarttime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(_endtime)));
    String _formatteddate = _pickeddate!.format(context);

    setState(() {
      if (isStarttime) {
        setState(() {
          _starttime = _formatteddate;
          var datnow = DateFormat("hh:mm a").parse(_starttime);
          _endtime = DateFormat("hh:mm a")
              .format(datnow.add(Duration(minutes: 15)))
              .toString();
        });
      } else {
        setState(() {
          _endtime = _formatteddate;
        });
      }
    });
  }
}
