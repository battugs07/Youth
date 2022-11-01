import 'package:flutter/material.dart';
import 'package:youth/ui/components/homeCategoryItem.dart' as AppTheme;
import 'package:flutter_svg/flutter_svg.dart';

class HomeCategoryItem extends StatefulWidget {
  Color? primaryColor;
  String? primaryIcon;
  String? primaryTitle;

  HomeCategoryItem({
    this.primaryColor,
    this.primaryIcon,
    this.primaryTitle,
  });

  @override
  _HomeCategoryItemState createState() => _HomeCategoryItemState();
}

class _HomeCategoryItemState extends State<HomeCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.primaryColor!.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0.0, 6),
          )
        ],
        color: widget.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          widget.primaryIcon!,
                          height: 45,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.primaryTitle!,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
