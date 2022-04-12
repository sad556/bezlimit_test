import 'package:bezlimit_test/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final MainController mainController = Get.find();
  late TextEditingController textController;

  @override
  void onInit() {
    super.onInit();
    textController =
        TextEditingController(text: mainController.tappedBox.string);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key}) : super(key: key);

  final DetailsController detailsController = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            maxLength:
                detailsController.mainController.length.toString().length,
            controller: detailsController.textController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CustomFormatter(detailsController.mainController.length),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          int? res = int.tryParse(detailsController.textController.text);
          detailsController.mainController.selectedBox.value =
              res == null ? res : res - 1;
          Get.back();
        },
      ),
    );
  }
}

class CustomFormatter extends TextInputFormatter {
  final int max;

  CustomFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    var v = int.tryParse(newValue.text);
    if (v == null || v > max) return oldValue;
    return newValue.copyWith(text: v.toString());
  }
}
