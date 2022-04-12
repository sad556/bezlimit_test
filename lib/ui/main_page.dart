import 'dart:math';

import 'package:bezlimit_test/ui/details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final selectedBox = RxnInt(null)..obs;
  final snackClosed = RxBool(true);
  final tappedBox = 0.obs;
  final int length = 8;
  late AnimationController animationController;
  late ScrollController verticalController;
  late ScrollController horizontalController;

  @override
  void onInit() {
    super.onInit();
    verticalController = ScrollController();
    horizontalController = ScrollController();
    animationController = AnimationController(
      vsync: this,
    );
    verticalController.addListener(() {
      animationController.value =
          (Get.height - verticalController.position.pixels) / Get.height;
      if (verticalController.position.pixels.floor() ==
              (Get.height / 2.5).floor() &&
          snackClosed.value == true) {
        snackClosed.value = false;
        Get.snackbar('Snack', 'message')
            .future
            .then((_) => snackClosed.value = true);
      }
    });
    selectedBox.listen((v) {
      if (v == null) return;
      horizontalController.animateTo(
        v * 116.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    verticalController.dispose();
    animationController.dispose();
    horizontalController.dispose();
    super.dispose();
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.put(MainController());
    final anim = Tween<double>(begin: 0, end: 2 * pi)
        .animate(controller.animationController);
    final circle = AnimatedBuilder(
      animation: anim,
      child: SvgPicture.asset(
        'assets/images/circle.svg',
        width: Get.width,
        height: Get.width,
      ),
      builder: (_, child) {
        return Transform.rotate(
          child: child,
          angle: anim.value,
        );
      },
    );
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (v) {
          return true;
        },
        child: Stack(
          children: [
            Positioned(
              top: -Get.width/3.5,
              left: -Get.width/2.5,
              child: circle,
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: controller.verticalController,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 2.5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    height: Get.height,
                    child: Column(
                      children: [
                        ...List.generate(
                          3,
                          (i) {
                            return RowWidget(index: i);
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        HorizontalScrollWidget()
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

class HorizontalScrollWidget extends StatelessWidget {
  final MainController controller = Get.find();

  HorizontalScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: controller.horizontalController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              ...List.generate(
                controller.length,
                (i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      controller.tappedBox.value = i + 1;
                      Get.to(() => DetailsPage());
                    },
                    child: Obx(
                      () => Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: i == controller.selectedBox.value
                              ? Colors.red
                              : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
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
    );
  }
}

class RowWidget extends StatelessWidget {
  final int flex;
  static const flexList = [7, 8, 6];

  RowWidget({
    Key? key,
    required int index,
  })  : flex = flexList[index],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        child: Row(
          children: [
            Flexible(
              flex: flex,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 9 - flex,
            )
          ],
        ),
      ),
    );
  }
}
