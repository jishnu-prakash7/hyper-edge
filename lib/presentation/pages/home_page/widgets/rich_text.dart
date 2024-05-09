import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/pages/suggession_page/suggession_screen.dart';
import 'package:social_media/presentation/widgets/common_widgets.dart';

class Richtext extends StatelessWidget {
  const Richtext({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(
            text: 'Go to  ',
            style: TextStyle(
                color: kBlack,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 15)),
        TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                customRoutePush(context, const SuggessionScreen());
              },
            text: 'Suggessions?',
            style: const TextStyle(
                color: kBlue,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: 15))
      ]),
    );
  }
}