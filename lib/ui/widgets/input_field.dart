import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/ui/size_config.dart';
import 'package:to_do_list/ui/theme.dart';

class InputField extends StatefulWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: titlestyle,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            width: SizeConfig.screenWidth,
            height: 52,
            padding: const EdgeInsets.only(
              left: 14,
            ),
            margin: const EdgeInsets.only(
              top: 8,
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  focusNode: widget == null ? myFocusNode : null,
                  style: subtitle,
                  readOnly: widget.widget == null ? false : true,
                  controller: widget.controller,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[350] : Colors.grey[700],
                  decoration: InputDecoration(
                    hintText: myFocusNode.hasFocus ? '' : widget.hint,
                    hintStyle: subtitle.copyWith(
                        color: Get.isDarkMode
                            ? (widget.widget == null
                                ? Colors.white.withOpacity(.5)
                                : Colors.white)
                            : (widget.widget == null
                                ? Colors.black.withOpacity(.5)
                                : Colors.black)),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 0)),
                  ),
                )),
                widget.widget ?? Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
