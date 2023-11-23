import 'package:faenonibeqwa/models/trip_model.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/trip_controller.dart';
import '../../utils/base/app_images.dart';

class AddNewTrip extends ConsumerStatefulWidget {
  const AddNewTrip({super.key});

  @override
  ConsumerState<AddNewTrip> createState() => _AddNewTripState();
}

class _AddNewTripState extends ConsumerState<AddNewTrip> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const BigText(
          text: 'اضافة رحلة جديده',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'اسم الرحله',
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال اسم الرحله';
                  }
                  return null;
                },
              ),
              14.verticalSpace,
              CustomTextField(
                controller: descController,
                hintText: 'وصف الرحلة',
                maxLines: null,

                keyBoardTyp: TextInputType.emailAddress,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                // ],
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال وصف الرحلة';
                  }
                  return null;
                },
              ),
              14.verticalSpace,
              CustomTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                keyBoardTyp: TextInputType.phone,
                controller: priceController,
                hintText: 'سعر الرحله',
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال سعر الرحله';
                  }
                  return null;
                },
              ),
              14.verticalSpace,
              CustomButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    ref
                        .read(tripControllerProvider)
                        .addTrip(
                          TripModel(
                            nameTrip: nameController.text.trim(),
                            imageTrip: AppImages.tripImage,
                            price: num.parse(priceController.text.trim()),
                            description: descController.text.trim(),
                          ),
                        )
                        .then((value) => Navigator.pop(context));
                  }
                },
                text: 'أضافة رحلة جديده',
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
