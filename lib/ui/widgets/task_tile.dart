import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/size_config.dart';
import 'package:to_do_list/ui/theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key, required this.task}) : super(key: key);
  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      child: Container(
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: task.color == 0
                ? primaryClr
                : task.color == 1
                    ? pinkClr
                    : orangeClr,
          ),
          child: Row(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title!,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${task.startTime} -${task.endTime}',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 13.0,
                          )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      task.note!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 15.0,
                      )),
                    ),
                  ],
                ),
              )),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: .5,
                color: Colors.grey,
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  task.isCompleted == 1 ? 'Done' : 'To Do',
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  )),
                ),
              )
            ],
          )),
    );
  }
}
