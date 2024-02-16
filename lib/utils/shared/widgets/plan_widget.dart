import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'small_text.dart';

class PlanWidget extends StatelessWidget {
  final String title;
  // final String subtitle;
  final String price;
  final int index;
  final int selectedIndex;
  final String unit;
  final Function(int) onTap;
  const PlanWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.price,
    // required this.subtitle,
    required this.unit,
    required this.index,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap(index);
          // print(index);
          // print(selectedIndex);
        },
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: index == selectedIndex ? indicatorColor : Colors.white,
            border: index == selectedIndex
                ? Border.all(color: Colors.black)
                : Border.all(color: Colors.black.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallText(
                color: index == selectedIndex ? Colors.white : Colors.black,
                text: title,
                fontWeight: FontWeight.bold,
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'EG',
                      style: TextStyle(
                        // Set the color for the dollar sign
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.black,
                        fontSize: 10.0, // Adjust font size as needed
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: price,
                      style: TextStyle(
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.black,
                        fontSize: 24.0, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '/$unit',
                      style: TextStyle(
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.black,
                        // Customize the color of the unit text
                        // color: Colors.white,

                        fontSize: 14.0, // Adjust font size as needed
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
