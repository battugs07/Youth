import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youth/core/constants/values.dart';
import 'package:youth/ui/styles/_colors.dart';

import '../../size_config.dart';

class SubButton extends StatelessWidget {
  final String? title;
  final VoidCallback press;
  final IconData? icon;
  const SubButton({
    Key? key,
    this.title,
    required this.press,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        //horizontal: getProportionateScreenWidth(15),
        vertical: getProportionateScreenHeight(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [shadow],
          borderRadius: BorderRadius.circular(
            getProportionateScreenWidth(8),
          ),
        ),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          onPressed: press,
          child: Row(
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 15,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title!.toUpperCase(),
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: primaryColor,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
