import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme
{

  static const loginBtnColor = Colors.black;
  static const border = Colors.grey;
  static const canvas = Color(0xffF0FBF5);

  static InputDecoration customDecoration(String hintText,IconData prefixIcon)
  {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: GestureDetector(
        // onTap: () {
        //   iconColor = Colors.deepPurple;
        // },
        child: Icon(prefixIcon),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 16.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gapPadding: 10,
        borderSide: BorderSide(color: border, width: 2),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gapPadding: 10,
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        gapPadding: 10,
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: loginBtnColor, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }

  static getSnackBar({required String message,required Color color})
  {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 30,
      backgroundColor: color,
    ));
  }

  static customTextfield(TextEditingController controller,String text,IconData iconData,bool toHide) async
  {
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
        hintText: text,
          suffixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )
      ),
    );
  }
}