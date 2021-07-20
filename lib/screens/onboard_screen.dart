import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../constant.dart';

class Onboardscreen extends StatefulWidget {
  @override
  _OnboardscreenState createState() => _OnboardscreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _CurrentPage = 0;

List<Widget> _pages = [
  Column(children: [
    Expanded(child: Image.asset('images/enteraddress.png')),
    Text(
      'Set your deleviry location',
      style: kPageViewTextStyle,
      textAlign: TextAlign.center,
    ),
  ]),
  Column(
    children: [
      Expanded(child: Image.asset('images/orderfood.png')),
      Text(
        'Order Items from your favoirets shops',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/delivery.png')),
      Text(
        'Fastest delivery to your Doorstep',
        style: kPageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
];

class _OnboardscreenState extends State<Onboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _CurrentPage = index;
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _CurrentPage.toDouble(),
          decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              activeColor: Colors.lightBlue[600]),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
