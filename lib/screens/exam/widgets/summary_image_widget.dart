
import 'dart:io';

import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SammaryImageWidget extends StatelessWidget {
  const SammaryImageWidget({
    Key? key,
    required this.imageUrl,
    required this.fromNetwork,
  }) : super(key: key);

  final String imageUrl;
  final bool fromNetwork;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.screenWidth * 0.5,
            maxHeight: context.screenHeight * 0.2,
          ),
          child: fromNetwork
              ? Image.network(
                  (imageUrl),
                )
              : Image.file(File(imageUrl)),
        ),
      ),
    );
  }
}
