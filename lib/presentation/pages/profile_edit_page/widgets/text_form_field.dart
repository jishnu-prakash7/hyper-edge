import 'package:flutter/material.dart';

SizedBox profileEditTextFormField(
    {required BuildContext context,
    required String labeltext,
    required TextEditingController controller,
    // required String fieldEmptyMessage,
    // required String validationMessage,
    // required RegExp regEx,
    int? maxlines}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - 20,
    child: TextFormField(
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) {
      //   // if (value!.isEmpty) {
      //   //   return fieldEmptyMessage;
      //   // }
      //   if (!regEx.hasMatch(value!)) {
      //     return validationMessage;
      //   } else {
      //     return null;
      //   }
      // },
      controller: controller,
      maxLines: maxlines ?? 1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: .5),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        labelText: labeltext,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 102, 102, 102)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .6),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .6),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    ),
  );
}
