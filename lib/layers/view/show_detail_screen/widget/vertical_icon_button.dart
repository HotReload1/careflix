import 'package:careflix/core/configuration/styles.dart';
import 'package:flutter/material.dart';

class VerticalIconButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const VerticalIconButton(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
          CommonSizes.vSmallestSpace5v,
          Text(
            title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          )
        ],
      ),
    );
  }
}
