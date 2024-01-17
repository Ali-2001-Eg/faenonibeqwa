import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/trip_model.dart';
import '../../utils/providers/app_providers.dart';
import '../../utils/shared/widgets/admin_floating_action_button.dart';
import 'create_trip_screen.dart';
import 'item_trip.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: const AdminFloatingActionButton(
        icon: Icons.add,
        routeName: CreateTripScreen.routeName,
        heroTag: 'createTrip',
      ),
      appBar: const CustomAppBar(title: 'الرحلات'),
      body: 
      
        ref.watch(tripStream).when(data: (data) {
      if (data.isEmpty) {
        return const Expanded(
          child: Center(
            child: BigText(
              text:  'لا يوجد رحلات بعد',
              fontSize: 28,
            ),
          ),
        );
      }
      return    ListView.builder(
              itemCount: data.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ItemTrip(
                  tripModel: data[index],
                );
              },
            );
    }, error: (error, stackTrace) {
      return BigText(text: error.toString());
    }, loading: () {
      return const Center(child: CustomIndicator());
    })
      
      
      
    );
  }
}
