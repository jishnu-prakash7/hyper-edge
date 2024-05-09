import 'package:flutter/material.dart';

Text privacyPolicySecondHeading({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    );
  }

  Text contentText({required String text}) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Text privacyPolicyMainHeading({required String title}) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    );
  }