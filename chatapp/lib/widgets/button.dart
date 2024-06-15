import 'package:flutter/material.dart';

/*Login Button*/
class Button extends StatelessWidget {
  final String btnText;
  final GestureTapCallback onClick;

  const Button({super.key,required this.btnText,required this.onClick,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            padding:  EdgeInsets.symmetric(vertical: 15.0,horizontal: 150.0),
            decoration: BoxDecoration(
              color:  Colors.grey,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(btnText,style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
