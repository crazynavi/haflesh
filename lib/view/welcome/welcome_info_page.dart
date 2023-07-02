import 'package:flutter/material.dart';
import 'package:the_hafleh/common/values/colors.dart';
import 'package:the_hafleh/common/values/custom_text_style.dart';
import 'package:the_hafleh/common/widgets/button.dart';
import 'package:the_hafleh/view/info/create_info_page.dart';

class WelcomeInfoPage extends StatelessWidget {
  const WelcomeInfoPage({
    super.key,
  });

  static Page<void> page() =>
      const MaterialPage<void>(child: WelcomeInfoPage());
  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const WelcomeInfoPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(children: [
          SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/3.png",
                fit: BoxFit.cover,
              )),
          Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(251, 104, 94, 0.82),
                      Color.fromRGBO(247, 84, 162, 0.82),
                    ],
                    stops: [
                      0,
                      1
                    ]),
              ),
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [
                        const SizedBox(
                          height: 61,
                        ),
                        Image.asset(
                          "assets/icons/face.png",
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Showcase the person behind the profile using media and prompts",
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.getTitleStyle(
                              Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(children: <Widget>[
                          Expanded(
                              child: Button(
                                  title: "LET'S DO IT",
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push<void>(CreateInfoPage.route());
                                  })),
                        ]),
                        const SizedBox(height: 50),
                      ],
                    )
                  ]))
        ]));
  }
}
