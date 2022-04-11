import 'dart:math';

import 'package:bezlimit_test/ui/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController animationController;
  late ScrollController verticalController;
  late ScrollController horizontalController;
  final rowFlex = [7, 8, 6];
  int? selectedBox;
  bool closed = true;

  @override
  void initState() {
    super.initState();
    verticalController = ScrollController();
    horizontalController = ScrollController();
    animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    verticalController.dispose();
    animationController.dispose();
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anim =
        Tween<double>(begin: 0, end: 2 * pi).animate(animationController);
    final circle = AnimatedBuilder(
      animation: anim,
      child: SvgPicture.asset(
        'assets/images/circle.svg',
        width: 300,
        height: 300,
      ),
      builder: (_, child) {
        return Transform.rotate(
          child: child,
          angle: anim.value,
        );
      },
    );
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (v) {
          if (v.depth == 0) {
            animationController.value = (size - v.metrics.pixels) / size;
            if (v.metrics.pixels.floor() == (size / 2.5).floor() && closed == true) {
              setState(() {
                closed = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Snack')),
              ).closed.then((value) => setState(() => closed = true));
            }
          }
          return true;
        },
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: circle,
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: verticalController,
              child: Column(
                children: [
                  SizedBox(
                    height: size / 2.5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    height: size,
                    child: Column(
                      children: [
                        ...List.generate(
                          3,
                          (i) {
                            return Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 20.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: rowFlex[i],
                                      child: Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(
                                      flex: 9 - rowFlex[i],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            controller: horizontalController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  ...List.generate(
                                    8,
                                    (i) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) => DetailsPage(
                                                maxLength: 8,
                                                currentIndex: i + 1,
                                              ),
                                            ),
                                          )
                                              .then(
                                            (value) {
                                              setState(() => selectedBox = value);
                                              horizontalController.animateTo(
                                                value * 116.0,
                                                duration:
                                                    const Duration(milliseconds: 500),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: i == selectedBox ? Colors.red : Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
