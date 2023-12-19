import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_button.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../controllers/trip_controller.dart';
import '../../utils/base/app_helper.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  static const String routeName = '/add-new-trip';
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _AddNewTripState();
}

class _AddNewTripState extends ConsumerState<CreateTripScreen> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  CroppedFile? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'اضافة رحلة جديده',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            File(image!.path),
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                        onPressed: () => _selectImage(),
                        icon: const Icon(Icons.add_a_photo)),
                  ),
                ],
              ),
              30.hSpace,
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
              14.hSpace,
              CustomTextField(
                controller: descController,
                hintText: 'وصف الرحلة',
                minLines: 1,
                keyBoardType: TextInputType.text,
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال وصف الرحلة';
                  }
                  return null;
                },
              ),
              14.hSpace,
              CustomTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                keyBoardType: TextInputType.phone,
                controller: priceController,
                hintText: 'سعر الرحله',
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'يرجي ادخال سعر الرحله';
                  }
                  return null;
                },
              ),
              14.hSpace,
              CustomButton(
                onTap: () {
                  if (formKey.currentState!.validate() && image != null) {
                    ref
                        .read(tripControllerProvider)
                        .addTrip(
                          tripName: nameController.text.trim(),
                          image: File(image!.path),
                          price: num.parse(priceController.text.trim()),
                          description: descController.text.trim(),
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

  void _selectImage() async {
    // print('Ali');
    image = await AppHelper.pickImage(context);
    setState(() {});
  }
}
