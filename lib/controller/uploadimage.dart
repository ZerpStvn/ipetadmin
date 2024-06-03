import 'dart:typed_data';

import 'package:flutter/material.dart';

class UploadImageField extends StatelessWidget {
  const UploadImageField({
    super.key,
    required this.xfiledti,
    this.title,
    required this.pickimage,
  });

  final Uint8List? xfiledti;
  final String? title;
  final Function pickimage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pickimage();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  xfiledti!.isNotEmpty
                      ? Container(
                          height: 50,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(xfiledti!))))
                      : Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(85, 158, 158, 158))),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(title ?? "")
                ],
              ),
              const Icon(Icons.add_a_photo_outlined)
            ],
          ),
        ),
      ),
    );
  }
}
