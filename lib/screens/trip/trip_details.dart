// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/models/trip_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'book_trip_screen.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel tripModel;
  const TripDetailsScreen({
    Key? key,
    required this.tripModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CachedNetworkImage(
            imageUrl: tripModel.imageTrip,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const TripAppBar(),
          Column(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: const EdgeInsets.only(top: 200).r,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      BigText(
                        text: tripModel.nameTrip,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      20.xSpace,
                      BigText(
                        text: 'سعر الفرد / ${tripModel.price} جنية',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      20.xSpace,
                      BigText(
                        textAlign: TextAlign.center,
                        text: tripModel.description,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      const Spacer(),
                      CustomButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return BookTripNow(
                                  price: tripModel.price,
                                );
                              },
                            ),
                          );
                        },
                        text: 'احجز الأن',
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TripAppBar extends StatelessWidget {
  const TripAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
