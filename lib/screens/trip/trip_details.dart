// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/ads/banner_widget.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:faenonibeqwa/models/trip_model.dart';

import 'book_trip_screen.dart';
import 'expand_text.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel tripModel;
  const TripDetailsScreen({
    Key? key,
    required this.tripModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CachedNetworkImage(
                    imageUrl: tripModel.imageTrip,
                    fit: BoxFit.cover,
                    height: context.screenHeight / 3.6,
                    width: double.infinity,
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BigText(
                          text: tripModel.nameTrip,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        20.hSpace,
                        BigText(
                          text: 'سعر الفرد / ${tripModel.price} جنية',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        20.hSpace,
                        ExpandableTextWidget(
                          text: tripModel.description,
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
                        ),
                        const BannerWidget(),
                      ],
                    ),
                  ),
                ),
              ],
              // child:
            ),
            const TripAppBar(),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            style: context.theme.iconButtonTheme.style!.copyWith(
              backgroundColor:
                  const MaterialStatePropertyAll<Color?>(Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
