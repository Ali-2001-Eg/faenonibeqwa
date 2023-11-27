import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import 'add_new_trip_screen.dart';
import 'item_trip.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AddNewTrip();
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const BigText(
          text: 'الرحلات',
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<List<TripModel>>(
          stream: ref.read(tripControllerProvider).getTrip(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: BigText(text: 'لا يوجد رحلات بعد'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ItemTrip(
                  tripModel: snapshot.data![index],
                );
              },
            );
          }),
    );
  }
}
